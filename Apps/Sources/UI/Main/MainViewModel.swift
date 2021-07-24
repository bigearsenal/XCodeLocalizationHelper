//
//  MainViewModel.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 24/07/2021.
//

import Foundation
import Resolver

class MainViewModel: ObservableObject {
    // MARK: - Dependencies
    @Injected var stringsFileGenerator: FileGeneratorType
    @Injected var projectRepository: ProjectRepositoryType
    
    // MARK: - Properties
    @Published var appState: AppState = .initial
    
    #if DEBUG
    init(resolver: Resolver) {
        self.stringsFileGenerator = resolver.resolve()
        self.projectRepository = resolver.resolve()
        try? openCurrentProject()
    }
    #endif
    
    init() {
        try? openCurrentProject()
    }
    
    // MARK: - Methods
    func openCurrentProject() throws {
        guard let project = projectRepository.getCurrentProject()
        else {throw LocalizationHelperError.projectNotFound}
        try openProject(project)
    }
    
    func openProject(_ project: Project) throws {
        projectRepository.setCurrentProject(project)
        appState = .init(project: project)
    }
    
    func localizeProject(languageCode: String) throws {
        guard let project = appState.project
        else {
            throw LocalizationHelperError.projectNotFound
        }
        
        try project.localize(fileGenerator: stringsFileGenerator, languageCode: languageCode)
    }
    
    func getLocalizableFiles() throws -> [LocalizableFile] {
        guard let project = appState.project
        else {
            throw LocalizationHelperError.projectNotFound
        }
        return try project.getLocalizableFiles()
    }
    
    func closeProject() {
        projectRepository.clearCurrentProject()
        appState = .init(project: nil)
    }
}
