//
//  StreamReaderTests.swift
//  LocalizationHelperKitTests
//
//  Created by Chung Tran on 15/04/2023.
//

import XCTest
import LocalizationHelperKit

final class StreamReaderTests: XCTestCase {
    var lines: LineReader!

    override func setUpWithError() throws {
        let filePath = Bundle.module
            .url(forResource: "Localizable", withExtension: "strings")!
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
        
        lines = .init(path: "/Users/chungtran/Documents/ios/LocalizationHelper/Kit/Tests/Resources/Localizable.strings")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        for line in lines {
            print(line)
        }
        
//        var line: String?
//
//        repeat {
//            print(lines.offset)
//            line = lines.nextLine()
//            print(lines.length)
//            print(line)
//        } while !lines.isAtEOF
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
