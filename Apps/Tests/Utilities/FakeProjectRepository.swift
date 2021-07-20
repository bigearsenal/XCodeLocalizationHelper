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
    private let ciType: CIType
    
    init(fileName: String, targetName: String, ciType: CIType = .none) {
        self.fileName = fileName
        self.projectPath = homeUrl + "/" + fileName + "/" + fileName + ".xcodeproj"
        self.targetName = targetName
        self.ciType = ciType
    }
    
    func getProjectPath() -> String? {
        projectPath
    }
    
    func saveProjectPath(_ projectPath: String?) {}
    
    func getTargetName() -> String? {
        targetName
    }
    
    func saveTargetName(_ targetName: String?) {}
    
    func getCIType() -> CIType {
        ciType
    }
    
    func saveCIType(_ ciType: CIType) {}
}
