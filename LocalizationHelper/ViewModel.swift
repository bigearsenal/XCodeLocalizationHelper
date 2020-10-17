//
//  ViewModel.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 10/17/20.
//

import Foundation
import Combine

struct LocalizationFile: Identifiable {
    struct Content: Identifiable {
        var value: String
        var id: String {value}
    }
    var languageCode: String
    var url: String
    var newValue: String
    var content: [Content]
    var isMatching: Bool?
    var id: String {
        url
    }
}

class ViewModel: ObservableObject {
    @Published var localizationFiles = [LocalizationFile]()
    @Published var query: String?
    
    func openProject(path: String) {
        localizationFiles = localizationFilesAtPath(path: path)
    }
    
    func translate() {
        localizationFiles.forEach {file in
            guard let query = query else {return}
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
    
    fileprivate func localizationFilesAtPath(path: String) -> [LocalizationFile] {
        let fileManager = FileManager.default
        
        guard let lastPath = path.components(separatedBy: "/").last else {
            return []
        }
        let newPath = path + "/" + lastPath
        guard let paths = fileManager.enumerator(atPath: newPath)?.allObjects as? [String] else {
            return []
        }
        let stringsFilePaths = paths.filter {$0.hasSuffix(".strings") && !$0.contains("InfoPlist")}
        
        return stringsFilePaths.compactMap { aPath in
            let path = newPath + "/" + aPath
            print(path)
            let text = try! String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
            let array = text.components(separatedBy: .newlines).map {LocalizationFile.Content(value: $0)}
            return LocalizationFile(languageCode: aPath.components(separatedBy: ".lproj").first?.components(separatedBy: "/").last ?? "", url: path, newValue: "", content: array)
        }
    }
}
