//
//  TestProjectRepository.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
@testable import LocalizationHelper
import PathKit

struct TestProjectRepository: ProjectRepositoryType {
    let testName: String
    
    func getCurrentProject() -> Project? {
        switch testName {
        case let testName where testName.starts(with: "TestWithTuist"):
            // TuistProject
            let path = Path(homeUrl) + testName + "Targets" + testName + "Resources"
            return .tuist(.init(path: path, resourcePath: path, projectName: testName))
        case let testName where testName.starts(with: "Test"):
            // DefaultProject
            let proj = try! getXcodeProj(fileName: testName)
            let target = proj.pbxproj.targets(named: testName).first!
            return .default(.init(pxbproj: proj, target: target, path: Path(xcodeprojPath(fileName: testName))))
        default:
            return nil
        }
    }
    
    func setCurrentProject(_ project: Project) {}
    
    func clearCurrentProject() {}
}
