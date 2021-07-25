//
//  OpenProjectHandler.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 25/07/2021.
//

import Foundation

protocol OpenProjectHandler {
    func openProject(_ project: Project)
}

#if DEBUG
struct OpenProjectHandler_Preview: OpenProjectHandler {
    func openProject(_ project: Project) {
        // do nothing
    }
}
#endif
