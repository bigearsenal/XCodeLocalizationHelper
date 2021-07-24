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
        // String file generator
        register {StringsFileGenerator() as FileGeneratorType}
        
        #if DEBUG
        
        #endif
    }
}
