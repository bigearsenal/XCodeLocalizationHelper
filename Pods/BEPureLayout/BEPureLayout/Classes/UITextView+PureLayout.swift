//
//  UITextView+PureLayout.swift
//  BEPureLayout
//
//  Created by Chung Tran on 5/25/20.
//

import Foundation

public extension UITextView {
    convenience init(forExpandable: ()) {
        self.init(forAutoLayout: ())
        isScrollEnabled = false
    }
}
