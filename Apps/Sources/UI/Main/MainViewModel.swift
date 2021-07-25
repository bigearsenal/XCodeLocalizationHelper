//
//  MainViewModel.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 24/07/2021.
//

import Foundation

class MainViewModel: ObservableObject {
    // MARK: - Dependencies
    @Injected var projectService: XCodeProjectServiceType
    
    // MARK: - Properties
    @Published var appState: AppState = .initial
    
    #if DEBUG
    init(resolver: Resolver) {
        self.projectService = resolver.resolve()
        try? openCurrentProject()
    }
    #endif
    
    init() {
        try? openCurrentProject()
    }
    
    // MARK: - Methods
    func openCurrentProject() throws {
        let project = try projectService.openCurrentProject()
        appState.project = project
    }
    
    func openProject(_ project: Project) throws {
        let project = try projectService.openProject(project)
        appState.project = project
    }
    
    func localizeProject(languageCode: String) throws {
        guard let project = appState.project else {throw LocalizationHelperError.projectNotFound}
        try projectService.localizeProject(project, languageCode: languageCode)
    }
    
    func getLocalizableFiles() throws -> [LocalizableFile] {
        guard let project = appState.project
        else {
            throw LocalizationHelperError.projectNotFound
        }
        return try projectService.getLocalizableFiles(fromProject: project)
    }
    
    func closeProject() {
        guard let project = appState.project else {return}
        projectService.closeProject(project)
        appState.project = nil
    }
}
