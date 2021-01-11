//
//  ContentHuggingScrollView.swift
//  Commun
//
//  Created by Chung Tran on 11/1/19.
//  Copyright © 2019 Commun Limited. All rights reserved.
//

import Foundation

public class ContentHuggingScrollView: UIScrollView {
    // MARK: - Subviews
    public lazy var contentView = UIView(forAutoLayout: ())
    var scrollableAxis: NSLayoutConstraint.Axis
    
    // MARK: - Methods
    public init(scrollableAxis: NSLayoutConstraint.Axis, contentInset: UIEdgeInsets = .zero) {
        self.scrollableAxis = scrollableAxis
        super.init(frame: .zero)
        self.contentInset = contentInset
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        configureForAutoLayout()
        addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges()
        if scrollableAxis == .vertical {
            NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0
            ).isActive = true
        } else {
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0
            ).isActive = true
        }
    }
}
