//
//  FakeFileGenerator.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
@testable import LocalizationHelper
import PathKit

struct FakeFileGenerator: FileGeneratorType {
    func generateFile(at path: Path, fileName: String) throws {
        print("Created file at path: \(path.string), filename: \(fileName)")
    }
}
