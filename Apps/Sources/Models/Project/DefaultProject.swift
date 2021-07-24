//
//  DefaultProject.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 21/07/2021.
//

import Foundation
import XcodeProj
import PathKit

struct DefaultProject: Equatable {
    var pxbproj: XcodeProj
    var target: PBXTarget
    var path: Path
    
    var rootObject: PBXProject? {
        pxbproj.pbxproj.rootObject
    }
    
    var projectFolderPath: Path {
        path.parent()
    }
}

extension DefaultProject {
    func localize(fileGenerator: FileGeneratorType, languageCode: String) throws
    {
        guard let rootObject = rootObject
        else {
            throw LocalizationHelperError.projectNotFound
        }
        
        // add knownRegions if not exists
        if !rootObject.knownRegions.contains(languageCode) {
            rootObject.knownRegions.append(languageCode)
        }
        
        // find Localizable.strings group
        var localizableStringsGroup = rootObject.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)
        
        // Localizable.strings group is not exists
        if localizableStringsGroup == nil
        {
            // create Localizable.strings group
            let group = rootObject.mainGroup.children.first(where: {$0.path == target.name}) as? PBXGroup
            
            localizableStringsGroup = try group?.addVariantGroup(named: LOCALIZABLE_STRINGS).first
            
            guard let localizableStringsGroup = localizableStringsGroup
            else {
                throw LocalizationHelperError.couldNotCreateLocalizableStringsGroup
            }
            
            // add Localizable.strings group to target
            let fileBuildPhases = target.buildPhases.first(where: {$0 is PBXSourcesBuildPhase})
            _ = try fileBuildPhases?.add(file: localizableStringsGroup)
        }
        
        // get localizableStringsGroup's path
        guard let localizableStringsGroup = localizableStringsGroup
        else {
            throw LocalizationHelperError.localizableStringsGroupNotFound
        }
        
        guard let localizableStringsGroupFullPath = try localizableStringsGroup.fullPath(sourceRoot: projectFolderPath)
        else {
            throw LocalizationHelperError.localizableStringsGroupFullPathNotFound
        }
        
        // add <languageCode>.lproj/Localizable.strings to project at localizableStringsGroupPath
        try fileGenerator.generateFile(at: localizableStringsGroupFullPath + "\(languageCode).lproj", fileName: LOCALIZABLE_STRINGS, content: .stringsFileHeader)
        
        let newFileFullPath = localizableStringsGroupFullPath + "\(languageCode).lproj" + LOCALIZABLE_STRINGS
        try localizableStringsGroup.addFile(at: newFileFullPath, sourceRoot: projectFolderPath)
        
        // set flag CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED = YES
        let key = "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED"
        target.buildConfigurationList?.buildConfigurations.forEach {
            $0.buildSettings[key] = "YES"
        }
        
        // save project
        try pxbproj.write(path: path)
    }
    
    func getLocalizableStringsGroupFullPath() -> Path? {
        try? rootObject?.mainGroup
            .group(named: LOCALIZABLE_STRINGS, recursively: true)?
            .fullPath(sourceRoot: projectFolderPath)
    }
}
