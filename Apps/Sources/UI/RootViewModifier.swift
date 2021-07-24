//
//  RootViewModifier.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

import SwiftUI
import Combine

// MARK: - RootViewAppearance
struct RootViewAppearance: ViewModifier {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var isActive: Bool = false
    let inspection = PassthroughSubject<((AnyView) -> Void), Never>()
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? 0 : 10)
//            .onReceive(stateUpdate) { self.isActive = $0 }
            .onReceive(inspection) { callback in
                callback(AnyView(self.body(content: content)))
            }
    }
    
//    private var stateUpdate: AnyPublisher<Bool, Never> {
//        injected.appState.updates(for: \.system.isActive)
//    }
}
