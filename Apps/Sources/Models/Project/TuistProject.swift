//
//  TuistProject.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 21/07/2021.
//

import Foundation
import PathKit

struct TuistProject: Equatable {
    var resourcePath: Path
}

extension TuistProject {
    func localize(fileGenerator: FileGeneratorType, languageCode: String) throws
    {
        let path = resourcePath
        guard path.isDirectory else {
            throw LocalizationHelperError.resourcePathIsNotADirectory
        }
        
        try fileGenerator.generateFile(at: path + "\(languageCode).lproj", fileName: LOCALIZABLE_STRINGS)
    }
}
