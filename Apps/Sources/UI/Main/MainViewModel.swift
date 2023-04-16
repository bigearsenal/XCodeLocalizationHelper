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
    var projectViewModel: ProjectViewModel!
    
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
    
    func closeProject() {
        guard let project = appState.project else {return}
        projectService.closeProject(project)
        var appState = appState
        appState.project = nil
        self.appState = appState
    }
    
    func refresh() {
        guard appState.project != nil else {
            return
        }
        projectViewModel?.refresh()
    }
}

extension MainViewModel: OpenProjectHandler {}
