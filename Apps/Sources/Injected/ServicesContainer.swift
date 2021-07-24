//
//  ServicesContainer.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

extension DIContainer {
    struct Services {
        let projectInteractor: ProjectServiceType
        
        static var stub: Self {
            .init(projectInteractor: StubProjectInteractor())
        }
    }
}
