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
    
    init() {
        try? openCurrentProject()
    }
    
    // MARK: - Methods
    func openCurrentProject() throws {
        let project = try projectService.openCurrentProject()
        var appState = appState
        appState.project = project
        self.appState = appState
    }
    
    func openProject(_ project: Project) throws {
        let project = try projectService.openProject(project)
        var appState = appState
        appState.project = project
        self.appState = appState
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
        var appState = appState
        appState.project = nil
        self.appState = appState
    }
}

extension MainViewModel: OpenProjectHandler {}
