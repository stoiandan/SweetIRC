import Foundation
import SwiftUI
import Combine

class ChatVM: ObservableObject {
    
    @Published private(set) var rooms: [IRCSession.IRCChannel] = []
    
    @Published var selectedRomm: IRCSession.IRCChannel?
    
    
    private let session: IRCSession
    
    private let user: UserInfo
    
    
    public func roomListOf(_ content: String) -> PassthroughSubject<String,Error> {
        return session.listRoomsOf(content)
    }
    
    init(userInfo: UserInfo) {
        let streamTask = createStreamTask(to: userInfo.server!)
        self.user = userInfo
        self.session = IRCSession(with: streamTask)
    }
    
    
    public func connect() async {
        let room = await session.connect(as: user)
        await MainActor.run {
            rooms.append(room!)
            selectedRomm = room!
        }
    }
}
