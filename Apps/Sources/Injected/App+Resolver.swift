//
//  Resolver.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 24/07/2021.
//

import Resolver

extension Resolver: ResolverRegistering {
    #if DEBUG
    static let mock = Resolver(parent: main)
    #endif
    
    public static func registerAllServices() {
        register {StringsFileGenerator() as FileGeneratorType}
        register {UserDefaultsProjectRepository() as ProjectRepositoryType}
        register {FilePickerService() as FilePickerServiceType}
        
        #if DEBUG
//        mock.register {FakeStringsFileGenerator() as FileGeneratorType}
//        mock.register {InMemoryProjectRepository(project: nil) as ProjectRepositoryType}
//        mock.register {MockFilePickerService() as FilePickerServiceType}
        
        // register entire container as replacement for main
        root = mock
        #endif
    }
}
