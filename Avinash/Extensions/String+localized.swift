//
//  String+localized.swift
//  Touristdoc
//
//  Created by Mihail Konoplitskyi on 28.01.2020.
//  Copyright © 2020 4K-SOFT. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
