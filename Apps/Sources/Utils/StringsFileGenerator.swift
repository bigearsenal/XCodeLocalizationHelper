//
//  StringsFileGenerator.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
import PathKit

protocol StringsFileGeneratorType {
    func generateStringsFile(at path: Path, languageCode: String) throws -> Path
}
