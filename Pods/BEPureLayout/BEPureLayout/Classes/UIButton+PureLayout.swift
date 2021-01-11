//
//  UIButton+PureLayout.swift
//  BEPureLayout
//
//  Created by Chung Tran on 5/25/20.
//

import Foundation

public extension UIButton {
    convenience init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        label: String? = nil,
        labelFont: UIFont? = nil,
        textColor: UIColor? = nil,
        contentInsets: UIEdgeInsets? = nil
    ) {
        self.init(width: width, height: height, backgroundColor: backgroundColor)
        
        setTitle(label, for: .normal)
        
        if let font = labelFont {
            titleLabel?.font = font
        }
        
        if let textColor = textColor {
            setTitleColor(textColor, for: .normal)
        }
        
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
        
        if let contentInsets = contentInsets {
            if contentInsets == .zero {
                // After some experimentation, it appears that if you try and set contentEdgeInsets to all zeros, the default insets are used. However, if you set them to nearly zero, it works:
                contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
            } else {
                contentEdgeInsets = contentInsets
            }
        }
    }
}
