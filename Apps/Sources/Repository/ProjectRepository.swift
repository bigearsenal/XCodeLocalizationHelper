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
    private let projectPathKey = "KEYS.PROJECT_PATH"
    private let targetKey = "KEYS.TARGET"
    // Tuist project
    private let resourcePathKey = "KEYS.RESOURCE_PATH"
    private let projectNameKey = "KEYS.PROJECT_NAME"
    
    // MARK: - Methods
    func getCurrentProject() -> Project? {
        // default project
        if let projectPath = UserDefaults.standard.string(forKey: projectPathKey),
           let targetName = UserDefaults.standard.string(forKey: targetKey),
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
        if let resourcePath = UserDefaults.standard.string(forKey: resourcePathKey),
           let name = UserDefaults.standard.string(forKey: projectNameKey)
        {
            let path = Path(resourcePath)
            if path.isDirectory {
                return .tuist(
                    .init(resourcePath: path, projectName: name)
                )
            }
        }
        
        return nil
    }
    
    func setCurrentProject(_ project: Project) {
        switch project {
        case .default(let defaultProject):
            // set new value
            UserDefaults.standard.set(defaultProject.path.string, forKey: projectPathKey)
            UserDefaults.standard.set(defaultProject.target.name, forKey: targetKey)
            // Remove tuist project if exists
            UserDefaults.standard.set(nil, forKey: resourcePathKey)
        case .tuist(let tuistProject):
            // set new value
            UserDefaults.standard.set(tuistProject.resourcePath.string, forKey: resourcePathKey)
            UserDefaults.standard.set(tuistProject.projectName, forKey: projectNameKey)
            // Remove default project if exists
            UserDefaults.standard.set(nil, forKey: projectPathKey)
            UserDefaults.standard.set(nil, forKey: targetKey)
        }
    }
    
    func clearCurrentProject() {
        // Remove tuist project if exists
        UserDefaults.standard.set(nil, forKey: resourcePathKey)
        UserDefaults.standard.set(nil, forKey: projectNameKey)
        
        // Remove default project if exists
        UserDefaults.standard.set(nil, forKey: projectPathKey)
        UserDefaults.standard.set(nil, forKey: targetKey)
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
        guard let xcodeProj = XcodeProj.demoProject.0,
              let target = xcodeProj.pbxproj.targets(named: "Test1").first
        else {
            return .init(project: nil)
        }
        
        let path = XcodeProj.demoProject.1
        
        return .init(project: .default(
            .init(
                pxbproj: xcodeProj,
                target: target,
                path: path
            )
        ))
    }
}
#endif
