//
//  XCodeProjectService.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 25/07/2021.
//

import Foundation

protocol XCodeProjectServiceType {
    func openCurrentProject() throws -> Project
    func openProject(_ project: Project) throws -> Project
    func localizeProject(_ project: Project, languageCode: String) throws
    func getLocalizableFiles(fromProject project: Project) throws -> [LocalizableFile]
    func closeProject(_ project: Project)
}

struct XCodeProjectService: XCodeProjectServiceType {
    // MARK: - Dependencies
    @Injected var stringsFileGenerator: FileGeneratorType
    @Injected var projectRepository: ProjectRepositoryType
    
    // MARK: - Methods
    func openCurrentProject() throws -> Project {
        guard let project = projectRepository.getCurrentProject()
        else {throw LocalizationHelperError.projectNotFound}
        return try openProject(project)
    }
    
    func openProject(_ project: Project) throws -> Project {
        projectRepository.setCurrentProject(project)
        return project
    }
    
    func localizeProject(_ project: Project, languageCode: String) throws {
        try project.localize(fileGenerator: stringsFileGenerator, languageCode: languageCode)
    }
    
    func getLocalizableFiles(fromProject project: Project) throws -> [LocalizableFile] {
        try project.getLocalizableFiles()
    }
    
    func closeProject(_ project: Project) {
        projectRepository.clearCurrentProject()
    }
}
