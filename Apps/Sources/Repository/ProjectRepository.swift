//
//  ProjectRepository.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
import XcodeProj
import PathKit

protocol ProjectRepositoryType {
    func getCurrentProject() -> Project?
    func setCurrentProject(_ project: Project)
    func clearCurrentProject()
}

struct UserDefaultsProjectRepository: ProjectRepositoryType {
    // MARK: - Keys
    // Default project
    private let defaultProjectPathKey       = "KEYS.DEFAULT_PROJECT.PROJECT_PATH"
    private let defaultProjectTargetKey     = "KEYS.DEFAULT_PROJECT.TARGET"
    // Tuist project
    private let tuistProjectPathKey         = "KEYS.TUIST_PROJECT.PATH"
    private let tuistProjectResourcePathKey = "KEYS.TUIST_PROJECT.RESOURCE_PATH"
    private let tuistProjectNameKey         = "KEYS.TUIST_PROJECT.PROJECT_NAME"
    
    // MARK: - Methods
    func getCurrentProject() -> Project? {
        // default project
        if let projectPath = UserDefaults.standard.string(forKey: defaultProjectPathKey),
           let targetName = UserDefaults.standard.string(forKey: defaultProjectTargetKey),
           let project = try? XcodeProj(pathString: projectPath),
           let target = project.pbxproj.targets(named: targetName).first
        {
            return .default(
                .init(
                    pxbproj: project,
                    target: target,
                    path: Path(projectPath)
                )
            )
        }
        
        // tuist project
        if let path = UserDefaults.standard.string(forKey: tuistProjectPathKey),
           let resourcePath = UserDefaults.standard.string(forKey: tuistProjectResourcePathKey),
           let name = UserDefaults.standard.string(forKey: tuistProjectNameKey)
        {
            let path = Path(path)
            let resourcePath = Path(resourcePath)
            if path.isDirectory {
                return .tuist(
                    .init(path: path, resourcePath: resourcePath, projectName: name)
                )
            }
        }
        
        return nil
    }
    
    func setCurrentProject(_ project: Project) {
        switch project {
        case .default(let defaultProject):
            // set new value
            UserDefaults.standard.set(defaultProject.path.string, forKey: defaultProjectPathKey)
            UserDefaults.standard.set(defaultProject.target.name, forKey: defaultProjectTargetKey)
            // Remove tuist project if exists
            UserDefaults.standard.set(nil, forKey: tuistProjectPathKey)
            UserDefaults.standard.set(nil, forKey: tuistProjectResourcePathKey)
            UserDefaults.standard.set(nil, forKey: tuistProjectNameKey)
        case .tuist(let tuistProject):
            // set new value
            UserDefaults.standard.set(tuistProject.path.string, forKey: tuistProjectPathKey)
            UserDefaults.standard.set(tuistProject.resourcePath.string, forKey: tuistProjectResourcePathKey)
            UserDefaults.standard.set(tuistProject.projectName, forKey: tuistProjectNameKey)
            // Remove default project if exists
            UserDefaults.standard.set(nil, forKey: defaultProjectPathKey)
            UserDefaults.standard.set(nil, forKey: defaultProjectTargetKey)
        }
    }
    
    func clearCurrentProject() {
        // Remove tuist project if exists
        UserDefaults.standard.set(nil, forKey: tuistProjectPathKey)
        UserDefaults.standard.set(nil, forKey: tuistProjectResourcePathKey)
        UserDefaults.standard.set(nil, forKey: tuistProjectNameKey)
        
        // Remove default project if exists
        UserDefaults.standard.set(nil, forKey: defaultProjectPathKey)
        UserDefaults.standard.set(nil, forKey: defaultProjectTargetKey)
    }
}

#if DEBUG
class InMemoryProjectRepository: ProjectRepositoryType {
    private var currentProject: Project?
    
    init(project: Project?) {
        currentProject = project
    }
    
    func getCurrentProject() -> Project? {
        currentProject
    }
    
    func setCurrentProject(_ project: Project) {
        currentProject = project
    }
    
    func clearCurrentProject() {
        currentProject = nil
    }
    
    static var `default`: InMemoryProjectRepository {
        .init(project: .default(.demo))
    }
}
#endif
