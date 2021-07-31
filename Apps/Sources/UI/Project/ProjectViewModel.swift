//
//  ProjectViewModel.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 25/07/2021.
//

import Foundation
import LocalizationHelperKit

class ProjectViewModel: ObservableObject {
    // MARK: - Dependencies
    @Injected var projectService: XCodeProjectServiceType
    
    // MARK: - Properties
    let project: Project
    
    @Published var localizableFiles = [LocalizableFile]()
    @Published var error: String?
    
    init(project: Project) {
        self.project = project
    }
    
    func refresh() {
        error = nil
        
        self.localizableFiles = (try? projectService.getLocalizableFiles(fromProject: project)) ?? []
    }
    
    func languagesDidSelect(_ languages: [ISOLanguageCode]) {
        error = nil
        
        do {
            for language in languages {
                try projectService.localizeProject(project, languageCode: language.code)
            }
        } catch {
            self.error = error.localizedDescription
        }
        refresh()
    }
    
    func clearTextFields() {
        error = nil
        
        var newFiles = localizableFiles
        for i in 0..<newFiles.count {
            newFiles[i].newValue = ""
        }
        localizableFiles = newFiles
    }
    
    func translate(query: String) {
        error = nil
        
        // translate
        localizableFiles.forEach {file in
            guard !query.isEmpty else {return}
            let langCode = file.languageCode
            
            let completion: ((String) -> Void) = { text in
                var files = self.localizableFiles
                guard let index = files.firstIndex(where: {$0.languageCode == langCode}) else {return}
                var file = files[index]
                file.newValue = text
                files[index] = file
                self.localizableFiles = files
            }
            
            GoogleTranslate.translate(text: query, toLang: langCode) { (error, result) in
                DispatchQueue.main.async { [weak self] in
                    if let error = error {
                        self?.error = error.localizedDescription
                    }
                    if let result = result {
                        completion(result)
                    }
                }
            }
        }
    }
}
