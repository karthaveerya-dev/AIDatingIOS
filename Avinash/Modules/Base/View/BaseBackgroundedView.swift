//
//  BaseBackgroundedView.swift
//  AIDating
//
//  Created by Mihail Konoplitskyi on 22.01.2021.
//

import Foundation
import UIKit

class BaseBackgroundedView: UIView {
    var gradientBackgroundView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private var gradientBackgroundViewLayer: CAGradientLayer = {
        let obj = CAGradientLayer()
        obj.colors = [UIColor.MainScreenGradient.startColor.cgColor, UIColor.MainScreenGradient.endColor.cgColor]
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
        backgroundColor = .white
        
        addSubview(gradientBackgroundView)
        gradientBackgroundView.layer.addSublayer(gradientBackgroundViewLayer)
        
        gradientBackgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientBackgroundViewLayer.frame = gradientBackgroundView.frame
    }
}
