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
            else {throw Error.localizableStringsGroupNotFound}
            path = _path
        case .tuist(let project):
            path = project.resourcePath
        }
        let stringFiles = path.glob("*.lproj/Localizable.strings")
        return try stringFiles.compactMap { file -> LocalizableFile in
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
}
