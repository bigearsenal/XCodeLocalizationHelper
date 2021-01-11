import PureLayout

public extension UIView {
    convenience init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil
    ) {
        self.init(forAutoLayout: ())
        if let width = width {
            autoSetDimension(.width, toSize: width)
        }
        if let height = height {
            autoSetDimension(.height, toSize: height)
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    // MARK: - Helpers
    func autoPinToTopLeftCornerOfSuperview(
        xInset: CGFloat = 0,
        yInset: CGFloat? = nil
    ) {
        autoPinEdge(toSuperviewEdge: .top, withInset: yInset ?? xInset)
        autoPinEdge(toSuperviewEdge: .leading, withInset: xInset)
    }
    
    func autoPinToTopRightCornerOfSuperview(
        xInset: CGFloat = 0,
        yInset: CGFloat? = nil
    ) {
        autoPinEdge(toSuperviewEdge: .top, withInset: yInset ?? xInset)
        autoPinEdge(toSuperviewEdge: .trailing, withInset: xInset)
    }
    
    func autoPinToBottomLeftCornerOfSuperview(
        xInset: CGFloat = 0,
        yInset: CGFloat? = nil
    ) {
        autoPinEdge(toSuperviewEdge: .bottom, withInset: yInset ?? xInset)
        autoPinEdge(toSuperviewEdge: .leading, withInset: xInset)
    }
    
    func autoPinToBottomRightCornerOfSuperview(
        xInset: CGFloat = 0,
        yInset: CGFloat? = nil
    ) {
        autoPinEdge(toSuperviewEdge: .bottom, withInset: yInset ?? xInset)
        autoPinEdge(toSuperviewEdge: .trailing, withInset: xInset)
    }
    
    func autoPinToTopLeftCornerOfSuperviewSafeArea(
        xInset: CGFloat = 0,
        yInset: CGFloat? = nil
    ) {
        autoPinEdge(toSuperviewSafeArea: .top, withInset: yInset ?? xInset)
        autoPinEdge(toSuperviewSafeArea: .leading, withInset: xInset)
    }
    
    func autoPinToTopRightCornerOfSuperviewSafeArea(
        xInset: CGFloat = 0,
        yInset: CGFloat? = nil
    ) {
        autoPinEdge(toSuperviewSafeArea: .top, withInset: yInset ?? xInset)
        autoPinEdge(toSuperviewSafeArea: .trailing, withInset: xInset)
    }
    
    func autoPinToBottomLeftCornerOfSuperviewSafeArea(
        xInset: CGFloat = 0,
        yInset: CGFloat? = nil
    ) {
        autoPinEdge(toSuperviewSafeArea: .bottom, withInset: yInset ?? xInset)
        autoPinEdge(toSuperviewSafeArea: .leading, withInset: xInset)
    }
    
    func autoPinToBottomRightCornerOfSuperviewSafeArea(
        xInset: CGFloat = 0,
        yInset: CGFloat? = nil
    ) {
        autoPinEdge(toSuperviewSafeArea: .bottom, withInset: yInset ?? xInset)
        autoPinEdge(toSuperviewSafeArea: .trailing, withInset: xInset)
    }
    
    @available(iOS 11, *)
    func autoPinBottomToSuperViewSafeAreaAvoidKeyboard(inset: CGFloat = 0) {
        let keyboardViewV = AvoidingKeyboardLayoutConstraint(item: superview!.safeAreaLayoutGuide, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: inset)
        keyboardViewV.observeKeyboardHeight()
        superview?.addConstraint(keyboardViewV)
    }
}
