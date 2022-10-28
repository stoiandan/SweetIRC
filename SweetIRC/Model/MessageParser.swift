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
    
    private let pattern = Regex {
        ":"
        Capture {
            OneOrMore {
                NegativeLookahead {
                    ":"
                }
                CharacterClass.any
            }
        }
        ":"
        Capture {
            OneOrMore {
                NegativeLookahead {
                    "\r\n"
                }
                CharacterClass.any
            }
        }
        "\r\n"
    }
    
    mutating func pasrse(_ message: String ) -> [Message] {
        buffer = buffer + message
        var messages: [Message] = []
        for result in buffer.matches(of: pattern) {
            let (wholeMatch,header,content) = result.output
            buffer = String(buffer.dropFirst(wholeMatch.count))
            messages.append(Message(header: String(header), content: String(content)))
        }
        return messages
    }
}
