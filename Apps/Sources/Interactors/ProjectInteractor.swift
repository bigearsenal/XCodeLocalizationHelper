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
    let appState: Store<AppState>
    
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
