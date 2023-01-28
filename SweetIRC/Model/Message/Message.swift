//
//  ChannelMessage.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.01.2023.
//

import Foundation



public struct Message {
    let from: String
    let content: String
    
    fileprivate init(from: String, _ content: String) {
        self.content = content
        self.from = from
    }
}


extension Channel {
    func createMessage(_ content: String) -> Message {
        Message(from: self.name, content)
    }
}
