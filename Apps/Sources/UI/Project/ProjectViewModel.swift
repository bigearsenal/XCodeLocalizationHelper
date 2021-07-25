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
        if let localizableFiles = try? projectService.getLocalizableFiles(fromProject: project) {
            self.localizableFiles = localizableFiles
        }
    }
    
    func localizeProject(languageCode: String) throws {
        try projectService.localizeProject(project, languageCode: languageCode)
    }

    func getLocalizableFiles() throws -> [LocalizableFile] {
        return try projectService.getLocalizableFiles(fromProject: project)
    }
}
