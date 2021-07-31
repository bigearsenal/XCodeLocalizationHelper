//
//  ProjectViewModel.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 25/07/2021.
//

import Foundation

class ProjectViewModel: ObservableObject {
    // MARK: - Dependencies
    @Injected var projectService: XCodeProjectServiceType
    
    // MARK: - Properties
    let project: Project
    
    @Published var localizableFiles = [LocalizableFile]()
    
    init(project: Project) {
        self.project = project
    }
    
    func refresh() {
        self.localizableFiles = (try? projectService.getLocalizableFiles(fromProject: project)) ?? []
    }
    
    func languagesDidSelect(_ languages: [ISOLanguageCode]) throws {
        for language in languages {
            try projectService.localizeProject(project, languageCode: language.code)
        }
        refresh()
    }
}
