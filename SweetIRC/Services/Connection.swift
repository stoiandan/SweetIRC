//
//  Connection.swift
//  SweetIRC
//
//  Created by Dan Stoian on 24/05/2020.
//  Copyright © 2020 Dan Stoian. All rights reserved.
//

import Foundation
import Network


final class Connection {
    
    
    let userInfo : UserInformation
    
    let serverAddress : String
    
    
    init(userInfo : UserInformation, serverAddress: String) {
        self.serverAddress = serverAddress
        self.userInfo = userInfo
    }
    
}
