//
//  XCodeLocalizationHelperConfig.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 26/04/2023.
//

import Foundation

public struct Config: Codable {
    public init(automation: AutomationConfig) {
        self.automation = automation
    }
    
    public let automation: AutomationConfig
}

public struct AutomationConfig: Codable {
    public init(script: String, pathType: AutomationConfigPathType) {
        self.script = script
        self.pathType = pathType
    }
    
    public let script: String
    public let pathType: AutomationConfigPathType
}

public enum AutomationConfigPathType: String, Codable {
    case relative
    case absolute
}
