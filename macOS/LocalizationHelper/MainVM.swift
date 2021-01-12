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

class MainVM: ObservableObject {
    // MARK: - Constants
    private let projectPathKey = "KEYS.PROJECT_PATH"
    let projectExtension = ".xcodeproj"
    
    // MARK: - Subjects
    @Published var project: XcodeProj?
    @Published var error: Error?
    
    // MARK: - Variables
    var mainGroup: PBXGroup? {
        rootObject?.mainGroup.children.first as? PBXGroup
    }
    var rootObject: PBXProject? {
        project?.pbxproj.rootObject
    }
    
    // MARK: - Private
    private var projectPath: String? {
        didSet {
            UserDefaults.standard.set(projectPath, forKey: projectPathKey)
        }
    }
    
    // MARK: - Initializers
    init() {
        if let path = UserDefaults.standard.string(forKey: projectPathKey) {
            openProject(path: path)
        }
    }
    
    // MARK: - Project manager
    func openProject(path: String) {
        if path.hasSuffix(projectExtension) {
            do {
                let proj = try XcodeProj(pathString: path)
                error = nil
                projectPath = path
                project = proj
            } catch {
                self.error = error
                closeProject()
            }
        } else {
            closeProject()
        }
    }
    
    func closeProject() {
        projectPath = nil
        project = nil
    }
    
    func saveProject() throws {
        guard let path = projectPath else {return}
        try project?.write(path: Path(path))
    }
    
//    func translate() {
//        localizationFiles.forEach {file in
//            guard let query = query else {return}
//            let langCode = file.languageCode
//            
//            let completion: ((String) -> Void) = { text in
//                var files = self.localizationFiles
//                guard let index = files.firstIndex(where: {$0.languageCode == langCode}) else {return}
//                var file = files[index]
//                file.newValue = text
//                files[index] = file
//                self.localizationFiles = files
//            }
//            
//            GoogleTranslate.translate(text: query, toLang: langCode) { (error, result) in
//                DispatchQueue.main.async {
//                    if error != nil || result == nil {return}
//                    completion(result!)
//                }
//            }
//        }
//    }
//    
//    fileprivate func localizationFilesAtPath(path: String) -> [LocalizationFile] {
//        let fileManager = FileManager.default
//        var path = path
//        
//        // get project's path
//        path = path.components(separatedBy: "/").dropLast(2).joined(separator: "/")
//        
//        guard let paths = fileManager.enumerator(atPath: path)?.allObjects as? [String] else {
//            return []
//        }
//        let stringsFilePaths = paths.filter {$0.hasSuffix("Localizable.strings")}
//        
//        return stringsFilePaths.compactMap { aPath in
//            let path = path + "/" + aPath
//            print(path)
//            let text = try! String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
//            let array = text.components(separatedBy: .newlines)
//                .map { $0.components(separatedBy: "=").map {$0.trimmingCharacters(in: .whitespaces)}.map {$0.replacingOccurrences(of: "\"", with: "")} }
//                .map {LocalizationFile.Content(key: $0.first ?? "",value: String($0.last?.dropLast() ?? ";"))}
//            return LocalizationFile(languageCode: aPath.components(separatedBy: ".lproj").first?.components(separatedBy: "/").last ?? "", url: path, newValue: "", content: array)
//        }
//    }
//    
//    func runSwiftgen() -> String {
//        let task = Process()
//        let pipe = Pipe()
//        
//        task.standardOutput = pipe
//        task.arguments = ["-c", "\(projectFolder)/../Pods/swiftgen/bin/swiftgen config run --config \(projectFolder)/../swiftgen.yml"]
//        task.launchPath = "/bin/zsh"
//        task.launch()
//        
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let output = String(data: data, encoding: .utf8)!
//        
//        return output
//    }
}
