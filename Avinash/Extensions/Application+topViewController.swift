//
//  Application+topViewController.swift
//  Touristdoc
//
//  Created by Mihail Konoplitskyi on 20.03.2020.
//  Copyright © 2020 4K-SOFT. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(_ base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
}
