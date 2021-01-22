//
//  ErrorBehaviour.swift
//  TeleSim
//
//  Created by KMI on 16.05.2020.
//  Copyright © 2020 4K-SOFT. All rights reserved.
//

import UIKit

protocol ErrorBehaviour {
    var separator: UIView { get }
    func showErrorBehavier()
    func hideErrorBehavier()
}

extension ErrorBehaviour {
    
    func showErrorBehavier() {
        separator.backgroundColor = UIColor.TextField.error
    }
    
    func hideErrorBehavier() {
        separator.backgroundColor = UIColor.white
    }
    
}
