//
//  PBXGroupTests.swift
//  LocalizationHelperKitTests
//
//  Created by Chung Tran on 20/07/2021.
//

import XCTest
@testable import LocalizationHelper
import XcodeProj

// FIXME: - REPLACE THIS URL BEFORE TESTING
let repositoryLocalURL = "/Users/bigears/Documents/macos/XCodeLocalizationHelper"

let homeUrl = repositoryLocalURL + "/Apps/Tests/"

class PBXGroupTests: XCTestCase {
    
    let LOCALIZABLE_STRINGS = "Localizable.strings"
    
    func testGetGroupRecursively1() throws {
        let project = try getXcodeProj(fileName: "Test1.xcodeproj")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNotNil(group)
    }
    
    func testGetGroupRecursively2() throws {
        let project = try getXcodeProj(fileName: "Test2.xcodeproj")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNotNil(group)
    }
    
    func testGetGroupRecursively3() throws {
        let project = try getXcodeProj(fileName: "Test3.xcodeproj")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNotNil(group)
    }
    
    func testGetGroupRecursively4() throws {
        let project = try getXcodeProj(fileName: "Test4.xcodeproj")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNil(group)
    }
    
    // MARK: - Helper
    private func getXcodeProj(fileName: String) throws -> XcodeProj {
        try XcodeProj(pathString: homeUrl + "/" + fileName)
    }

}
