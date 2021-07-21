//
//  AppState.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

import Foundation
import Combine

/// The struct that contains all shared data inside application
struct AppState: Equatable {
    var project: Project?
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        AppState()
    }
}
#endif
