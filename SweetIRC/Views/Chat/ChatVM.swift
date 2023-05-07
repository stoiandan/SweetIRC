import Foundation
import SwiftUI
import Combine

class ChatVM: ObservableObject {
    
    @Published private(set) var rooms: [IRCSession.IRCChannel] = []
    
    @Published var selectedRomm: IRCSession.IRCChannel?
    
    @Published var isListRoomPresented = false
    
    
    private let session: IRCSession
    
    
    public let roomListVM: RoomListViewModel
    
    
    
    init(session: IRCSession) {
        self.session = session
        self.roomListVM = RoomListViewModel(search: session.listRoomsOf)
    }
    
    public func joinRoomCallBack(roomName: String) async {
        let room = await session.joinChannel(roomName)
        
        await MainActor.run {
            if let room {
                rooms.append(room)
            }
            isListRoomPresented.toggle()
        }
    }
    
    
    public func connect() async {
        let room = await session.connect()
        await MainActor.run {
            rooms.append(room!)
            selectedRomm = room!
        }
    }
}
