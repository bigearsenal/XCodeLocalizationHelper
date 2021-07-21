//
//  Project.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 21/07/2021.
//

import Foundation
import XcodeProj
import PathKit

enum Project: Equatable {
    case `default`(DefaultProject)
    case tuist(TuistProject)
}

struct DefaultProject: Equatable {
    var pxbproj: XcodeProj
    var target: PBXTarget
    var path: Path
    
    var rootObject: PBXProject? {
        pxbproj.pbxproj.rootObject
    }
    
    var projectFolderPath: Path {
        path.parent()
    }
}

struct TuistProject: Equatable {
    var resourcePath: Path
}
