//
//  ViewModel.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 10/17/20.
//

import Foundation

struct LocalizationFile: Identifiable {
    var languageCode: String
    var url: String
    var newValue: String
    var content: [String]
    var id: String {
        url
    }
}

class ViewModel: ObservableObject {
    @Published var localizationFiles = [LocalizationFile]()
    
    func openProject(path: String) {
        localizationFiles = localizationFilesAtPath(path: path)
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
            let array = text.components(separatedBy: .newlines)
            return LocalizationFile(languageCode: path.components(separatedBy: ".lproj").first ?? "", url: path, newValue: "", content: array)
        }
    }
}
