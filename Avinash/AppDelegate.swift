//
//  AppDelegate.swift
//  Avinash
//
//  Created by Mihail Konoplitskyi on 06.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let screenRect = UIScreen.main.bounds
        
        window = UIWindow(frame: screenRect)
        window?.backgroundColor = .white
        
        if let window = window {
            let appMainNavVC = AppMainNavigationController(nibName: nil, bundle: nil)
            window.rootViewController = appMainNavVC
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

