//
//  Channel.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.01.2023.
//

import Foundation


protocol Channel: ObservableObject {
    var name: String {get}
    
    var messages: [String] {get}
}
