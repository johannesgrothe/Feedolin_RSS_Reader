//
//  RSS_ReaderTests.swift
//  RSS_ReaderTests
//
//  Created by Emircan Duman on 29.10.20.
//

import XCTest
@testable import RSS_Reader

class RSS_ReaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStringExtensions() {
        testStrEx_chopPrefix()
        testStrEx_isAlphanumeric()
    }
    
    func testStrEx_chopPrefix() {
        XCTAssertTrue("test yolokopter".chopPrefix(5) == "yolokopter")
    }
    
    func testStrEx_isAlphanumeric() {
        XCTAssertTrue("1211".isAlphanumeric)
        XCTAssertTrue("1211ad".isAlphanumeric)
        XCTAssertTrue("dd12er11tz".isAlphanumeric)
        XCTAssertTrue(!"".isAlphanumeric)
        XCTAssertTrue(!"add$".isAlphanumeric)
        XCTAssertTrue(!"ad%d".isAlphanumeric)
    }

    /**
     func testExample() throws {
         // This is an example of a functional test case.
         // Use XCTAssert and related functions to verify your tests produce the correct results.
     }
     */
    
    /**
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
