//
//  PBXGroupTests.swift
//  LocalizationHelperKitTests
//
//  Created by Chung Tran on 20/07/2021.
//

import XCTest
@testable import LocalizationHelper
import XcodeProj

class PBXGroupTests: XCTestCase {
    let homeUrl = "/Users/bigears/Documents/macos/XCodeLocalizationHelper/Apps/Tests/Extensions/PBXGroupTests/"
    let LOCALIZABLE_STRINGS = "Localizable.strings"
    
    func testGetGroupRecursively1() throws {
        let project = try getXcodeProj(fileName: "GetGroupRecursively1.xcodeproj")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNotEqual(group, nil)
    }
    
    func testGetGroupRecursively2() throws {
        let project = try getXcodeProj(fileName: "GetGroupRecursively2.xcodeproj")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNotEqual(group, nil)
    }
    
    // MARK: - Helper
    private func getXcodeProj(fileName: String) throws -> XcodeProj {
        try XcodeProj(pathString: homeUrl + "/" + fileName)
    }

}
