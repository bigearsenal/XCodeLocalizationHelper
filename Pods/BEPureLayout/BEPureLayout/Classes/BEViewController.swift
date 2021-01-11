//
//  BEViewController.swift
//  BEPureLayout
//
//  Created by Chung Tran on 5/31/20.
//

import Foundation

open class BEViewController: UIViewController {
    // MARK: - NestedType
    public enum NavigationBarStyle {
        case normal(translucent: Bool = false, backgroundColor: UIColor = .white, font: UIFont = .boldSystemFont(ofSize: 15), textColor: UIColor = .black, prefersLargeTitle: Bool = false)
        case hidden
        case embeded
    }
    
    // MARK: - Properties
    open var preferredBackgroundColor: UIColor {.white}
    open var preferredNavigationBarStype: NavigationBarStyle {.normal()}
    
    // MARK: - Lifecycle methods
    open override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        changeStatusBarStyle(preferredStatusBarStyle)
    }
    
    // MARK: - Custom methods
    open func setUp() {
        view.backgroundColor = preferredBackgroundColor
    }
    open func bind() {}
    
    // MARK: - StatusBar's configurations
    public func changeStatusBarStyle(_ style: UIStatusBarStyle) {
        (navigationController as? BENavigationController)?.changeStatusBarStyle(style)
    }
    
    // MARK: - NavigationBar's configurations
    public func configureNavigationBar() {
        switch preferredNavigationBarStype {
        case .normal(let translucent, let backgroundColor, let font, let textColor, let prefersLargeTitle):
            navigationController?.navigationBar.isTranslucent = translucent
            
            setNavigationBarBackgroundColor(backgroundColor)
            
            // set title style
            setNavigationBarTitleStyle(textColor: textColor, font: font)
            
            // bar buttons
            navigationItem.leftBarButtonItem?.tintColor = textColor
            navigationItem.rightBarButtonItem?.tintColor = textColor
            
            if #available(iOS 11.0, *) {
                navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitle
            }
            
            navigationController?.setNavigationBarHidden(false, animated: false)
        case .hidden:
            navigationController?.setNavigationBarHidden(true, animated: false)
        case .embeded:
            break
        }
        
        view.superview?.layoutIfNeeded()
    }
    
    public func setNavigationBarBackgroundColor(_ backgroundColor: UIColor) {
        let img = UIImage()
        navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.subviews.first?.backgroundColor = backgroundColor
        
        let img2 = UIImage()
        navigationController?.navigationBar.shadowImage = img2
    }
    
    public func setNavigationBarTitleStyle(textColor: UIColor, font: UIFont) {
        navigationController?.navigationBar.tintColor = textColor
        var attrs = [NSAttributedString.Key: Any]()
        attrs[.font] = font
        attrs[.foregroundColor] = textColor
        navigationController?.navigationBar.titleTextAttributes = attrs
    }
}
