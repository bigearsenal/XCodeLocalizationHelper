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
    func localizeProject(languageCode: String) throws
    func closeProject()
}

struct ProjectInteractor: ProjectInteractorType {
    private let LOCALIZABLE_STRINGS = "Localizable.strings"
    // MARK: - Dependencies
    private let stringsFileGenerator: StringsFileGeneratorType
    
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
    init(stringsFileGenerator: StringsFileGeneratorType) {
        self.stringsFileGenerator = stringsFileGenerator
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
        appState.send(
            .init(
                project: .init(
                    pxbproj: project,
                    target: target,
                    path: path
                )
            )
        )
    }
    
    func localizeProject(languageCode: String) throws {
        guard let project = appState.value.project,
              let rootObject = project.rootObject,
              !rootObject.knownRegions.contains(languageCode)
        else {return}
        
        // add knownRegions
        rootObject.knownRegions.append(languageCode)
        
        // find Localizable.strings group
        var localizableStringsGroup = rootObject.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        
        // Localizable.strings group is not exists
        if localizableStringsGroup == nil
        {
            // create Localizable.strings group
            localizableStringsGroup = try rootObject.mainGroup.addVariantGroup(named: LOCALIZABLE_STRINGS).first
            
            // add Localizable.strings group to target
            let fileBuildPhases = project.target.buildPhases.first(where: {$0 is PBXSourcesBuildPhase})
            _ = try fileBuildPhases?.add(file: localizableStringsGroup!)
        }
        
        // get localizableStringsGroup's path
        guard let localizableStringsGroup = localizableStringsGroup
        else {return}
        
        // add <languageCode>.lproj/Localizable.strings to project at localizableStringsGroupPath
//        let newStringsFilePath = try stringsFileGenerator.generateStringsFile(at: Path(localizableStringsGroupPath), languageCode: languageCode)
//        
//        try localizableStringsGroup.addFile(at: newStringsFilePath, sourceRoot: mainGroupPath.parent())
        
        
        // set flag CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED = YES
        let key = "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED"
        project.target.buildConfigurationList?.buildConfigurations.forEach {
            $0.buildSettings[key] = "YES"
        }
        
        // save project
        try saveProject()
    }
    
    func closeProject() {
        appState.send(.init(project: nil))
    }
    
    // MARK: - Helpers
    private func saveProject() throws {
        guard let project = appState.value.project?.pxbproj,
            let path = appState.value.project?.path else {return}
        try project.write(path: path)
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
