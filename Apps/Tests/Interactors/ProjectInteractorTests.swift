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
            stringsFileGenerator: StringsFileGenerator()
        )
        
        try interactor.openCurrentProject()
        try interactor.localizeProject(languageCode: "zh")
        
        // checking if knownRegions contains "zh"
        let project = interactor.appState.value.project
        XCTAssertEqual(project?.rootObject?.knownRegions.contains("zh"), true)
        
        // check if localization group contains "zh.lproj/Localizable.strings"
        let localizationGroup = project?.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        XCTAssertEqual(localizationGroup?.children.contains(where: {$0.path == "zh.lproj/Localizable.strings"}), true)
        
        // check if file exists
        let zhFile = localizationGroup?.children.first(where: {$0.path == "zh.lproj/Localizable.strings"})
        let fullPath = try zhFile?.fullPath(sourceRoot: interactor.appState.value.project!.projectFolderPath)
        XCTAssertEqual(fullPath?.exists, true)
    }
}
