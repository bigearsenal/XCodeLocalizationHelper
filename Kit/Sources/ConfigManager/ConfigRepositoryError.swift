//
//  ConfigReaderError.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 26/04/2023.
//

import Foundation

enum ConfigRepositoryError: Error {
    case couldNotOpenFile
    case invalidFileFormat
}
