//
//  ProjectInteractor.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

import Foundation
import Combine
import XcodeProj
import PathKit

protocol ProjectInteractorType {
    func openCurrentProject() throws
    func openProject(_ project: Project) throws
    func localizeProject(languageCode: String) throws
    func getLocalizableFiles() throws -> [LocalizableFile]
    func closeProject()
}

struct ProjectInteractor: ProjectInteractorType {
    private let LOCALIZABLE_STRINGS = "Localizable.strings"
    // MARK: - Nested type
    enum Error: Swift.Error {
        case projectNotFound
        case targetNotFound
        case localizableStringsGroupNotFound
        case localizableStringsGroupFullPathNotFound
        case couldNotCreateLocalizableStringsGroup
        case resourcePathIsNotADirectory
    }
    
    // MARK: - Dependencies
    private let stringsFileGenerator: FileGeneratorType
    private let projectRepository: ProjectRepositoryType
    
    // MARK: - Properties
    let appState: Store<AppState>
    
    // MARK: - Initializers
    init(
        projectRepository: ProjectRepositoryType,
        stringsFileGenerator: FileGeneratorType
    ) throws {
        self.stringsFileGenerator = stringsFileGenerator
        self.projectRepository = projectRepository
        appState = .init(.init(project: nil))
    }
    
    // MARK: - Methods
    func openCurrentProject() throws {
        guard let project = projectRepository.getCurrentProject()
        else {throw Error.projectNotFound}
        try openProject(project)
    }
    
    func openProject(_ project: Project) throws {
        projectRepository.setCurrentProject(project)
        appState.send(.init(project: project))
    }
    
    func localizeProject(languageCode: String) throws {
        guard let project = appState.value.project
        else {
            throw Error.projectNotFound
        }
        
        switch project {
        case .default(let defaultProject):
            try localizeDefaultProject(defaultProject, languageCode: languageCode)
        case .tuist(let tuistProject):
            try localizeTuistProject(tuistProject, languageCode: languageCode)
        }
    }
    
    func getLocalizableFiles() throws -> [LocalizableFile] {
        guard let project = appState.value.project
        else {
            throw Error.projectNotFound
        }
        switch project {
        case .default(let defaultProject):
            break
        case .tuist(let tuistProject):
            break
        }
        
        return []
    }
    
    func closeProject() {
        projectRepository.clearCurrentProject()
        appState.send(.init(project: nil))
    }
    
    // MARK: - Helpers
    private func localizeTuistProject(_ project: TuistProject, languageCode: String) throws
    {
        let path = project.resourcePath
        guard path.isDirectory else {
            throw Error.resourcePathIsNotADirectory
        }
        
        try stringsFileGenerator.generateFile(at: path + "\(languageCode).lproj", fileName: LOCALIZABLE_STRINGS)
    }
    
    private func localizeDefaultProject(_ project: DefaultProject, languageCode: String) throws
    {
        guard let rootObject = project.rootObject
        else {
            throw Error.projectNotFound
        }
        
        // add knownRegions if not exists
        if !rootObject.knownRegions.contains(languageCode) {
            rootObject.knownRegions.append(languageCode)
        }
        
        // find Localizable.strings group
        var localizableStringsGroup = rootObject.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        
        // Localizable.strings group is not exists
        if localizableStringsGroup == nil
        {
            // create Localizable.strings group
            let group = rootObject.mainGroup.children.first(where: {$0.path == project.target.name}) as? PBXGroup
            
            localizableStringsGroup = try group?.addVariantGroup(named: LOCALIZABLE_STRINGS).first
            
            guard let localizableStringsGroup = localizableStringsGroup
            else {
                throw Error.couldNotCreateLocalizableStringsGroup
            }
            
            // add Localizable.strings group to target
            let fileBuildPhases = project.target.buildPhases.first(where: {$0 is PBXSourcesBuildPhase})
            _ = try fileBuildPhases?.add(file: localizableStringsGroup)
        }
        
        // get localizableStringsGroup's path
        guard let localizableStringsGroup = localizableStringsGroup
        else {
            throw Error.localizableStringsGroupNotFound
        }
        
        guard let localizableStringsGroupFullPath = try localizableStringsGroup.fullPath(sourceRoot: project.projectFolderPath)
        else {
            throw Error.localizableStringsGroupFullPathNotFound
        }
        
        // add <languageCode>.lproj/Localizable.strings to project at localizableStringsGroupPath
        try stringsFileGenerator.generateFile(at: localizableStringsGroupFullPath + "\(languageCode).lproj", fileName: LOCALIZABLE_STRINGS)
        
        let newFileFullPath = localizableStringsGroupFullPath + "\(languageCode).lproj" + LOCALIZABLE_STRINGS
        try localizableStringsGroup.addFile(at: newFileFullPath, sourceRoot: project.projectFolderPath)
        
        // set flag CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED = YES
        let key = "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED"
        project.target.buildConfigurationList?.buildConfigurations.forEach {
            $0.buildSettings[key] = "YES"
        }
        
        // save project
        try project.pxbproj.write(path: project.path)
    }
}

struct StubProjectInteractor: ProjectInteractorType {
    func openCurrentProject() throws {
        
    }
    
    func openProject(_ project: Project) throws {
        
    }
    
    func localizeProject(languageCode: String) throws {
        
    }
    
    func getLocalizableFiles() throws -> [LocalizableFile] {
        []
    }
    
    func closeProject() {
        
    }
}
