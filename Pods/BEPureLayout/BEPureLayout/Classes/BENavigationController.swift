//
//  BENavigationController.swift
//  BEPureLayout
//
//  Created by Chung Tran on 5/31/20.
//

import Foundation

open class BENavigationController: UINavigationController {
    // MARK: - Properties
    private var statusBarStyle: UIStatusBarStyle = .default
    open override var preferredStatusBarStyle: UIStatusBarStyle {self.statusBarStyle}
    
    public var previousController: UIViewController? {
        if viewControllers.count > 1 {
            return viewControllers[viewControllers.count-2]
        }
        return nil
    }
    
    // MARK: - Custom methods
    open func changeStatusBarStyle(_ style: UIStatusBarStyle) {
        self.statusBarStyle = style
        setNeedsStatusBarAppearanceUpdate()
    }
    
    open override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        if let vc = previousController as? BEViewController {
//            vc.configureNavigationBar()
            vc.changeStatusBarStyle(vc.preferredStatusBarStyle)
        }
        return vc
    }
}
