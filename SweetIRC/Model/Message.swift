//
//  Message.swift
//  SweetIRC
//
//  Created by Dan Stoian on 02.10.2022.
//

import Foundation


struct Message {
    let from: String
    let header: String
    let content: String
    let code: String
    
    let message: String
    
    
    init(header: String, content: String) {
        self.message = header + ":" + content
        self.header = header
        self.content = content
        
        let split = header.split(separator: " ")
        
        self.from = String(split.first!)
        
        self.code = String(split[1])
        
    }
}
