//
//  Device.swift
//  RubetekUIKit
//
//  Created by Mihail on 7/23/18.
//  Copyright © 2018 Rubetek. All rights reserved.
//

import Foundation
import UIKit

class DeviceVersion {
    static func getDeviceVersion() -> Device {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return .five
            case 1334:
                return .six
            case 1920, 2208:
                return .sixPlus
            case 1792, 2436, 2688:
                return .X
            default:
                return .unknown
            }
        }
        
        return .unknown
    }
    
    @objc(hasTopNotch) static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            // with notch: 44.0 on iPhone X, XS, XS Max, XR.
            // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
        }
        return false
    }
    
    @objc(hasBottomSafeAreaInsets) static var hasBottomSafeAreaInsets: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            // with home indicator: 34.0 on iPhone X, XS, XS Max, XR.
            // with home indicator: 20.0 on iPad Pro 12.9" 3rd generation.
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
}

enum Device: Int {
    case five = 0
    case six
    case sixPlus
    case X
    case unknown
}
