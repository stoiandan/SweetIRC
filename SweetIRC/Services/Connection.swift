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
    
    
    private let userInfo : UserInformation
    
    private let serverAddress : String
    
    
    private static let IRC_PORT : UInt16 = 6667
    
    
    init(userInfo : UserInformation, serverAddress: String) {
        self.serverAddress = serverAddress
        self.userInfo = userInfo
    }
    
    func conenct() {
        let queue = DispatchQueue(label: "Network Queue")
        let connection = NWConnection(host: .init(serverAddress), port: .init(integerLiteral: Connection.IRC_PORT), using: .tcp)
        
        connection.stateUpdateHandler = { state in
            switch state {
            case .failed(let error):
                print(error.localizedDescription)
                fatalError("Connection to server \(self.serverAddress) failed!")
            case .ready:
                print("Connection to server \(self.serverAddress) succeded!")
            case .preparing:
                print("Trying to connect to server \(self.serverAddress)...")
            default:
                print("\(state)")
            }
        }
        connection.start(queue: queue)
    }
    
}
