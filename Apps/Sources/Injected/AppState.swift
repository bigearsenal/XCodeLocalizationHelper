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
    let currentProject: Project?
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        AppState(currentProject: nil)
    }
}
#endif
