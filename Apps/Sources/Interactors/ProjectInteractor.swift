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
        
        try project.localize(fileGenerator: stringsFileGenerator, languageCode: languageCode)
    }
    
    func getLocalizableFiles() throws -> [LocalizableFile] {
        guard let project = appState.value.project
        else {
            throw Error.projectNotFound
        }
        return project.getLocalizableFiles()
    }
    
    func closeProject() {
        projectRepository.clearCurrentProject()
        appState.send(.init(project: nil))
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
