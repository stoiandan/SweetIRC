
import Foundation

struct ServerInfo {
    static let servers: [ServerInfo] = [.init(friendlyName: "Libera Chat", domain: "irc.libera.chat", port: 6697), .init(friendlyName: "FreeNode", domain: "chat.freenode.net", port: 6697) ]
    
    let friendlyName: String
    let domain: String
    let port: Int
}
