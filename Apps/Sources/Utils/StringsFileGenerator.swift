//
//  StringsFileGenerator.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
import PathKit

protocol FileGeneratorType {
    func generateFile(at path: Path, fileName: String, languageCode: String) throws
}

struct StringsFileGenerator: FileGeneratorType {
    func generateFile(at path: Path, fileName: String, languageCode: String) throws {
        let folder = path
        let file = folder + fileName
        if !file.exists {
            if !folder.exists {
                try folder.mkdir()
            }
            try file.write(
                """
                /*
                  Localizable.strings

                  Created with XCodeLocalizationHelper (https://github.com/bigearsenal/xcodelocalizationhelper).
                  
                */
                
                
                """
            )
        }
    }
}
