//
//  OpenProjectHandler.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 25/07/2021.
//

import Foundation
import XcodeProj
import PathKit

protocol OpenProjectHandler {
    func openProject(_ project: Project) throws
}

extension OpenProjectHandler {
    func openDefaultProject(xcodeproj: XcodeProj, targetName: String, path: Path) throws {
        guard let target = xcodeproj.pbxproj.targets(named: targetName).first
        else {
            throw LocalizationHelperError.targetNotFound
        }
        try openProject(.default(.init(pxbproj: xcodeproj, target: target, path: path)))
    }
}

#if DEBUG
struct OpenProjectHandler_Preview: OpenProjectHandler {
    func openProject(_ project: Project) throws {
        // do nothing
    }
}
#endif
