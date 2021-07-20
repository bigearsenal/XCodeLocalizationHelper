//
//  ProjectInteractor.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 19/07/2021.
//

import Foundation
import Combine
import XcodeProj
import PathKit

protocol ProjectInteractorType {
    func openProject(path: String, targetName: String) throws
    func localizeProject(languageCode: String)
    func closeProject()
}

struct ProjectInteractor: ProjectInteractorType {
    // MARK: - UserDefaults
    private let projectPathKey = "KEYS.PROJECT_PATH"
    private let targetKey = "KEYS.TARGET"
    
    private var projectPath: String? {
        get {
            UserDefaults.standard.string(forKey: projectPathKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: projectPathKey)
        }
    }
    private var targetName: String? {
        get {
            UserDefaults.standard.string(forKey: targetKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: targetKey)
        }
    }
    
    
    // MARK: - Properties
    let appState: Store<AppState>
    
    // MARK: - Initializers
    init() {
        appState = .init(.init(project: nil))
        
        // open current saved project
        if let path = projectPath, let targetName = targetName {
            try? openProject(path: path, targetName: targetName)
        }
    }
    
    // MARK: - Methods
    func openProject(path: String, targetName: String) throws {
        let path = Path(path)
        let project = try XcodeProj(path: path)
        guard let target = project.pbxproj.targets(named: targetName).first else {
            return
        }
        appState.send(.init(project: .init(pxbproj: project, target: target)))
    }
    
    func localizeProject(languageCode: String) {
        guard let project = appState.value.project?.pxbproj,
              let rootObject = project.pbxproj.rootObject,
              !rootObject.knownRegions.contains(languageCode)
        else {return}
        
    }
    
    func closeProject() {
        appState.send(.init(project: nil))
    }
}

struct StubProjectInteractor: ProjectInteractorType {
    func openProject(path: String, targetName: String) throws {
        
    }
    
    func localizeProject(languageCode: String) {
        
    }
    
    func closeProject() {
        
    }
}
