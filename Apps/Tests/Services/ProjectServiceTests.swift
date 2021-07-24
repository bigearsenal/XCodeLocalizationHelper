//
//  ProjectServiceTests.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 20/07/2021.
//

import XCTest
@testable import LocalizationHelper
import PathKit
import Resolver

class ProjectServiceTests: XCTestCase {
    enum Error: Swift.Error {
        case languageCodeNotFoundInKnownRegions
        case fileNotFoundInLocalizableStringsGroup
        case fileNotFound
        case wrongNumberOfLocalizableFiles
    }
    
    func testLocalizeFile1() throws {
        try testLocalizeProject(fileName: "Test1", languageCode: "zh", expectedNumberOfLocalizableFile: 3)
    }
    
    func testLocalizeFile2() throws {
        try testLocalizeProject(fileName: "Test2", languageCode: "ru", expectedNumberOfLocalizableFile: 3)
    }
    
    func testLocalizeFile3() throws {
        try testLocalizeProject(fileName: "Test3", languageCode: "ar", expectedNumberOfLocalizableFile: 3)
    }
    
    func testLocalizeFile4() throws {
        try testLocalizeProject(fileName: "Test4", languageCode: "vi", expectedNumberOfLocalizableFile: 1)
    }
    
    func testLocalizeTuistProject() throws {
        try testLocalizeProject(fileName: "TestWithTuist", languageCode: "vi", expectedNumberOfLocalizableFile: 1)
    }
    
    // MARK: - DefaultProject
    private func testLocalizeProject(fileName: String, languageCode: String, expectedNumberOfLocalizableFile: Int) throws {
        // Test using TestProjectRepository
        let test = Resolver.mock
        test.register {TestProjectRepository(testName: fileName) as ProjectRepositoryType}
        test.register {StringsFileGenerator() as FileGeneratorType}
        
        let service = ProjectService(stringsFileGenerator: .init(container: test), projectRepository: .init(container: test))
        
        // test localize project
        try service.openCurrentProject()
        try service.localizeProject(languageCode: languageCode)
        
        // checkIfFileWasLocalizedCorrectly
        switch service.appState.value.project! {
        case .default(let defaultProject):
            try checkIfFileWasLocalizedCorrectly(defaultProject: defaultProject, languageCode: languageCode)
        case .tuist(let tuistProject):
            try checkIfFileWasLocalizedCorrectly(tuistProject: tuistProject, languageCode: languageCode)
        }
        
        // check number of localizableFile after all
        let localizableFiles = try service.getLocalizableFiles()
        if localizableFiles.count != expectedNumberOfLocalizableFile {
            throw Error.wrongNumberOfLocalizableFiles
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
