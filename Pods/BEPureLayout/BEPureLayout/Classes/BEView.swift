//
//  BEView.swift
//  BEPureLayout
//
//  Created by Chung Tran on 5/26/20.
//

import Foundation

open class BEView: UIView {
    // MARK: - Class Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - Custom Functions
    open func commonInit() {
        
    }
}
