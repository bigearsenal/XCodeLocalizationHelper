//
//  Project.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 21/07/2021.
//

import Foundation
import PathKit

enum Project: Equatable {
    case `default`(DefaultProject)
    case tuist(TuistProject)
}

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
        return try stringFiles.compactMap { file -> LocalizableFile in
            // placeholder for new lines (for fixing conflict with invisible newline character)
            let newlinePlaceholder = "<--newline-->"
            
            // read file
            let text = try file.read(.utf8)
                .replacingOccurrences(of: "\\n", with: newlinePlaceholder)
            
            // get content
            let array = text
                .components(separatedBy: .newlines)
                .enumerated()
                .map { line -> LocalizableFile.Content in
                    // try parse to key value
                    let index = line.offset
                    let pair = line.element
                        .components(separatedBy: "=")
                        .map {$0.trimmingCharacters(in: .whitespaces)}
                        .map {
                            String($0.dropFirst())
                                .replacingLastOccurrenceOfString("\"", with: "")
                        }
                    
                    // check count of pair
                    guard pair.count == 2, !pair[0].isEmpty, !pair[1].isEmpty else {
                        return .init(
                            line: index,
                            undefinedString: line.element
                        )
                    }
                    
                    let key = pair[0]
                        .replacingOccurrences(of: newlinePlaceholder, with: "\\n")
                    let value = pair[1]
                        .replacingLastOccurrenceOfString(";", with: "")
                        .replacingOccurrences(of: newlinePlaceholder, with: "\\n")
                    
                    return .init(
                        line: index,
                        key: key,
                        value: value
                    )
                }
            return LocalizableFile(
                languageCode: file.parent().lastComponent.replacingOccurrences(of: ".lproj", with: ""),
                path: file,
                content: array,
                newValue: ""
            )
        }
    }
}

private extension String {
    func replacingLastOccurrenceOfString(_ searchString: String,
                                         with replacementString: String,
                                         caseInsensitive: Bool = true) -> String
    {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }
        
        if let range = self.range(of: searchString,
                                  options: options,
                                  range: nil,
                                  locale: nil) {
            
            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
}
