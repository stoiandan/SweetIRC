//
//  MessageParser.swift
//  SweetIRC
//
//  Created by Dan Stoian on 02.10.2022.
//

import Foundation
import RegexBuilder

struct MessageParser {
    private var buffer = ""
    
    private let pattern = /.+\r\n/
    
    mutating func pasrse(_ message: String ) -> [ServerMessage] {
        buffer = buffer + message
        var messages: [ServerMessage] = []
        for result in buffer.matches(of: pattern) {
            let (wholeMatch) = result.output
            buffer = String(buffer.dropFirst(wholeMatch.count))
            messages.append(ServerMessage(String(wholeMatch.dropLast(1))))
        }
        return messages
    }
}
