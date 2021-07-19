//
//  InteractorContainer.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

extension DIContainer {
    struct Interactors {
        let projectInteractor: ProjectInteractorType
        
        static var stub: Self {
            .init(projectInteractor: StubProjectInteractor())
        }
    }
}
