//
//  UIImageView+PureLayout.swift
//  BEPureLayout
//
//  Created by Chung Tran on 5/25/20.
//

import Foundation

public extension UIImageView {
    convenience init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        imageNamed: String? = nil,
        contentMode: UIImageView.ContentMode? = nil
    ) {
        self.init(width: width, height: height, backgroundColor: backgroundColor, cornerRadius: cornerRadius)
        
        if let imageNamed = imageNamed {
            image = UIImage(named: imageNamed)
        }
        
        if let contentMode = contentMode {
            self.contentMode = contentMode
        }
    }
}
