//
//  PBXGroupTests.swift
//  LocalizationHelperKitTests
//
//  Created by Chung Tran on 20/07/2021.
//

import XCTest
@testable import LocalizationHelper

class _1PBXGroupTests: XCTestCase {
    
    func testGetGroupRecursively1() throws {
        let project = try getXcodeProj(fileName: "Test1")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNotNil(group)
    }
    
    func testGetGroupRecursively2() throws {
        let project = try getXcodeProj(fileName: "Test2")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNotNil(group)
    }
    
    func testGetGroupRecursively3() throws {
        let project = try getXcodeProj(fileName: "Test3")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNotNil(group)
    }
    
    func testGetGroupRecursively4() throws {
        let project = try getXcodeProj(fileName: "Test4")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNil(group)
    }

}
