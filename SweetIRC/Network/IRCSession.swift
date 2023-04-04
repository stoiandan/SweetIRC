import Foundation
import Combine


public class IRCSession {
    static let minLenght = 1
    static let maxLenght = 512
    
    static let timeOut = 200.00
    
    private var roomsCallbacks: [String: @MainActor (String) -> Void] = [:]
    
    private let ircConnection: IRCConnectionProtocol
    
    
    private let roomListSubject = PassthroughSubject<String,Error>()
    
    init(with ircConnection: IRCConnectionProtocol)  {
        self.ircConnection = ircConnection
    }
    
    
    public func connect(as user: UserInfo) async -> IRCChannel? {
        ircConnection.startSecureCoonection()
        
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
            return  (try? await ircConnection.write(data, timeout: IRCSession.timeOut)) != nil
        }
    }
    
    
    
    public func joinChannel(_ name: String) async -> IRCChannel? {
        func sendMessageCallback(of message: Message) async -> Bool {
            return await self.sendMessage(of: "PRIVMSG \(message.from) :\(message.content)")
        }
        
        guard !roomsCallbacks.keys.contains(name) else {
            return nil
        }
        let channel = IRCChannel(name: name, messageSender: { message in
            return await sendMessageCallback(of: message)
        })
        roomsCallbacks[name] =  channel.recieveMessage
        
        return channel
    }
    
    private func listen() async {
        var parser = MessageParser()
        while true {
            let response = try? await ircConnection.readData(ofMinLength: IRCSession.minLenght, maxLength: IRCSession.maxLenght, timeout: IRCSession.timeOut)
          
            guard let (data,isEOF) = response,
                  let data,
                  let message = String(data: data, encoding: .utf8),
                  isEOF == false else {
                break
            }
            
            for msg in parser.pasrse(message) {
                
                switch msg {
                    
                case .command(_, let from, let code, let header, let content):
                    switch code {
                    case 322:
                        await MainActor.run {
                            roomListSubject.send(String(header.split(separator: " ").reversed()[1]))
                        }
                    case 323:
                        await MainActor.run {
                            roomListSubject.send(completion: .finished)
                        }
                    default:
                        break
                    }
                    
                case .typical(_, let from, let header, let content):
                    if roomsCallbacks[from] != nil {
                        await roomsCallbacks[from]?(content)
                    } else {
                        await roomsCallbacks["System Room"]!("\(from): \(content)")
                    }
                case .pingKeepAlive(let server):
                    let ok = await sendMessage(of: "PING \(server)")
                    if !ok {
                        await roomsCallbacks["System Room"]!("ERROR: Could not send PING to \(server)")
                    }
                case .unknown(let content):
                    break
                }
            }
        }
    }
    
    public func listRoomsOf(_ content: String)  -> PassthroughSubject<String,Error> {
        Task {
            let success = await sendMessage(of: "LIST *\(content)*")
            if !success {
                self.roomListSubject.send(completion: .failure(ListViewError.fail))
            }
        }
        
        return self.roomListSubject
    }
}

extension IRCSession {
    public class IRCChannel: ObservableObject, Channel {
        let name: String
        
        @Published private(set) var messages: [String] = []
        
        private let messageSender: (Message) async -> Bool
        
        init(name: String, messageSender: @escaping (Message) async -> Bool)  {
            self.name = name
            self.messageSender = messageSender
        }
        
        public func sendMessage(_ content: String) {
            Task {
                let sent  = await messageSender(createMessage(content))
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
    static let dummy: IRCSession.IRCChannel = { let room =  IRCSession.IRCChannel(name: "Dummy", messageSender: {  message in
        return true
    })
        room.messages.append("Ximian: Hi!")
        room.messages.append("RedCarpet: How are you?")
        room.messages.append("Ximian: Oh, I'm fine, thanks! How about you?")
        room.messages.append("RedCarpet: I'm doing just fine, thanks!")
        
        return room
    }()
}
