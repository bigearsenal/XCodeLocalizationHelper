//
//  ConfigRepositoryTests.swift
//  LocalizationHelperKitTests
//
//  Created by Chung Tran on 26/04/2023.
//

import XCTest
import LocalizationHelperKit

final class ConfigRepositoryTests: XCTestCase {

    var repository: ConfigRepositoryImpl!
    
    override func setUpWithError() throws {
        repository = .init(projectDir: "/Users/chungtran/documents/ios/p2p-wallet-ios")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetConfig() async throws {
        let config = try await repository.getConfig()
        XCTAssertEqual(config.automation.script, "swiftgen config run --config ${PROJECT_DIR}/swiftgen.yml")
        XCTAssertEqual(config.automation.pathType, .absolute)
    }

    func testSaveConfig() async throws {
        try await repository.saveConfig(
            .init(
                automation: .init(
                    script: "swiftgen config run --config swiftgen.yml",
                    pathType: .relative
                )
            )
        )
    }
}
