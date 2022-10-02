//
//  IRCSessionTests.swift
//  SweetIRCTests
//
//  Created by Dan Stoian on 02.10.2022.
//

import XCTest
@testable import SweetIRC

final class IRCSessionTests: XCTestCase {
    
    var session: IRCSession!

    override func setUpWithError() throws {
        session = IRCSession(with: createStreamTask(to: ServerInfo.servers[0]))
    }

    override func tearDownWithError() throws {
        session = nil
    }

    func testConnect() throws {
        Task {
            let channel = await session.connect(as: UserInfo.defaultUser)
            XCTAssertTrue(channel != nil)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
