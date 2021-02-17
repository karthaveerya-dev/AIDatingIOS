//
//  Color+Ext.swift
//  Avinash
//
//  Created by Mihail Konoplitskyi on 08.01.2021.
//
import UIKit

@objc extension UIColor {
    class func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        let maxValue: CGFloat = 255
        return UIColor(red: r / maxValue, green: g / maxValue, blue: b / maxValue, alpha: a)
    }
    
    enum Button {
        static let customPurple = UIColor.rgba(112, 27, 84, 1)
    }
    
    enum MainScreenGradient {
        static let startColor = UIColor.rgba(112, 27, 84, 1)
        static let endColor = UIColor.rgba(235, 81, 82, 1)
    }
    
    enum TextField {
        static let error = UIColor.rgba(251, 210, 65, 1)
    }
    
    enum ActivityIndicator {
        static let customPurple = UIColor.rgba(112, 27, 84, 1)
    }
    
    enum AgeSlider {
        static let handleBorderColor = UIColor.rgba(150, 44, 83, 1)
        static let colorBetweenHandles = UIColor.white
        static let colorNotBetweenHandles = UIColor.white.withAlphaComponent(0.5)
    }
}
