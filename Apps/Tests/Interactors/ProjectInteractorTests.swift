//
//  ProjectInteractorTests.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 20/07/2021.
//

import XCTest
@testable import LocalizationHelper

class ProjectInteractorTests: XCTestCase {
    var interactor: ProjectInteractor?
    
    func testLocalizeFile() throws {
        let project = try getXcodeProj(fileName: "Test1.xcodeproj")
        
        let group = project.pbxproj.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertNotNil(group)
    }
}
