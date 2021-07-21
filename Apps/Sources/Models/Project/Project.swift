//
//  Project.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 21/07/2021.
//

import Foundation

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
    func getLocalizableFiles() -> [LocalizableFile] {
        switch self {
        case .default(let project):
            return project.getLocalizableFiles()
        case .tuist(let project):
            return project.getLocalizableFiles()
        }
    }
}
