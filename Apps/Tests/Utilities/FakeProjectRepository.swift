//
//  TestProjectRepository.swift
//  LocalizationHelperTests
//
//  Created by Chung Tran on 20/07/2021.
//

import Foundation
@testable import LocalizationHelper

struct FakeProjectRepository: ProjectRepositoryType {
    private let fileName: String
    private let targetName: String
    private let projectPath: String
    
    init(fileName: String, targetName: String) {
        self.fileName = fileName
        self.projectPath = homeUrl + "/" + fileName + "/" + fileName + ".xcodeproj"
        self.targetName = targetName
    }
    
    func getProjectPath() -> String? {
        projectPath
    }
    
    func saveProjectPath(_ projectPath: String?) {}
    
    func getTargetName() -> String? {
        targetName
    }
    
    func saveTargetName(_ targetName: String?) {}
}
