//
//  Project.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

import Foundation
import XcodeProj

struct Project: Equatable {
    let xcodeproj: XcodeProj
    var localizationFiles: [LocalizationFile]? {
        fatalError("Find localization files in project")
    }
}
