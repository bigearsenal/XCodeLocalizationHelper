//
//  File.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
import XcodeProj

// FIXME: - REPLACE THIS URL BEFORE TESTING
let repositoryLocalURL = "/Users/bigears/Documents/macos/XCodeLocalizationHelper"

let homeUrl = repositoryLocalURL + "/Apps/Tests/"

let LOCALIZABLE_STRINGS = "Localizable.strings"

func xcodeprojPath(fileName: String) -> String {
    homeUrl + "/" + fileName + "/" + fileName + ".xcodeproj"
}
func getXcodeProj(fileName: String) throws -> XcodeProj {
    try XcodeProj(pathString: xcodeprojPath(fileName: fileName))
}
