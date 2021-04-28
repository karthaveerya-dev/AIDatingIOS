//
//
//
//  MainScreenViewController.swift
//	Avinash
//

import UIKit
import FBSDKLoginKit

class MainScreenViewController: UIViewController {
    var mainView = MainScreenView()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    private func initViewController() {        
        checkIfFacebookConnected()
        
        mainView.connectFacebookButton.addTarget(self, action: #selector(connectFacebookButtonTapped(_:)), for: .touchUpInside)
        mainView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
    }
}

//MARK: - helpers and handlers
extension MainScreenViewController {
    @objc func settingsButtonTapped(_ sender: UIButton) {
        self.openSettingsScreen()
    }
    
    private func openSettingsScreen() {
        ProgressHelper.show()
        ProfileService.shared.getProfile { (error) in
            ProgressHelper.hide()
            AlertHelper.show(message: error.localizedDescription, controller: self)
        } success: { (data) in
            ProgressHelper.hide()
            do {
                let defaultResponseModel = try JSONDecoder().decode(DefaultResponseModel.self, from: data)
                if defaultResponseModel.status {
                    let profileModel = try JSONDecoder().decode(ProfileDetailsResponseModel.self, from: data)
                    let settingsScreen = SettingsScreenViewController()
                    
                    let backButton = UIBarButtonItem(title: "", style: .plain, target: self.navigationController, action: nil)
                    settingsScreen.navigationItem.leftBarButtonItem = backButton
                    
                    settingsScreen.profileModel = profileModel.profile
                    
                    self.navigationController?.pushViewController(settingsScreen, animated: true)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                AlertHelper.show(message: NetworkError.errorSerializationJson.localizedDescription, controller: self)
            }
        }
    }
    
    private func checkIfFacebookConnected() {
        ProgressHelper.show()
        ProfileService.shared.checkIfFacebookConnected { (_) in
            ProgressHelper.hide()
        } success: { (data) in
            ProgressHelper.hide()
            do {
                let defaultResponseModel = try JSONDecoder().decode(DefaultResponseModel.self, from: data)
                if defaultResponseModel.status {
                    let facebookModel = try JSONDecoder().decode(CheckFacebookResponseModel.self, from: data)
                    self.mainView.isFacebookConnectedToProfile = facebookModel.profile.isConnected
                    
                    debugPrint("Facebook token is \(facebookModel.profile.isConnected ? "" : "not ")connected")
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                AlertHelper.show(message: NetworkError.errorSerializationJson.localizedDescription, controller: self)
            }
        }
        
    }
}

//MARK: - facebook sign in
extension MainScreenViewController {
    @objc private func connectFacebookButtonTapped(_ sender: UIButton) {
        connectFacebookToAccount()
    }
    
    func connectFacebookToAccount() {
        let facebookLoginManager = LoginManager()

        //user is logged out, trying to log in
        
        facebookLoginManager.logIn(permissions: ["email"], from: self) { [weak self] (result, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "Unexpected situation facebookLoginManager.logIn()")
                return
            }
            
            // Check for cancel
            guard let result = result, !result.isCancelled else {
                print("User cancelled login via Facebook")
                return
            }
            
            if let facebookToken = result.token {
                debugPrint("Successfully authorized via Facebook")
                
                debugPrint("Facebook token: \(facebookToken.tokenString)")
                debugPrint("Facebook token last refresh date: \(facebookToken.refreshDate)")
                debugPrint("Facebook token expiration date: \(facebookToken.expirationDate)")
                
                ProgressHelper.show()
                ProfileService.shared.saveFacebookToken(accessToken: facebookToken.tokenString,
                                                        facebookUserID: facebookToken.userID) { (error) in
                    ProgressHelper.hide()
                    AlertHelper.show(message: error.localizedDescription, controller: self)
                } success: { (data) in
                    ProgressHelper.hide()
                    do {
                        let defaultResponseModel = try JSONDecoder().decode(DefaultResponseModel.self, from: data)
                        if defaultResponseModel.status {
                            self?.checkIfFacebookConnected()
                        } else if let errorText = defaultResponseModel.errorText {
                            AlertHelper.show(message: errorText, controller: self)
                        }
                    } catch let error {
                        debugPrint(error.localizedDescription)
                        AlertHelper.show(message: NetworkError.errorSerializationJson.localizedDescription, controller: self)
                    }
                }
            }
        }
    }
}
