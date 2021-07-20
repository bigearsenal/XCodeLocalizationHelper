//
//  XcodeProj+Extensions.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
import XcodeProj

extension PBXGroup {
    /// Returns group with the given name contained in the project.
    /// - Parameters:
    ///   - name: group's name
    ///   - recursively: should find recursively or not
    /// - Returns: group with the given name in the project
    func group(named name: String, recursively: Bool) -> PBXGroup? {
        // Non-recursively
        if !recursively {
            return group(named: name)
        }
        
        // If found
        if let group = group(named: name) {
            return group
        }
        
        // recursively find group
        for child in children where child is PBXGroup {
            if let group = (child as? PBXGroup)?.group(named: name, recursively: true) {
                return group
            }
        }
        
        return nil
    }
}
