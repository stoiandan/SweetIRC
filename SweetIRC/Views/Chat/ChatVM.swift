import Foundation


class ChatVM: ObservableObject {
    
    private(set) var rooms: [IRCChannel] = []
    
    private let session: IRCSession
    
    private let user: UserInfo
    
    init(userInfo: UserInfo) {
        let streamTask = createStreamTask(to: userInfo.server!)
        self.user = userInfo
        self.session = IRCSession(with: streamTask)
    }
    
    
    public func connect() async {
       let room = await session.connect(as: user)
        rooms.append(room!)
    }
}
