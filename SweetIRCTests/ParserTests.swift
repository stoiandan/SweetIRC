//
//  ParserTests.swift
//  SweetIRCTests
//
//  Created by Dan Stoian on 22.10.2022.
//

import XCTest

@testable import SweetIRC

final class ParserTests: XCTestCase {
    
    var parser: MessageParser!

    override func setUpWithError() throws {
        //arrange
        parser = MessageParser()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleParse() throws {
        //act
        let message = ":platinum.libera.chat NOTICE * :*** Looking up your hostname...\r\n"
        let messages = parser.pasrse(message)
        
        let messageStrip = "platinum.libera.chat NOTICE * :*** Looking up your hostname..."
        //assert
        XCTAssertEqual(1, messages.count)
        XCTAssertEqual(messageStrip, messages[0].message)
    }
    
    func testSimpleParseWithCodeAndExtraCotent() throws {
        //act
        let message = "Some Cotent before :copper.libera.chat 252 dan01 36 :IRC Operators online\r\n Some extra content"
        
        
        let messages = parser.pasrse(message)
        
        let messageStrip = "copper.libera.chat 252 dan01 36 :IRC Operators online"
        //assert
        XCTAssertEqual(1, messages.count)
        XCTAssertEqual(messageStrip, messages[0].message)
    }
    
    
    func testSimpleParseWithColon() throws {
        //act
        let message = ":copper.libera.chat 252 dan01 36 :IRC Operators there is a colon here: online\r\n"
        
        
        let messages = parser.pasrse(message)
        
        let messageStrip = "copper.libera.chat 252 dan01 36 :IRC Operators there is a colon here: online"
        //assert
        XCTAssertEqual(1, messages.count)
        XCTAssertEqual(messageStrip, messages[0].message)
    }
    
    
    func testMultipleMessages() throws {
        //arange
        let message = ":silver.libera.chat 255 dan01 :I have 3398 clients and 1 servers\r\n:silver.libera.chat 265 dan01 3398 3448 :Current local users 3398, max 3448\r\n aditional"
        
        //act
        let messages = parser.pasrse(message)
        

        //assert
        let messageStrip = "silver.libera.chat 255 dan01 :I have 3398 clients and 1 servers"
        let messageStrip2 = "silver.libera.chat 265 dan01 3398 3448 :Current local users 3398, max 3448"

        XCTAssertEqual(2, messages.count)
        XCTAssertEqual(messageStrip, messages[0].message)
        XCTAssertEqual(messageStrip2, messages[1].message)

    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
