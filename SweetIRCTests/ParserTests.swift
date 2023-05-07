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

    func testSimpleParse()  {
        //act
        let message = ":platinum.libera.chat NOTICE * :*** Looking up your hostname...\r\n"
        let messages = parser.pasrse(message)
        
        let messageStrip = "platinum.libera.chat NOTICE * :*** Looking up your hostname..."
        
    
        //assert
        XCTAssertEqual(1, messages.count)
        guard case .typical(let match, _, _, _, _) = messages[0] else {
            XCTFail("message is not of type: \(String(describing: ServerMessage.typical))")
            return
        }
        XCTAssertEqual(match, messageStrip)
    }
    
    func testSimpleParseWithCodeAndExtraCotent()  {
        //act
        let message = ":copper.libera.chat 252 dan01 36 :IRC Operators online\r\n Some extra content"
        
        
        let messages = parser.pasrse(message)
        
        let messageStrip = "copper.libera.chat 252 dan01 36 :IRC Operators online"
        //assert
        XCTAssertEqual(1, messages.count)
        guard case .command(let wholeMatch, _, _, _, _) = messages[0] else {
            XCTFail("message is not of type: \(String(describing: ServerMessage.typical))")
            return 
        }
            XCTAssertEqual(wholeMatch, messageStrip)
    }
    
    
    func testSimpleParseWithColon() {
        //act
        let message = ":copper.libera.chat 252 dan01 36 :IRC Operators there is a colon here: online\r\n"
        
        
        let messages = parser.pasrse(message)
        
        let messageStrip = "copper.libera.chat 252 dan01 36 :IRC Operators there is a colon here: online"
        //assert
        XCTAssertEqual(1, messages.count)
        guard case .command(let wholeMatch, _, _,  _, _) = messages[0] else {
            XCTFail("message is not of type: \(String(describing: ServerMessage.typical))")
            return
        }
            XCTAssertEqual(wholeMatch, messageStrip)

    }
    
    
    func testMultipleMessages() {
        //arange
        let message = ":silver.libera.chat 255 dan01 :I have 3398 clients and 1 servers\r\n:silver.libera.chat 265 dan01 3398 3448 :Current local users 3398, max 3448\r\n aditional"
        
        //act
        let messages = parser.pasrse(message)
        

        //assert
        let messageStrip = "silver.libera.chat 255 dan01 :I have 3398 clients and 1 servers"
        let messageStrip2 = "silver.libera.chat 265 dan01 3398 3448 :Current local users 3398, max 3448"

        XCTAssertEqual(2, messages.count)
        guard case .command(let wholeMatch, _, _,  _, _) = messages[0] else {
            XCTFail("message1 is not of type: \(String(describing: ServerMessage.typical))")
            return
        }
            XCTAssertEqual(wholeMatch, messageStrip)

        guard case .command(let wholeMatch, _, _,  _, _) = messages[1] else {
            XCTFail("message2 is not of type: \(String(describing: ServerMessage.typical))")
            return
        }
            XCTAssertEqual(wholeMatch, messageStrip2)


    }
    
    func testMessageContent() {
        //arange
        let message = ":silver.libera.chat 255 dan01 :I have 3398 clients and 1 servers\r\n:silver.libera ARP 3398 3448 dan01 :Current local users 3398, max 3448\r\n aditional"
        
        //act
        let messages = parser.pasrse(message)
        

        //assert
        guard case .command(_, _,  let code, let header, let content) = messages[0] else {
            XCTFail("message is not of type: \(String(describing: ServerMessage.command))")
            return
        }
        XCTAssertEqual("I have 3398 clients and 1 servers", content)
        XCTAssertEqual("dan01 ", header)
        XCTAssertEqual(255, code)
        
        
        guard case .typical(_, let from, let header, let roomName, let content) = messages[1] else {
            XCTFail("message is not of type: \(String(describing: ServerMessage.typical))")
            return
        }
        
        
        XCTAssertEqual("silver.libera", from)
        XCTAssertEqual("Current local users 3398, max 3448", content)
        XCTAssertEqual("ARP 3398 3448", header)
        XCTAssertEqual("dan01", roomName)
    }
    
    
    func testEmptyConentMessage()  {
        //arange
        let message = ":greogry.palama.wisdom.chat 255 dan01 :\r\n"
        
        //act
        let messages = parser.pasrse(message)
        

        //assert
        guard case .command(_, _, _, _, let content) = messages[0] else {
            XCTFail("message is not of type: \(String(describing: ServerMessage.command))")
            return
        }
        XCTAssertEqual("", content)

    }
    
    func testforPing()  {
        //arange
        let message = "PING :serv.com.org\r\n"
        
        //act
        let messages = parser.pasrse(message)
        

        //assert
        XCTAssertEqual(1, messages.count)
        
        guard case .pingKeepAlive(_, let server) = messages[0] else {
            XCTFail("message is of wrong type")
            return
        }
        XCTAssertEqual("serv.com.org", server)


    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
