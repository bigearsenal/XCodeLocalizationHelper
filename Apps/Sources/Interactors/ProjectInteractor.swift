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
    func openProject(path: String) throws
    func closeProject()
}

struct ProjectInteractor: ProjectInteractorType {
    let appState: Store<AppState>
    
    func openProject(path: String) throws {
        let path = Path(path)
        let project = try XcodeProj(path: path)
        appState.send(.init(currentProject: .init(xcodeproj: project)))
    }
    
    func closeProject() {
        appState.send(.init(currentProject: nil))
    }
}

struct StubProjectInteractor: ProjectInteractorType {
    func openProject(path: String) throws {
        
    }
    
    func closeProject() {
        
    }
}
