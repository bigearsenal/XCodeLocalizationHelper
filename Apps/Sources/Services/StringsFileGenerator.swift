//
//  StringsFileGenerator.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
import PathKit

protocol FileGeneratorType {
    func pathExists(path: Path) -> Bool
    func createFolder(path: Path) throws
    func write(file: Path, content: String) throws
}

extension FileGeneratorType {
    func generateFile(at path: Path, fileName: String, content: String) throws {
        let folder = path
        let file = folder + fileName
        
        if !pathExists(path: file) {
            if !folder.exists {
                try createFolder(path: folder)
            }
            try write(file: file, content: content)
        }
    }
}

struct StringsFileGenerator: FileGeneratorType {
    func pathExists(path: Path) -> Bool {
        path.exists
    }
    
    func createFolder(path: Path) throws {
        try path.mkdir()
    }
    
    func write(file: Path, content: String) throws {
        try file.write(content)
    }
}

#if DEBUG
class FakeStringsFileGenerator: FileGeneratorType {
    private var generatedFilePaths = [Path]()
    
    func pathExists(path: Path) -> Bool {
        generatedFilePaths.map {$0.parent()}.contains(path)
    }
    
    func createFolder(path: Path) throws {
        // do nothing
    }
    
    func write(file: Path, content: String) throws {
        // fake writing
        if !generatedFilePaths.contains(file) {
            generatedFilePaths.append(file)
        }
    }
}
#endif
