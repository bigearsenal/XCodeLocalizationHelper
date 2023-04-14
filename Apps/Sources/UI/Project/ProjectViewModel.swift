//
//  ProjectViewModel.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 25/07/2021.
//

import Foundation
import LocalizationHelperKit
import AppKit

class ProjectViewModel: ObservableObject {
    // MARK: - Constants
    static let defaultCopyPattern = "NSLocalizedString(\"<key>\", comment: \"\")"
    static let defaultAutomationCommand = "Pods/swiftgen/bin/swiftgen config run --config swiftgen.yml"
    
    // MARK: - Dependencies
    @Injected var projectService: XCodeProjectServiceType
    
    // MARK: - Properties
    let project: Project
    
    @Published var localizableFiles = [LocalizableFile]()
    @Published var automationCommandOutPut: String?
    @Published var error: String?
    
    init(project: Project) {
        self.project = project
    }
    
    func refresh() {
        self.localizableFiles = (try? projectService.getLocalizableFiles(fromProject: project)) ?? []
    }
    
    func languagesDidSelect(_ languages: [ISOLanguageCode]) {
        do {
            for language in languages {
                try projectService.localizeProject(project, languageCode: language.code)
            }
        } catch {
            self.error = error.localizedDescription
        }
        refresh()
    }
    
    func clearTextFields() {
        var newFiles = localizableFiles
        for i in 0..<newFiles.count {
            newFiles[i].newValue = ""
        }
        localizableFiles = newFiles
    }
    
    func translate(query: String) {
        // translate
        localizableFiles.forEach {file in
            guard !query.isEmpty else {return}
            let langCode = file.languageCode
            
            let completion: ((String) -> Void) = { text in
                var files = self.localizableFiles
                guard let index = files.firstIndex(where: {$0.languageCode == langCode}) else {return}
                var file = files[index]
                file.newValue = text
                files[index] = file
                self.localizableFiles = files
            }
            
            GoogleTranslate.translate(text: query, toLang: langCode) { (error, result) in
                DispatchQueue.main.async { [weak self] in
                    if let error = error {
                        self?.error = error.localizedDescription
                    }
                    if let result = result {
                        completion(result)
                    }
                }
            }
        }
    }
    
    func addNewPhrase(key: String) {
        for var file in localizableFiles {
            let textToWrite = "\"\(key.trimmingCharacters(in: .whitespaces))\" = \"\(file.newValue.trimmingCharacters(in: .whitespaces))\";\n"
            guard let data = textToWrite.data(using: .utf8) else {return}
            do {
                let fileHandler = try FileHandle(forWritingTo: URL(fileURLWithPath: file.path.string))
                fileHandler.seekToEndOfFile()
                fileHandler.write(data)
                try fileHandler.close()

                file.content.append(
                    .init(
                        key: key,
                        value: file.newValue,
                        line: file.content.count
                    )
                )
                file.newValue = ""
                var files = localizableFiles
                if let index = files.firstIndex(where: {$0.id == file.id}) {
                    files[index] = file
                    localizableFiles = files
                }
            } catch {
                self.error = error.localizedDescription
                return
            }
        }
    }
    
    func removePhrase(key: String) {
        for index in 0..<localizableFiles.count {
            // find content's index
            guard let contentIndex = localizableFiles[index].content.firstIndex(where: {$0.key == key})
            else {
                continue
            }
            
//            // get content after removing
            var contentAfterRemoving = localizableFiles[index].content
            contentAfterRemoving.remove(at: contentIndex)
            
            // write to file
            do {
                // create content
                let contentToWrite = contentAfterRemoving
                    .map { "\"\($0.key)\" = \"\($0.value)\";"}
                    .joined(separator: "\n")
                + "\n" // last end of line
                
                // convert to data
                guard let data = contentToWrite.data(using: .utf8) else {
                    self.error = "invalid data"
                    return
                }
                
                // erase old data and write new one
                let fileHandler = try FileHandle(forWritingTo: URL(fileURLWithPath: localizableFiles[index].path.string))
                try fileHandler.truncate(atOffset: 0)
                try fileHandler.seek(toOffset: 0)
                fileHandler.write(data)
                
                // assign content
                localizableFiles[index].content = contentAfterRemoving
            } catch {
                self.error = error.localizedDescription
                return
            }
        }
    }
    
    func runAutomation(command: String?) {
        automationCommandOutPut = nil
        
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        
        task.arguments = ["-c", "cd \(project.rootFolder.string) && \(command ?? Self.defaultAutomationCommand)"]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        automationCommandOutPut = String(data: data, encoding: .utf8)
    }
    
    func copyToClipboard(text: String?) {
        guard let text = text else {return}
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}
