//
//  ProgressHelper.swift
//  Thor
//
//  Created by Mihail Konoplitskyi on 8/21/19.
//  Copyright © 2019 Mihail Konoplitskyi. All rights reserved.
//

import Foundation
import UIKit

class ProgressHelper: NSObject {
    static let shared = ProgressHelper()
    static var progressView: ProgressHelperView?
    
    static func show() {
        DispatchQueue.main.async {
            if progressView?.superview == nil {
                progressView = ProgressHelperView()
                
                if let keyWindow = UIApplication.shared.keyWindow {
                    keyWindow.addSubview(progressView!)
                    
                    progressView?.snp.makeConstraints { (make) in
                        make.edges.equalToSuperview()
                    }
                }
            }
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            progressView?.removeFromSuperview()
        }
    }
}
