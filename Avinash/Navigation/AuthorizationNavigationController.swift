//
//  AuthorizationNavigationController.swift
//  Avinash
//
//  Created by Mihail Konoplitskyi on 08.01.2021.
//

import Foundation
import UIKit

class AuthorizationNavigationController: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = .clear
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // Intro screen must have authorization logic inside
        // depends on auth state it must open needed screen
        let authorizationViewController = AuthorizationScreenViewController(authType: .signIn)
        viewControllers = [authorizationViewController]
        
        AuthorizationService.shared.delegate = self
    }
}

//MARK: - Authorization service delegate
extension AuthorizationNavigationController: AuthorizationServiceDelegate {
    func authStateChanged(to state: AuthorizationService.AuthorizationState) {
        if state == .authorized {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
