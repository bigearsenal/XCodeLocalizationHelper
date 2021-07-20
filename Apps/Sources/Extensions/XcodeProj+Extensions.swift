//
//  XcodeProj+Extensions.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
import XcodeProj

extension PBXGroup {
    func group(named name: String, recursively: Bool) -> PBXGroup? {
        // Non-recursively
        if !recursively {
            return group(named: name)
        }
        
        // If found
        if let group = group(named: name) {
            return group
        }
        
        // Recursively find
        if let children = children as? [PBXGroup] {
            for child in children {
                if let group = child.group(named: name, recursively: true) {
                    return group
                }
            }
        }
        
        return nil
    }
}
