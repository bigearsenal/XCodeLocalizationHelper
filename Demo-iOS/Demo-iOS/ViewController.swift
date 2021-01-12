//
//  ViewController.swift
//  LocalizationHelperDemo
//
//  Created by Chung Tran on 11/01/2021.
//

import UIKit

class ViewController: BEViewController {
    override func setUp() {
        super.setUp()
        view.backgroundColor = .red
        let label = UILabel(text: NSLocalizedString("test", comment: ""), textSize: 17, weight: .bold, textColor: .white, textAlignment: .center)
        view.addSubview(label)
        label.autoCenterInSuperview()
    }
}

