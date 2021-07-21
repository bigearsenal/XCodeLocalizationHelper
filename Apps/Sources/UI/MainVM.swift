//
//  MainVM.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 10/17/20.
//

import Foundation
import Combine
import XcodeProj
import PathKit
import LocalizationHelperKit

public class MainVM: ObservableObject {
    // MARK: - Constants
    private let projectPathKey = "KEYS.PROJECT_PATH"
    private let LOCALIZABLE_STRINGS = "Localizable.strings"
    public let projectExtension = ".xcodeproj"
    
    // MARK: - Subjects
    @Published public var project: XcodeProj?
    @Published public var error: Error?
    @Published public var localizationFiles = [LocalizableFile]()
    @Published public var query = ""
    
    // MARK: - Variables
    public var mainGroup: PBXGroup? {
        rootObject?.mainGroup.children.first as? PBXGroup
    }
    public var mainGroupPath: Path? {
        guard let path = projectPath,
              let projectName = projectName
        else {return nil}
        return path.parent() + projectName
    }
    public var rootObject: PBXProject? {
        project?.pbxproj.rootObject
    }
    public var projectName: String? {
        rootObject?.name
    }
    public var target: PBXTarget? {
        rootObject?.targets.first
    }
    
    // MARK: - Private
    private var projectPath: Path? {
        didSet {
            UserDefaults.standard.set(projectPath?.string, forKey: projectPathKey)
        }
    }
    
    // MARK: - Initializers
    public init() {
        if let path = UserDefaults.standard.string(forKey: projectPathKey) {
            openProject(path: path)
        }
    }
    
    // MARK: - Project manager
    public func openProject(path: String) {
        // reset
        localizationFiles = []
        
        if path.hasSuffix(projectExtension) {
            do {
                let proj = try XcodeProj(pathString: path)
                error = nil
                projectPath = Path(path)
                project = proj
                
                // if localization available
                let enStringsFile = mainGroupPath! + "en.lproj" + LOCALIZABLE_STRINGS
                if enStringsFile.isFile {
                    try openLocalizableFiles()
                }
            } catch {
                self.error = error
                closeProject()
            }
        } else {
            closeProject()
        }
    }
    
    public func closeProject() {
        projectPath = nil
        project = nil
    }
    
    public func saveProject() throws {
        guard let path = projectPath else {return}
        try project?.write(path: path)
    }
    
    // MARK: - Localization manager
    public func openLocalizableFiles() throws {
        guard let path = mainGroupPath else {return}
        let stringFiles = path.glob("*.lproj/Localizable.strings")
        localizationFiles = try stringFiles.compactMap { file -> LocalizableFile in
            let text = try file.read(.utf8)
            let array = text
                .components(separatedBy: .newlines)
                .map {
                    $0.components(separatedBy: "=")
                        .map {$0.trimmingCharacters(in: .whitespaces)}
                        .map {String($0.dropFirst().dropLast())}
                }
                .compactMap { pair -> LocalizableFile.Content? in
                    if pair.count != 2 {return nil}
                    if let key = pair.first,
                       !key.isEmpty,
                       let value = pair.last,
                       !value.isEmpty
                    {
                        return .init(key: key, value: value)
                    }
                    return nil
                }
            return LocalizableFile(
                languageCode: file.parent().lastComponent.replacingOccurrences(of: ".lproj", with: ""),
                path: file,
                content: array,
                newValue: ""
            )
        }
    }
    
    public func addLocalizationIfNotExists(code: String) throws {
        guard let mainGroupPath = mainGroupPath
        else {return}
        // add known regions
        if !rootObject!.knownRegions.contains(code) {
            rootObject?.knownRegions.append(code)
        }
        
        // add localizable.strings' group if not exists
        var gr = mainGroup?.group(named: LOCALIZABLE_STRINGS) ?? mainGroup?.group(named: "Resources")?.group(named: LOCALIZABLE_STRINGS)
        if gr == nil {
            gr = try mainGroup?.addVariantGroup(named: LOCALIZABLE_STRINGS).first
            
            // add group to target
            let fileBuildPhases = target?.buildPhases.first(where: {$0 is PBXSourcesBuildPhase})
            _ = try fileBuildPhases?.add(file: gr!)
        }
        
        // create localization folder and files
        if let path = try addLocalizableFile(code: code) {
            try gr?.addFile(at: path, sourceRoot: mainGroupPath.parent())
        }
        
        // set flag
        let key = "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED"

        target?.buildConfigurationList?.buildConfigurations.forEach {
            $0.buildSettings[key] = "YES"
        }
        
        try saveProject()
    }
    
    private func addLocalizableFile(code: String) throws -> Path? {
        guard let path = mainGroupPath else {return nil}
        
        let folder = path + "\(code).lproj"
        let file = folder + LOCALIZABLE_STRINGS
        if !file.exists {
            if !folder.exists {
                try folder.mkdir()
            }
            try file.write(
                """
                /*
                  Localizable.strings

                  Created with LocalizationHelper.
                  
                */
                
                
                """
            )
            return file
        }
        return nil
    }
    
    // MARK: - Helper
    public func addNewPhrase() {
        for var file in localizationFiles {
            let textToWrite = "\"\(query)\" = \"\(file.newValue)\";\n"
            guard let data = textToWrite.data(using: .utf8) else {return}
            do {
                let fileHandler = try FileHandle(forWritingTo: URL(fileURLWithPath: file.path.string))
                fileHandler.seekToEndOfFile()
                fileHandler.write(data)
                try fileHandler.close()

                file.content.append(LocalizableFile.Content(key: query, value: file.newValue))
                file.newValue = ""
                var files = localizationFiles
                if let index = files.firstIndex(where: {$0.id == file.id}) {
                    files[index] = file
                    localizationFiles = files
                }
            } catch {
                self.error = error
                return
            }
        }
    }
    
    
    // MARK: - Translation
    public func translate() {
        localizationFiles.forEach {file in
            guard !query.isEmpty else {return}
            let langCode = file.languageCode
            
            let completion: ((String) -> Void) = { text in
                var files = self.localizationFiles
                guard let index = files.firstIndex(where: {$0.languageCode == langCode}) else {return}
                var file = files[index]
                file.newValue = text
                files[index] = file
                self.localizationFiles = files
            }
            
            GoogleTranslate.translate(text: query, toLang: langCode) { (error, result) in
                DispatchQueue.main.async {
                    if error != nil || result == nil {return}
                    completion(result!)
                }
            }
        }
    }
    
    public func runSwiftgen() -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.arguments = ["-c", "\(projectPath!.parent().string)/Pods/swiftgen/bin/swiftgen config run --config \(projectPath!.parent().string)/swiftgen.yml"]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}
