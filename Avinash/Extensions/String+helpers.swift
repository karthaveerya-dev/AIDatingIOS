//
//  String.swift
//  Thor
//
//  Created by Mihail Konoplitskyi on 12/18/17.
//  Copyright © 2017 Mihail Konoplitskyi. All rights reserved.
//

import UIKit

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func substring(to: Int) -> String? {
        if to > length {
            return nil
        } else if to == length {
            return self
        }
        let toIndex = index(startIndex, offsetBy: to)
        return substring(to: toIndex)
    }
    
    func substring(from: Int) -> String? {
        if from >= length {
            return nil
        }
        let fromIndex = index(startIndex, offsetBy: from)
        return substring(from: fromIndex)
    }
    
    func substring(from: Int, to: Int) -> String? {
        if (from >= to || to >= length) {
            return nil
        }
        let fromIndex = index(startIndex, offsetBy: from)
        let toIndex = index(startIndex, offsetBy: to)
        let range = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return substring(with: range)
    }
    
    func substring(from: Int, length: Int) -> String? {
        if from + length > self.length {
            return nil
        }
        let fromIndex = index(startIndex, offsetBy: from)
        let toIndex = index(fromIndex, offsetBy: length)
        let range = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return substring(with: range)
    }
    
    mutating func insert(_ string: String, to index: Int) {
        if index < length {
            self = self.substring(to: index)! + string + self.substring(from: index)!
        } else if index == length {
            self += string
        }
    }
    
    mutating func replace(_ string: String, from: Int, length: Int) {
        delete(from: from, length: length)
        insert(string, to: from)
    }
    
    mutating func delete(from: Int, length: Int) {
        if from + length <= self.length {
            let fromIndex = index(startIndex, offsetBy: from)
            let toIndex = index(fromIndex, offsetBy: length)
            let range = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
            removeSubrange(range)
        }
    }
    
    public func locationChar(_ char: Character) -> Int? {
        if let index = index(of: char) {
            return distance(from: startIndex, to: index)
        }
        return nil
    }
    
    public func encoded() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    func base64ToImage() -> UIImage? {
        if let url = URL(string: self),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            return image
        }
        
        return nil
    }
}

extension StringProtocol {
    func nsRange<S: StringProtocol>(of string: S, options: String.CompareOptions = [], range: Range<Index>? = nil, locale: Locale? = nil) -> NSRange {
        self.range(of: string,
                   options: options,
                   range: range ?? startIndex..<endIndex,
                   locale: locale ?? .current)?
            .nsRange(in: self) ?? NSRange(location: 0, length: 0)
    }
    
    func nsRanges<S: StringProtocol>(of string: S, options: String.CompareOptions = [], range: Range<Index>? = nil, locale: Locale? = nil) -> [NSRange] {
        var start = range?.lowerBound ?? startIndex
        let end = range?.upperBound ?? endIndex
        var ranges: [NSRange] = []
        while start < end,
            let range = self.range(of: string,
                                   options: options,
                                   range: start..<end,
                                   locale: locale ?? .current) {
            ranges.append(range.nsRange(in: self))
            start = range.lowerBound < range.upperBound ? range.upperBound :
            index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return ranges
    }
}









