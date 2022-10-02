//
//  SweetIRCTests.swift
//  SweetIRCTests
//
//  Created by Dan Stoian on 01.10.2022.
//

import XCTest
@testable import SweetIRC

final class SweetIRCTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsUserField() throws {
        let user = UserInfo.defaultUser
        XCTAssert(user.isInfoFilled)
    }
    
    func testIsNotUserField() throws {
        // Arange
        var user = UserInfo()
        
        // Act
        user.nickName = "dirkOS"
        user.realName = "Drik Abendhof"
        
        // Asset 
        XCTAssertFalse(user.isInfoFilled)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
