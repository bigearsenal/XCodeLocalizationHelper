//
//  AppStateServices.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 24/07/2021.
//

import Foundation

extension AppStateContainer {
    struct Services {
        let service: ProjectServiceType
        
        static var stub: Self {
            .init(service: StubProjectService())
        }
    }
}
