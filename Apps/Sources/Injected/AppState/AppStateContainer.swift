//
//  AppStateContainer.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

import SwiftUI
import Combine

// MARK: - AppStateContainer
struct AppStateContainer: EnvironmentKey {
    
    let appState: Store<AppState>
    let services: Services
    
    init(appState: Store<AppState>, services: Services) {
        self.appState = appState
        self.services = services
    }
    
    init(appState: AppState, services: Services) {
        self.init(appState: Store<AppState>(appState), services: services)
    }
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = Self(appState: AppState(), services: .stub)
}

extension EnvironmentValues {
    var appStateContainer: AppStateContainer {
        get { self[AppStateContainer.self] }
        set { self[AppStateContainer.self] = newValue }
    }
}

#if DEBUG
extension AppStateContainer {
    static var preview: Self {
        .init(appState: .init(AppState.preview), services: .stub)
    }
}
#endif

// MARK: - Injection in the view hierarchy
extension View {
    
    func inject(_ appState: AppState,
                _ services: AppStateContainer.Services) -> some View {
        let container = AppStateContainer(appState: .init(appState),
                                    services: services)
        return inject(container)
    }
    
    func inject(_ container: AppStateContainer) -> some View {
        return self
            .modifier(RootViewAppearance())
            .environment(\.appStateContainer, container)
    }
}
