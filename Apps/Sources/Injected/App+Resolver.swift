//
//  Resolver.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 24/07/2021.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        // String file generator
        register {StringsFileGenerator() as FileGeneratorType}
    }
}
