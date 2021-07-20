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
    private let projectRepository: ProjectRepositoryType
    
    // MARK: - Properties
    let appState: Store<AppState>
    
    // MARK: - Initializers
    init(
        projectRepository: ProjectRepositoryType,
        stringsFileGenerator: StringsFileGeneratorType
    ) {
        self.stringsFileGenerator = stringsFileGenerator
        self.projectRepository = projectRepository
        appState = .init(.init(project: nil))
        
        // open current saved project
        if let path = projectRepository.getProjectPath(), let targetName = projectRepository.getTargetName() {
            try? openProject(path: path, targetName: targetName)
        }
    }
    
    // MARK: - Methods
    func openProject(path: String, targetName: String) throws {
        let project = try XcodeProj(pathString: path)
        guard let target = project.pbxproj.targets(named: targetName).first else {
            return
        }
        projectRepository.saveProjectPath(path)
        projectRepository.saveTargetName(targetName)
        appState.send(
            .init(
                project: .init(
                    pxbproj: project,
                    target: target,
                    path: Path(path)
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
        let localizableStringsGroupPath: Path
        if let string = localizableStringsGroup.children.first?.path {
            localizableStringsGroupPath = .init(string).parent().parent()
        } else {
            localizableStringsGroupPath = Path()
        }
        
//        po group?.fullPath(sourceRoot: .init("/Users/bigears/Documents/macos/XCodeLocalizationHelper/Apps/Tests/Extensions/PBXGroupTests"))
        
        // add <languageCode>.lproj/Localizable.strings to project at localizableStringsGroupPath
        try stringsFileGenerator.generateStringsFile(at: localizableStringsGroupPath, languageCode: languageCode)
        
        try localizableStringsGroup.addFile(at: localizableStringsGroupPath + "\(languageCode).lproj" + LOCALIZABLE_STRINGS, sourceRoot: project.projectFolderPath)
        
        // set flag CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED = YES
        let key = "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED"
        project.target.buildConfigurationList?.buildConfigurations.forEach {
            $0.buildSettings[key] = "YES"
        }
        
        // save project
        try saveProject()
    }
    
    func closeProject() {
        projectRepository.saveProjectPath(nil)
        projectRepository.saveTargetName(nil)
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
