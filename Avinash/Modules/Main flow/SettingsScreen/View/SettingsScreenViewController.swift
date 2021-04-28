//
//
//
//  SettingsScreenViewController.swift
//	AIDating
//

import UIKit
import RangeSeekSlider

class SettingsScreenViewController: UIViewController {
    var mainView = SettingsScreenView()
    
    private var lookingForType: LookingForType = .female
    
    private var minAge: Int = 18
    private var maxAge: Int = 65
    
    private var minDistance: Int = 0
    private var maxDistance: Int = 10
    
    var name: String = ""
    var locationString = ""
    
    var profileModel: ProfileDetailsModel? {
        didSet {
            fillValues()
        }
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if mainView.nameTextField.text?.isEmpty == true {
            mainView.nameTextField.textField.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.nameTextField.textField.resignFirstResponder()
    }
    
    private func initViewController() {
        //location
        LocationService.shared.delegate = self
        LocationService.shared.locationManager.requestWhenInUseAuthorization()
        
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        
        mainView.maleLabel.delegate = self
        mainView.femaleLabel.delegate = self
        
        mainView.ageRangeSlider.delegate = self
        mainView.distanceRangeSlider.delegate = self
        
        mainView.nameTextField.textField.addTarget(self, action: #selector(passwordTextFieldDidChangeValue(_:)), for: .editingChanged)
        mainView.locationTextField.textField.addTarget(self, action: #selector(passwordTextFieldDidChangeValue(_:)), for: .editingChanged)
        mainView.logOutButton.addTarget(self, action: #selector(logOutButtonTapped(_:)), for: .touchUpInside)
        
        //EDITING PROFILE
        if let _ = self.profileModel {
            mainView.logOutButton.isHidden = false
            
            let leftBarButton = UIBarButtonItem(customView: mainView.backButton)
            leftBarButton.customView?.snp.updateConstraints({ (make) in
                make.width.equalTo(40)
                make.height.equalTo(44)
            })
            navigationItem.leftBarButtonItem = leftBarButton
            
            mainView.nextButton.isEnabled = true
            mainView.nextButton.alpha = 1
            
            let attributedString = NSAttributedString(string: "save".localized(),
                                                      attributes: [.foregroundColor: UIColor.black,
                                                                   .font: UIFont.ProximaNovaBold(size: 16) as Any])
            mainView.nextButton.setAttributedTitle(attributedString, for: .normal)
            
            mainView.backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        } else {
            //Update location string
            if let latitude = LocationService.shared.latitude,
               let longtitude = LocationService.shared.longtitude {
                LocationService.shared.getLocationString(lat: latitude, lon: longtitude) { [weak self] (locationString) in
                    self?.mainView.locationTextField.text = locationString
                }
            }
        }
    }
}

//MARK: - helpers and handlers
extension SettingsScreenViewController {
    @objc private func logOutButtonTapped(_ sender: UIButton) {
        AuthorizationService.shared.state = .noneAuthorized
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func fillValues() {
        guard let profileModel = profileModel else {
            return
        }
        
        lookingForType = profileModel.sex
        minAge = profileModel.ageFrom
        maxAge = profileModel.ageTo
        minDistance = profileModel.distanceFrom
        maxDistance = profileModel.distanceTo
        name = profileModel.userName
        locationString = profileModel.location
        
        switch lookingForType {
        case .male:
            mainView.maleLabel.lookingForLabelStatus = .selected
            mainView.femaleLabel.lookingForLabelStatus = .unselected
        case .female:
            mainView.femaleLabel.lookingForLabelStatus = .selected
            mainView.maleLabel.lookingForLabelStatus = .unselected
        }
        
        mainView.nameTextField.text = name
        
        mainView.ageRangeSlider.selectedMinValue = CGFloat(minAge)
        mainView.ageRangeSlider.selectedMaxValue = CGFloat(maxAge)
        
        mainView.distanceRangeSlider.selectedMinValue = CGFloat(minDistance)
        mainView.distanceRangeSlider.selectedMaxValue = CGFloat(maxDistance)
        
        mainView.locationTextField.text = locationString
        
        //uopdate UI
        self.rangeSeekSlider(mainView.ageRangeSlider, didChange: CGFloat(minAge), maxValue: CGFloat(maxAge))
        self.rangeSeekSlider(mainView.distanceRangeSlider, didChange: CGFloat(minDistance), maxValue: CGFloat(maxDistance))
    }
    
    @objc private func passwordTextFieldDidChangeValue(_ sender: UITextField) {
        guard let name = mainView.nameTextField.text,
              let location = mainView.locationTextField.text,
              name.length > 3,
              location.length > 3 else {
            mainView.nextButton.isEnabled = false
            mainView.nextButton.alpha = 0.5
            
            self.name = ""
            self.locationString = ""
            
            return
        }
        
        self.name = name
        self.locationString = location
        
        mainView.nextButton.isEnabled = true
        mainView.nextButton.alpha = 1
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        ProgressHelper.show()
        ProfileService.shared.saveProfile(username: name,
                                          locationString: locationString,
                                          distanceFrom: minDistance,
                                          distanceTo: maxDistance,
                                          sex: lookingForType,
                                          ageFrom: minAge,
                                          ageTo: maxAge,
                                          longtitude: Double(LocationService.shared.longtitude ?? 0),
                                          latitude: Double(LocationService.shared.latitude ?? 0)) { (error) in
            ProgressHelper.hide()
            AlertHelper.show(message: error.localizedDescription)
        } success: { (data) in
            ProgressHelper.hide()
            
            do {
                let defaultResponseModel = try JSONDecoder().decode(DefaultResponseModel.self, from: data)
                if defaultResponseModel.status {
                    if let _ = self.profileModel {
                        //editing existing profile
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        //registering new account
                        let uploadPhotosViewController = UploadPhotosScreenViewController()
                        self.navigationController?.pushViewController(uploadPhotosViewController, animated: true)
                    }
                } else {
                    AlertHelper.show(message: defaultResponseModel.errorText, controller: self)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                AlertHelper.show(message: NetworkError.errorSerializationJson.localizedDescription, controller: self)
            }
        }
    }
}

//MARK: - LookingForLabel Delegate
extension SettingsScreenViewController: LookingForLabelDelegate {
    func didTappedLookingForLabel(label: LookingForLabel) {
        self.lookingForType = label.lookingForType
    }
}

//MARK: - sliders delegate
extension SettingsScreenViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === mainView.ageRangeSlider {
            self.minAge = Int(minValue)
            self.maxAge = Int(maxValue)
            
            mainView.updateAgeTitle(minValue: minValue, maxValue: maxValue)
        } else if slider === mainView.distanceRangeSlider {
            self.minDistance = Int(minValue)
            self.maxDistance = Int(maxValue)
            
            mainView.updateDistanceTitle(minValue: minValue, maxValue: maxValue)
        }
    }
}

//MARK: - LocationService Delegate
extension SettingsScreenViewController: LocationServiceDelegate {
    func didUpdateLocation() {
        //Update location string
        if let latitude = LocationService.shared.latitude,
           let longtitude = LocationService.shared.longtitude {
            LocationService.shared.getLocationString(lat: latitude, lon: longtitude) { [weak self] (locationString) in
                self?.mainView.locationTextField.text = locationString
            }
        }
    }
}
