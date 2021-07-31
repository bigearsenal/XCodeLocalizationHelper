//
//  Application.swift
//  LocalizationHelper_macos
//
//  Created by Chung Tran on 28/06/2021.
//

import Cocoa

class Application: NSApplication {

    let strongDelegate = AppDelegate()

    override init() {
        super.init()
        self.delegate = strongDelegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
