//
//  ProjectInteractorTests.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 20/07/2021.
//

import XCTest
@testable import LocalizationHelper
import PathKit

class ProjectInteractorTests: XCTestCase {
    enum Error: Swift.Error {
        case languageCodeNotFoundInKnownRegions
        case fileNotFoundInLocalizableStringsGroup
        case fileNotFound
    }
    
    func testLocalizeFile1() throws {
        try testLocalizeProject(fileName: "Test1", languageCode: "zh")
    }
    
    func testLocalizeFile2() throws {
        try testLocalizeProject(fileName: "Test2", languageCode: "ru")
    }
    
    func testLocalizeFile3() throws {
        try testLocalizeProject(fileName: "Test3", languageCode: "ar")
    }
    
    func testLocalizeFile4() throws {
        try testLocalizeProject(fileName: "Test4", languageCode: "vi")
    }
    
    func testLocalizeTuistProject() throws {
        try testLocalizeProject(fileName: "TestWithTuist", languageCode: "vi")
    }
    
    // MARK: - DefaultProject
    private func testLocalizeProject(fileName: String, languageCode: String) throws {
        let interactor = try ProjectInteractor(
            projectRepository: FakeProjectRepository(testName: fileName),
            stringsFileGenerator: StringsFileGenerator()
        )
        
        try interactor.openCurrentProject()
        try interactor.localizeProject(languageCode: languageCode)
        
        switch interactor.appState.value.project! {
        case .default(let defaultProject):
            try checkIfFileWasLocalizedCorrectly(defaultProject: defaultProject, languageCode: languageCode)
        case .tuist(let tuistProject):
            try checkIfFileWasLocalizedCorrectly(tuistProject: tuistProject, languageCode: languageCode)
        }
    }
    
    private func checkIfFileWasLocalizedCorrectly(defaultProject project: DefaultProject, languageCode: String) throws {
        
        // checking if knownRegions contains "zh"
        if project.rootObject?.knownRegions.contains(languageCode) != true {
            throw Error.languageCodeNotFoundInKnownRegions
        }
        
        // check if localization group contains "zh.lproj/Localizable.strings"
        let localizationGroup = project.rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        
        if localizationGroup?.children.contains(where: {$0.path == "\(languageCode).lproj/Localizable.strings"}) != true
        {
            throw Error.fileNotFoundInLocalizableStringsGroup
        }
        
        // check if file exists
        let zhFile = localizationGroup?.children.first(where: {$0.path == "\(languageCode).lproj/Localizable.strings"})
        let fullPath = try zhFile?.fullPath(sourceRoot: project.projectFolderPath)
        if fullPath?.exists != true {
            throw Error.fileNotFound
        }
    }
    
    // MARK: - TuistProject
    private func checkIfFileWasLocalizedCorrectly(tuistProject project: TuistProject, languageCode: String) throws
    {
        let localizableFilePath = project.resourcePath + "\(languageCode).lproj" + LOCALIZABLE_STRINGS
        if !localizableFilePath.exists || !localizableFilePath.isFile {
            throw Error.fileNotFound
        }
    }
}
