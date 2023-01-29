import Foundation
import Combine


public class IRCSession {
    static let minLenght = 1
    static let maxLenght = 200
    
    static let timeOut = 200.00
    
    private var roomsCallbacks: [String: @MainActor (String) -> Void] = [:]
    
    private let stream: URLSessionStreamTask
    
    
    
    public init(with streamTask: URLSessionStreamTask)  {
        stream = streamTask
    }
    
    
    public func connect(as user: UserInfo) async -> IRCChannel? {
        stream.startSecureConnection()
        stream.resume()
        
        let _ = await sendBatch(of: ["NICK \(user.nickName)","USER \(user.userName) 0 * :\(user.realName)"])
        Task {
            await self.listen()
            print("Done listening!")
        }
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
    
    private func sendMessage(of message: Message) async -> Bool {
        return await sendMessage(of: "PRIVMSG \(message.from) :\(message.content)")
    }
    
    public func joinChannel(_ name: String) async -> IRCChannel? {
        guard !roomsCallbacks.keys.contains(name) else {
            return nil
        }
        let channel = IRCChannel(name: name, session: self)
        roomsCallbacks[name] =  channel.recieveMessage
        return channel
    }
    
    private func listen() async {
        var parser = MessageParser()
        while true {
            let response = try? await stream.readData(ofMinLength: IRCSession.minLenght, maxLength: IRCSession.maxLenght, timeout: IRCSession.timeOut)
            
            guard let (data,isEOF) = response,
                  let data,
                  let message = String(data: data, encoding: .utf8),
                  isEOF == false else {
                break
            }
            
            for msg in parser.pasrse(message) {
                if roomsCallbacks[msg.from] != nil {
                    await roomsCallbacks[msg.from]?(msg.content)
                } else {
                    await roomsCallbacks["System Room"]!(msg.content)
                }
            }
        }
    }
}

extension IRCSession {
    public class IRCChannel: Channel, ObservableObject {
        let name: String
        
        @Published private(set) var messages: [String] = []
        
        private unowned let session: IRCSession
        
        init(name: String, session: IRCSession)  {
            self.name = name
            self.session = session
        }
        
        public func sendMessage(_ content: String) {
            Task {
                let sent  = await session.sendMessage(of: createMessage(content))
                if !sent {
                    await recieveMessage(content)
                }
            }
        }
        
        @MainActor
        public func recieveMessage(_ message: String) {
            messages.append(message)
        }
    }
}


public func createStreamTask(to server: ServerInfo) -> URLSessionStreamTask {
    URLSession.shared.streamTask(withHostName: server.domain, port: server.port)
}


extension IRCSession.IRCChannel: Hashable {
    public static func == (lhs: IRCSession.IRCChannel, rhs: IRCSession.IRCChannel) -> Bool {
        lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
}

extension IRCSession.IRCChannel {
    static let dummy: IRCSession.IRCChannel = .init(name: "Dummy", session: .init(with: createStreamTask(to: ServerInfo.servers[0])))
}
