//
//  ServerMessage.swift
//  SweetIRC
//
//  Created by Dan Stoian on 02.10.2022.
//

import Foundation


enum Response: Hashable {
    case fail
    case cotent(String)
}
