//
//  String+validation.swift
//  Touristdoc
//
//  Created by Mihail Konoplitskyi on 29.01.2020.
//  Copyright © 2020 4K-SOFT. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isEmptyOrTooShort() -> Bool {
        return self.length < 3
    }
}
