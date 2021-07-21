//
//  Error.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 21/07/2021.
//

import Foundation

enum LocalizationHelperError: Swift.Error {
    case projectNotFound
    case targetNotFound
    case localizableStringsGroupNotFound
    case localizableStringsGroupFullPathNotFound
    case couldNotCreateLocalizableStringsGroup
    case resourcePathIsNotADirectory
}
