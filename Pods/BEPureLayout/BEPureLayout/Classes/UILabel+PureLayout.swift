//
//  UILabel+PureLayout.swift
//  BEPureLayout
//
//  Created by Chung Tran on 5/25/20.
//

import Foundation

public extension UILabel {
    convenience init(
        text: String? = nil,
        textSize: CGFloat = UIFont.systemFontSize,
        weight: UIFont.Weight = .regular,
        textColor: UIColor? = nil,
        numberOfLines: Int? = nil,
        textAlignment: NSTextAlignment? = nil
    ) {
        self.init(forAutoLayout: ())
        self.text = text
        self.font = .systemFont(ofSize: textSize, weight: weight)
        
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
        if let textAlignment = textAlignment {
            self.textAlignment = textAlignment
        }
    }
}
