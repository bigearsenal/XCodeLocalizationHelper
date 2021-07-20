//
//  ProjectInteractorTests.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 20/07/2021.
//

import XCTest
@testable import LocalizationHelper

class ProjectInteractorTests: XCTestCase {
    func testLocalizeFile() throws {
        let interactor = try ProjectInteractor(
            projectRepository: FakeProjectRepository(fileName: "Test1", targetName: "Test1"),
            stringsFileGenerator: FakeFileGenerator()
        )
        
        try interactor.openCurrentProject()
        try interactor.localizeProject(languageCode: "zh")
    }
}
