//
//  ProjectInteractorTests.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 20/07/2021.
//

import XCTest
@testable import LocalizationHelper

class ProjectInteractorTests: XCTestCase {
    enum Error: Swift.Error {
        case languageCodeNotFoundInKnownRegions
        case fileNotFoundInLocalizableStringsGroup
        case fileNotFound
    }
    
    func testLocalizeFile1() throws {
        try testLocalizeFile(fileName: "Test1", languageCode: "zh")
    }
    
    func testLocalizeFile2() throws {
        try testLocalizeFile(fileName: "Test2", languageCode: "ru")
    }
    
    // MARK: - Helpers
    private func testLocalizeFile(fileName: String, languageCode: String) throws {
        let interactor = try ProjectInteractor(
            projectRepository: FakeProjectRepository(fileName: fileName, targetName: fileName),
            stringsFileGenerator: StringsFileGenerator()
        )
        
        try interactor.openCurrentProject()
        try interactor.localizeProject(languageCode: languageCode)
        
        try checkIfFileWasLocalizedCorrectly(interactor: interactor, languageCode: languageCode)
    }
    
    private func checkIfFileWasLocalizedCorrectly(interactor: ProjectInteractor, languageCode: String) throws {
        // checking if knownRegions contains "zh"
        let project = interactor.appState.value.project
        if project?.rootObject?.knownRegions.contains(languageCode) != true {
            throw Error.languageCodeNotFoundInKnownRegions
        }
        
        // check if localization group contains "zh.lproj/Localizable.strings"
        let localizationGroup = project?.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        
        if localizationGroup?.children.contains(where: {$0.path == "\(languageCode).lproj/Localizable.strings"}) != true
        {
            throw Error.fileNotFoundInLocalizableStringsGroup
        }
        
        // check if file exists
        let zhFile = localizationGroup?.children.first(where: {$0.path == "\(languageCode).lproj/Localizable.strings"})
        let fullPath = try zhFile?.fullPath(sourceRoot: interactor.appState.value.project!.projectFolderPath)
        if fullPath?.exists != true {
            throw Error.fileNotFound
        }
    }
}
