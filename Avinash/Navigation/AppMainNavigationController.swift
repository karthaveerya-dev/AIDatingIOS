//
//  AppMainNavigationController.swift
//  AIDating
//
//  Created by Mihail Konoplitskyi on 29.01.2021.
//

import Foundation
import UIKit

class AppMainNavigationController: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barStyle = .default
        navigationBar.backgroundColor = .clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        // Intro screen must have authorization logic inside
        // depends on auth state it must open needed screen
        let mainScreenVC = MainScreenViewController()
        viewControllers = [mainScreenVC]
        
        AuthorizationService.shared.delegate = self
    }
}

//MARK: - heleprs and handlers
extension AppMainNavigationController: AuthorizationServiceDelegate {
    func authStateChanged(to state: AuthorizationService.AuthorizationState) {
        if state == .noneAuthorized {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
