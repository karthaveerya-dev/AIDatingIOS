//
//
//
//  UploadPhotosScreenViewController.swift
//	AIDating
//

import UIKit
import AVKit

class UploadPhotosScreenViewController: UIViewController {
    var mainView = UploadPhotosScreenView()
    var photosModel = [PhotoModel]() {
        didSet {
            validateUserInfo()
        }
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    private func initViewController() {
        //close screen navBar button
        let leftBarButton = UIBarButtonItem(customView: mainView.backButton)
        leftBarButton.customView?.snp.updateConstraints({ (make) in
            make.width.equalTo(40)
            make.height.equalTo(44)
        })
        navigationItem.leftBarButtonItem = leftBarButton
        
        //fake init photo models
        for idx in 0 ... 8 {
            var model = PhotoModel()
            if idx == 0 {
                model.image = UIImage(named: "avatarImage")
            }
            
            photosModel.append(model)
        }
        
        mainView.userPhotosCollectionView.dataSource = self
        mainView.userPhotosCollectionView.delegate = self
        mainView.userPhotosCollectionView.registerReusableCell(UserPhotoCollectionViewCell.self)
        
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

//MARK: - helpers and handlers
extension UploadPhotosScreenViewController {
    private func validateUserInfo() {
        let photos = photosModel.filter { (model) -> Bool in
            return model.image != nil
        }
        
        mainView.nextButton.isEnabled = photos.count > 0
        mainView.nextButton.alpha = (photos.count > 0 ? 1 : 0.5)
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        let images = photosModel.compactMap({$0.image})
        if images.count == 0 {
            return
        }
        
        ProgressHelper.show()
        ProfileService.shared.uploadPhotos(images: images) {
            ProgressHelper.hide()
            AlertHelper.show(message: NetworkError.technicalErrorOnClientSide.localizedDescription)
        } success: { (data) in
            ProgressHelper.hide()
            
            do {
                let defaultResponseModel = try JSONDecoder().decode(DefaultResponseModel.self, from: data)
                if defaultResponseModel.status {
                    AuthorizationService.shared.state = .authorized
                } else {
                    AlertHelper.show(message: defaultResponseModel.errorText, controller: self)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                AlertHelper.show(message: NetworkError.errorSerializationJson.localizedDescription, controller: self)
            }
        }
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func userPhotoActionButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview as? UserPhotoCollectionViewCell,
            let indexPath = mainView.userPhotosCollectionView.indexPath(for: cell) else {
            return
        }
        
        if cell.state == .set {
            let removePhotoAlertController = UIAlertController(title: "Remove photo", message: "Do you really want to remove photo?", preferredStyle: .alert)
            
            photosModel[indexPath.row].image = nil
            self.mainView.userPhotosCollectionView.reloadData()
        } else {
            let takePhotoAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let takePictureAction = UIAlertAction(title: "Take a picture", style: .default) { (action) in
                self.takePhotoFromCamera()
            }
            takePhotoAlertController.addAction(takePictureAction)
            
            let selectFromGalleryAction = UIAlertAction(title: "Import from library", style: .default) { (action) in
                let imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            takePhotoAlertController.addAction(selectFromGalleryAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            takePhotoAlertController.addAction(cancelAction)
            
            present(takePhotoAlertController, animated: true, completion: nil)
        }
    }
}

extension UploadPhotosScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UserPhotoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let row = indexPath.row
        let model = photosModel[row]
        
        cell.state = (model.image == nil ? .notSet : .set)
        cell.userPhotoImageView.image = model.image
        
        cell.actionButton.addTarget(self, action: #selector(userPhotoActionButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
}

extension UploadPhotosScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let _ = photosModel.enumerated().first { (idx, model) -> Bool in
                if model.image == nil {
                    photosModel[idx].image = image
                }
                
                return model.image == nil
            }
            
            picker.dismiss(animated: true, completion: nil)
            mainView.userPhotosCollectionView.reloadData()
        }
    }
    
    @objc private func takePhotoFromCamera() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            //we have permission to use camera
            openCameraPicker()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //we just gave permission to use camera
                    self.openCameraPicker()
                } else {
                    let errorStr = "You need to give permission to use camera"
                    let settingsAlertController = UIAlertController(title: errorStr, message: "", preferredStyle: UIAlertController.Style.alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    settingsAlertController.addAction(cancelAction)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                // Checking for setting is opened or not
                                //print("Setting is opened: \(success)")
                            })
                        }
                    })
                    settingsAlertController.addAction(settingsAction)
                    
                    DispatchQueue.main.async {
                        self.present(settingsAlertController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    private func openCameraPicker() {
        DispatchQueue.main.async {
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
