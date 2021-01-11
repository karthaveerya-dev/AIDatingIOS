//
//  AppMainNavigationController.swift
//  Touristdoc
//
//  Created by Mihail Konoplitskyi on 28.01.2020.
//  Copyright © 2020 4K-SOFT. All rights reserved.
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
        
        navigationBar.barStyle = .black
        navigationBar.backgroundColor = .clear
        navigationBar.isTranslucent = true
        navigationBar.isHidden = true
        
        // Intro screen must have authorization logic inside
        // depends on auth state it must open needed screen
        let introScreenVC = IntroScreenViewController()
        viewControllers = [introScreenVC]
    }
}
