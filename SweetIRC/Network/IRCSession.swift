

import Foundation
import Combine


public class IRCSession {
    static let minLenght = 1
    static let maxLenght = 200
    
    static let timeOut = 200.00
    
    private var publishers: [String:PassthroughSubject<Response,Never>] = ["System Room" : PassthroughSubject()]
    
    private let stream: URLSessionStreamTask
    
    
    
    public init(with streamTask: URLSessionStreamTask)  {
        stream = streamTask
    }
    
    
    public func connect(as user: UserInfo) async -> IRCChannel? {
        stream.startSecureConnection()
        stream.resume()

        let _ = await sendBatch(of: ["NICK \(user.nickName)","USER \(user.userName) 0 * :\(user.realName)"])
        
        return await joinChannel("System Room")
    }
    
    
    private func sendBatch(of messages: [String]) async -> Bool {
        for message in messages {
            guard await sendMessage(of: message) else {
                return false
            }
        }
        return true
    }
    
    
    private func sendMessage(of content: String) async -> Bool {
        let content = content + "\n"
        guard let data = content.data(using: .utf8) else {
            return false
        }
        
        return await sendData(data)
        
        func sendData(_ data: Data) async -> Bool {
            return  (try? await stream.write(data, timeout: IRCSession.timeOut)) != nil
        }
    }
    
    public func send(message: String, to: String) async -> Bool {
        return await sendMessage(of: "PRIVMSG \(to) :\(message)")
    }
    
    public func joinChannel(_ name: String) async -> IRCChannel? {
        guard publishers[name] != nil else {
            return nil
        }
        let publisher = PassthroughSubject<Response,Never>()
        publishers[name] = publisher
        let channel = IRCChannel(name: name, messagePublisher: publisher)
        return channel
    }
    
    private func listen() async {
        var parser = MessageParser()
        while true {
            let response = try? await stream.readData(ofMinLength: IRCSession.minLenght, maxLength: IRCSession.maxLenght, timeout: IRCSession.timeOut)
            
            guard let response else {
                break
            }
            
            let (data,isEOF) = response
            
            guard let data,
                  let message = String(data: data, encoding: .utf8),
                  isEOF == false else {
                break
            }
            
            let msg =  parser.pasrse(message)
            
            while let msg {
                if publishers[msg.from] != nil {
                    publishers[msg.from]?.send(.cotent(msg.content))
                } else {
                    publishers["System Room"]?.send(.cotent(msg.content))
                }
                let msg = parser.pasrse()
            }
        }
    }
    
}


public func createStreamTask(to server: ServerInfo) -> URLSessionStreamTask {
    URLSession.shared.streamTask(withHostName: server.domain, port: server.port)
}
