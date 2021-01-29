//
//  ProgressHelperView.swift
//  Thor
//
//  Created by Mihail Konoplitskyi on 8/21/19.
//  Copyright © 2019 Mihail Konoplitskyi. All rights reserved.
//

import Foundation
import UIKit

class ProgressHelperView: UIView {
    var progressBackgroundView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.layer.cornerRadius = 14
        obj.clipsToBounds = true
        obj.backgroundColor = UIColor.lightGray
        return obj
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let obj = UIActivityIndicatorView(style: .whiteLarge)
        obj.tintColor = UIColor.ActivityIndicator.customPurple
        obj.color = UIColor.ActivityIndicator.customPurple
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        addSubview(progressBackgroundView)
        progressBackgroundView.addSubview(activityIndicator)
        
        progressBackgroundView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(SizeHelper.sizeW(150))
            make.height.equalTo(SizeHelper.sizeW(100))
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        activityIndicator.startAnimating()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
}
