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
    let interactors: Services
    
    init(appState: Store<AppState>, interactors: Services) {
        self.appState = appState
        self.interactors = interactors
    }
    
    init(appState: AppState, interactors: Services) {
        self.init(appState: Store<AppState>(appState), interactors: interactors)
    }
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = Self(appState: AppState(), interactors: .stub)
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
        .init(appState: .init(AppState.preview), interactors: .stub)
    }
}
#endif

// MARK: - Injection in the view hierarchy
extension View {
    
    func inject(_ appState: AppState,
                _ interactors: DIContainer.Services) -> some View {
        let container = DIContainer(appState: .init(appState),
                                    interactors: interactors)
        return inject(container)
    }
    
    func inject(_ container: DIContainer) -> some View {
        return self
            .modifier(RootViewAppearance())
            .environment(\.injected, container)
    }
}
