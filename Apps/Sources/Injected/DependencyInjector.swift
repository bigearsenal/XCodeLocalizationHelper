//
//  DependencyInjector.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

import SwiftUI
import Combine

// MARK: - DIContainer
struct DIContainer: EnvironmentKey {
    
    let appState: Store<AppState>
    
    init(appState: Store<AppState>) {
        self.appState = appState
    }
    
    init(appState: AppState) {
        self.init(appState: Store<AppState>(appState))
    }
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = Self(appState: AppState())
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(appState: .init(AppState.preview))
    }
}
#endif

// MARK: - Injection in the view hierarchy
extension View {
    func inject(_ appState: AppState) -> some View {
        let container = DIContainer(appState: .init(appState))
        return inject(container)
    }
    
    func inject(_ container: DIContainer) -> some View {
        return self
            .modifier(RootViewAppearance())
            .environment(\.injected, container)
    }
}
