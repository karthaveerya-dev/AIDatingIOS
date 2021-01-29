//
//
//
//  AuthorizationScreenViewController.swift
//	Avinash
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class AuthorizationScreenViewController: UIViewController {
    var mainView = AuthorizationScreenView()
    var authType: AuthorizationType
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(authType: AuthorizationType) {
        self.authType = authType
        
        super.init(nibName: nil, bundle: nil)
    }

    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    private func initViewController() {
        GIDSignIn.sharedInstance()?.clientID = "473811394390-m1t8il4dr82ovahe2lhda9onchtmpg2s.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //close screen navBar button
        mainView.authType = authType
        
        let leftBarButton = UIBarButtonItem(customView: mainView.backButton)
        leftBarButton.customView?.snp.updateConstraints({ (make) in
            make.width.equalTo(40)
            make.height.equalTo(44)
        })
        navigationItem.leftBarButtonItem = leftBarButton
        
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        mainView.signInWithEmailButton.addTarget(self, action: #selector(signInWithEmailButtonTapped(_:)), for: .touchUpInside)
        mainView.createAccountButton.addTarget(self, action: #selector(createAccountButton), for: .touchUpInside)
        mainView.signInWithFacebookButton.addTarget(self, action: #selector(signInWithFacebookButtonTapped(_:)), for: .touchUpInside)
        mainView.signInWithGoogleButton.addTarget(self, action: #selector(signInWithGoogleButtonTapped(_:)), for: .touchUpInside)
    }
}

//MARK: - helpers and handlers
extension AuthorizationScreenViewController {
    @objc private func backButtonTapped(_ sender: UIButton) {
        if authType == .signIn {
            self.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func signInWithEmailButtonTapped(_ sender: UIButton) {
        if authType == .signIn {
            let enterEmailScreenVC = EnterEmailScreenViewController()
            navigationController?.pushViewController(enterEmailScreenVC, animated: true)
        } else if authType == .signUp {
            let signUpVC = SignUpScreenViewController()
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    @objc private func createAccountButton(_ sender: UIButton) {
        if authType == .signIn {
            let signUpVC = AuthorizationScreenViewController(authType: .signUp)
            navigationController?.pushViewController(signUpVC, animated: true)
        } else if authType == .signUp {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func signInWithGoogleButtonTapped(_ sender: UIButton) {
        if GIDSignIn.sharedInstance()?.currentUser == nil {
            //need to signIn
            debugPrint("Signing in with Google account...")
            GIDSignIn.sharedInstance()?.signIn()
        } else {
            //need to signOut
            GIDSignIn.sharedInstance()?.signOut()
            debugPrint("Signed out with Google account")
        }
        
        /*
         Note: The Sign-In SDK automatically acquires access tokens, but the access tokens will be refreshed only when you call signIn or restorePreviousSignIn. To explicitly refresh the access token, call the refreshTokensWithHandler: method. If you need the access token and want the SDK to automatically handle refreshing it, you can use the getTokensWithHandler: method.
         */
        
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
//        var gidAuth = GIDAuthentication()
//        gidAuth.refreshTokens { (auth, error) in
//            auth?.accessToken
//            auth?.refreshToken
//        }
    }
    
    @objc func signInWithFacebookButtonTapped(_ sender: UIButton) {
        let facebookLoginManager = LoginManager()
        
        if let _ = AccessToken.current {
            //user is logged in via facebook
            facebookLoginManager.logOut()
            
            debugPrint("User logged out from Facebook")
        } else {
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
                    
                    let requestedFields = "email, first_name, last_name"
                    GraphRequest.init(graphPath: "me", parameters: ["fields":requestedFields]).start { (connection, result, error) -> Void in
                        if let resultDict = result as? [String: Any] {
                            if let email = resultDict["email"] as? String {
                                debugPrint("Successfully got Facebook profile information")
                                self?.signUpWithSocialNetwork(email: email, token: facebookToken.userID)
                            }
                        }
                    }
                    
//                    Profile.loadCurrentProfile { (profile, error) in
//                        guard error == nil else {
//                            print(error?.localizedDescription ?? "Unexpected situation Profile.loadCurrentProfile()")
//                            return
//                        }
//
//                        debugPrint("Successfully got Facebook profile information")
//                    }
                }
            }
        }
    }
    
    private func signUpWithSocialNetwork(email: String, token: String) {
        ProgressHelper.show()
        AuthorizationService.shared.signInWithGoogle(email: email,
                                                     token: token) { (error) in
            ProgressHelper.hide()
            AlertHelper.show(message: error.localizedDescription)
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
}

//MARK: - Google SignIn delegate
extension AuthorizationScreenViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        debugPrint("Successfully signed in with Gooogle")
        debugPrint("userId - \(userId ?? "nil")")
        debugPrint("idToken - \(idToken ?? "nil")")
        debugPrint("fullName - \(fullName ?? "nil")")
        debugPrint("givenName - \(givenName ?? "nil")")
        debugPrint("familyName - \(familyName ?? "nil")")
        debugPrint("email - \(email ?? "nil")")
        
        signUpWithSocialNetwork(email: email ?? "", token: idToken ?? "")
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        debugPrint("Google user did disconnect - \(user)")
        debugPrint("Google user did disconnect - \(error)")
    }
}

enum AuthorizationType: Int {
    case signIn
    case signUp
}
