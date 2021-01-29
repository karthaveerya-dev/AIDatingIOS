//
//  Range+Ext.swift
//  AIDating
//
//  Created by Mihail Konoplitskyi on 29.01.2021.
//

import Foundation

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}
