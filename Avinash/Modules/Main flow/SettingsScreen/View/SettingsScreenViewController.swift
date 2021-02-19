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
    
    var profileModel: ProfileResponseModel?
    
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
        
        //Update location string
        if let latitude = LocationService.shared.latitude,
           let longtitude = LocationService.shared.longtitude {
            LocationService.shared.getLocationString(lat: latitude, lon: longtitude) { [weak self] (locationString) in
                self?.mainView.locationTextField.text = locationString
            }
        }
    }
}

//MARK: - helpers and handlers
extension SettingsScreenViewController {
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
        guard let _ = self.profileModel?.profile else {
            return
        }
        
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
                    let uploadPhotosViewController = UploadPhotosScreenViewController()
                    self.navigationController?.pushViewController(uploadPhotosViewController, animated: true)
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
