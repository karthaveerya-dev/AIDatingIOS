//
//  SearchNavigationController.swift
//  Avinash
//
//  Created by Mihail Konoplitskyi on 08.01.2021.
//

import Foundation
import UIKit

class SearchNavigationController: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Intro screen must have authorization logic inside
        // depends on auth state it must open needed screen
        let searchScreenVC = SearchScreenViewController()
        viewControllers = [searchScreenVC]
    }
}
