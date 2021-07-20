//
//  ProjectRepository.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation

protocol ProjectRepositoryType {
    func getProjectPath() -> String?
    func saveProjectPath(_ projectPath: String?)
    func getTargetName() -> String?
    func saveTargetName(_ targetName: String?)
}

struct ProjectRepositoryUserDefaults: ProjectRepositoryType {
    // MARK: - Keys
    private let projectPathKey = "KEYS.PROJECT_PATH"
    private let targetKey = "KEYS.TARGET"
    
    // MARK: - Methods
    func saveProjectPath(_ projectPath: String?) {
        UserDefaults.standard.set(projectPath, forKey: projectPathKey)
    }
    
    func saveTargetName(_ targetName: String?) {
        UserDefaults.standard.set(targetName, forKey: targetKey)
    }
    
    func getProjectPath() -> String? {
        UserDefaults.standard.string(forKey: projectPathKey)
    }
    
    func getTargetName() -> String? {
        UserDefaults.standard.string(forKey: targetKey)
    }
}
