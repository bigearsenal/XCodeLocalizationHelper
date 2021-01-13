//
//  LocalizableFile.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 12/01/2021.
//

import PathKit

struct LocalizationFile: Identifiable {
    var languageCode: String
    var path: Path
    var content: [String: String]
    var isMatching: Bool?
    var id: String { path.string }
    
    // for writing
    var newValue: String
}
