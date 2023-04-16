//
//  Project.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 21/07/2021.
//

import Foundation
import PathKit
import LocalizationHelperKit

/// Project type
enum Project: Equatable {
    /// Default project without using tuist
    case `default`(DefaultProject)
    /// Project that was created using `tuist`
    case tuist(TuistProject)
}

/// Extension for project
extension Project {
    var rootFolder: Path {
        switch self {
        case .default(let project):
            return project.path.parent()
        case .tuist(let project):
            return project.path
        }
    }
    
    func localize(fileGenerator: FileGeneratorType, languageCode: String) throws
    {
        switch self {
        case .default(let project):
            try project.localize(fileGenerator: fileGenerator, languageCode: languageCode)
        case .tuist(let project):
            try project.localize(fileGenerator: fileGenerator, languageCode: languageCode)
        }
    }
    
    func getLocalizableFiles() throws -> [LocalizableFile] {
        let path: Path
        switch self {
        case .default(let project):
            guard let _path = project.getLocalizableStringsGroupFullPath()
            else {throw LocalizationHelperError.localizableStringsGroupNotFound}
            path = _path
        case .tuist(let project):
            path = project.resourcePath
        }
        let stringFiles = path.glob("*.lproj/Localizable.strings")
        return try stringFiles
            .compactMap { file -> LocalizableFile in
                try parseLocalizableFile(file)
            }
    }
    
    private func parseLocalizableFile(_ path: Path) throws -> LocalizableFile {
        // create line reader
        guard let lines = LineReader(path: path.string) else {
            throw LocalizationHelperError.lineReaderInitializingError
        }
        
        // read content of the file
        var content = [LocalizableFile.Content]()
        for line in lines {
            // get key and value
            let pair = line.string
                // separate key and value by a "="
                .components(separatedBy: "=")
            
            // key pair is available only if pair.count == 2, key and value is not empty
            guard pair.count == 2, !pair[0].isEmpty, !pair[1].isEmpty
            else {
                content.append(
                    .init(
                        offset: line.offset,
                        length: line.length,
                        undefinedString: line.string
                    )
                )
                continue
            }
            
            // fix key
            let key = pair[0]
                // trim spaces
                .trimmingCharacters(in: .whitespaces)
                // remove first and last "
                .replacingFirstAndLastOccurenceOf("\"", with: "")
            
            let value = pair[1]
                // trim spaces
                .trimmingCharacters(in: .whitespaces)
                // remove first and last "
                .replacingFirstAndLastOccurenceOf("\"", with: "")
                // remove last ";"
                .replacingLastOccurenceOf(";", with: "")
            
            content.append(
                .init(
                    offset: line.offset,
                    length: line.length,
                    key: key,
                    value: value
                )
            )
        }
        
        return LocalizableFile(
            languageCode: path.parent().lastComponent.replacingOccurrences(of: ".lproj", with: ""),
            path: path,
            content: content,
            newValue: ""
        )
    }
}

private extension String {
    func replacingFirstAndLastOccurenceOf(
        _ string: String,
        with replacementString: String,
        caseInsensitive: Bool = true
    ) -> String {
        // result
        var result = self
        
        // replacing first occurence
        result = result.replacingFirstOccurenceOf(string, with: replacementString)
        
        // replacing last occurence
        result = result.replacingLastOccurenceOf(string, with: replacementString)
        
        // return result
        return result
    }
    
    func replacingFirstOccurenceOf(
        _ string: String,
        with replacementString: String,
        caseInsensitive: Bool = true
    ) -> String {
        // replacing first occurence
        if let range = range(of: string, options: caseInsensitive ? [.caseInsensitive]: [])
        {
            return replacingCharacters(in: range, with: replacementString)
        }
        
        return self
    }
    
    func replacingLastOccurenceOf(
        _ string: String,
        with replacementString: String,
        caseInsensitive: Bool = true
    ) -> String {
        // replacing first occurence
        if let range = range(of: string, options: caseInsensitive ? [.backwards ,.caseInsensitive]: [.backwards])
        {
            return replacingCharacters(in: range, with: replacementString)
        }
        
        return self
    }
}
