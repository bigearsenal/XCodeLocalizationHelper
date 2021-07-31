//
//  XcodeProj+Extensions.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
import XcodeProj
import PathKit

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

#if DEBUG
extension XcodeProj {
    static var demoProject: (XcodeProj?, Path) {
        let repositoryLocalURL = "/Users/bigears/Documents/macos/XCodeLocalizationHelper"
        let homeUrl = Path(repositoryLocalURL + "/Apps/TestsProjects/")
        let test1 = homeUrl + "Test1" + "Test1.xcodeproj"
        
        return (try? XcodeProj(path: test1), test1)
    }
}
#endif
