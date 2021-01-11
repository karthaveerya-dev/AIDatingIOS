//
//  DeviceHelper.swift
//  RubetekUIKit
//
//  Created by Mihail Konoplitskyi on 6/13/18.
//  Copyright © 2018 Rubetek. All rights reserved.
//

import Foundation
import UIKit

class DeviceHelper {
    public static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
