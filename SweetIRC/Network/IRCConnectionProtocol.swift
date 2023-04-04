//
//  IRCConnectionProtocol.swift
//  SweetIRC
//
//  Created by Dan Stoian on 04.04.2023.
//

import Foundation


protocol IRCConnectionProtocol {
    func startSecureCoonection()
    
    func write(_ data: Data, timeout: TimeInterval) async throws
    
    func readData(ofMinLength: Int, maxLength: Int, timeout: TimeInterval) async throws -> (Data?, Bool)
}



class IRCConnection: IRCConnectionProtocol {
    static let minLenght = 1
    static let maxLenght = 512
    
    static let timeOut = 200.00

    
    
    let streamTask: URLSessionStreamTask
    
    
    init(streamTask: URLSessionStreamTask) {
        self.streamTask = streamTask
    }
    
    func startSecureCoonection() {
        streamTask.startSecureConnection()
        streamTask.resume()
    }
    
    func write(_ data: Data, timeout: TimeInterval) async throws {
        try await streamTask.write(data, timeout: timeout)
    }
    
    func readData(ofMinLength: Int, maxLength: Int, timeout: TimeInterval)async throws -> (Data?, Bool) {
        return try await streamTask.readData(ofMinLength: IRCConnection.minLenght, maxLength: IRCConnection.maxLenght, timeout: IRCConnection.timeOut)
    }

}


class IRCConnectionMock: IRCConnectionProtocol {
  
        
    func startSecureCoonection() {

    }
    
    func write(_ data: Data, timeout: TimeInterval) {
        
    }
    
    func readData(ofMinLength: Int, maxLength: Int, timeout: TimeInterval) async throws -> (Data?, Bool) {
        return ("das".data(using: .utf8), true)
    }

}
