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
                    " "
                }
                CharacterClass.any
            }
        }
        " "
        Capture {
            OneOrMore {
                NegativeLookahead {
                    " "
                }
                CharacterClass.digit
            }
        }
        
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
    
    mutating func pasrse(_ message: String  = "" ) -> Message? {
        buffer = buffer + message
        
        if let result = buffer.firstMatch(of: pattern) {
            let (wholeMatch, from, code, header, content) =  result.output
            
            buffer = String(buffer.dropFirst(wholeMatch.count))
            
            return Message(from: String(from), header: String(header), content: String(content), code: String(code))
        }
        return nil
    }
}
