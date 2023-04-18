import Foundation
import SwiftUI
import Combine

class ChatVM: ObservableObject {
    
    @Published private(set) var rooms: [IRCSession.IRCChannel] = []
    
    @Published var selectedRomm: IRCSession.IRCChannel?
    
    
    private let session: IRCSession
    
    private let user: UserInfo
    
    
    var roomListViewModel: RoomListViewModel {
        return RoomListViewModel(search: session.listRoomsOf)
    }
    
    
    init(session: IRCSession, user: UserInfo) {
        self.session = session
        self.user = user
    }
    
    
    public func connect() async {
        let room = await session.connect(as: user)
        await MainActor.run {
            rooms.append(room!)
            selectedRomm = room!
        }
    }
}
