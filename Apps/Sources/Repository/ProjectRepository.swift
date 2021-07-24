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
        if let resourcePath = UserDefaults.standard.string(forKey: resourcePathKey)
        {
            let path = Path(resourcePath)
            if path.isDirectory {
                return .tuist(
                    .init(resourcePath: path)
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
            // Remove default project if exists
            UserDefaults.standard.set(nil, forKey: projectPathKey)
            UserDefaults.standard.set(nil, forKey: targetKey)
        }
    }
    
    func clearCurrentProject() {
        // Remove tuist project if exists
        UserDefaults.standard.set(nil, forKey: resourcePathKey)
        
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
        let repositoryLocalURL = "/Users/bigears/Documents/macos/XCodeLocalizationHelper"
        let homeUrl = Path(repositoryLocalURL + "/Apps/TestsProjects/")
        let test1 = homeUrl + "Test1" + "Test1.xcodeproj"
        
        guard let pbxproj = try? XcodeProj(path: test1),
              let target = pbxproj.pbxproj.targets(named: "Test1").first
        else {
            return .init(project: nil)
        }
        
        return .init(project: .default(
            .init(
                pxbproj: pbxproj,
                target: target,
                path: test1
            )
        ))
    }
}
#endif
