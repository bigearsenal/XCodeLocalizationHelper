//
//  AppState.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

import Foundation
import Combine
import XcodeProj

/// The struct that contains all shared data inside application
struct AppState: Equatable {
    var project: ProjectData?
}

extension AppState {
    struct ProjectData: Equatable {
        var pxbproj: XcodeProj
        var target: PBXTarget
    }
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        AppState()
    }
}
#endif
