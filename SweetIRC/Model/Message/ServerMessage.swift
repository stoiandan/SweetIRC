//
//  Message.swift
//  SweetIRC
//
//  Created by Dan Stoian on 02.10.2022.
//

import Foundation


enum ServerMessage {
    
    
    private static let commandPattern = /:(?<from>[^ ]+) (?<code>\d+) (?<header>[^:]+):(?<content>.*)/
    
    private static let typicalPattern = /:(?<from>[^ ]+) (?<header>[^:]+):(?<content>.*)/
                                         
    
    private static let pingPattern = /PING :(?<server>.+)/
    
    init(_ content: String) {
        
        
        if let match = content.wholeMatch(of: ServerMessage.commandPattern)?.output {
            self = .command(String(match.0.dropFirst(1)), String(match.from), Int(match.code)!, String(match.header), String(match.content))
            return
        }
        
        
        if let match = content.wholeMatch(of: ServerMessage.typicalPattern)?.output {
            self = .typical(String(match.0.dropFirst(1)), String(match.from), String(match.header), String(match.content))
            return
        }
        
        if let match = content.wholeMatch(of: ServerMessage.pingPattern)?.output {
            self = .pingKeepAlive(String(match.0), String(match.server))
            return
        }
        
        self = .unknown(content)
    }
    
    
    case command(_ wholeMatch: String, _ from: String, _ code: Int, _ header: String, _ contet: String)
    
    case typical(_ wholeMatch: String, _ from: String, _ header: String, _ content: String)
    
    case pingKeepAlive(_ wholeMatch: String, _ sever: String)
    
    case unknown(_ wholeMatch: String)
    
}
