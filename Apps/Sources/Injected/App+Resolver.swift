//
//  Resolver.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 24/07/2021.
//

@_exported import Resolver

extension Resolver: ResolverRegistering {
    #if DEBUG
    static let mock = Resolver(parent: main)
    #endif
    
    public static func registerAllServices() {
        register {StringsFileGenerator() as FileGeneratorType}
        register {UserDefaultsProjectRepository() as ProjectRepositoryType}
        register {FilePickerService() as FilePickerServiceType}
        register {XCodeProjectService() as XCodeProjectServiceType}
        
        #if DEBUG
//        mock.register {FakeStringsFileGenerator() as FileGeneratorType}
//        mock.register {InMemoryProjectRepository.default as ProjectRepositoryType}
//        mock.register {MockFilePickerService() as FilePickerServiceType}
//        mock.register {OpenProjectHandler_Preview() as OpenProjectHandler}
        
        // register entire container as replacement for main
//        root = mock
        #endif
    }
}
