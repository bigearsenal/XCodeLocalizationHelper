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
        
        guard let lastPath = path.components(separatedBy: "/").last,
              let paths = fileManager.enumerator(atPath: path + "/" + lastPath)?.allObjects as? [String] else {
            return []
        }
        let stringsFilePaths = paths.filter {$0.hasSuffix(".strings") && !$0.contains("InfoPlist")}
        return stringsFilePaths.map {LocalizationFile(languageCode: $0.components(separatedBy: ".lproj").first ?? "", url: $0, newValue: "")} 
    }
}
