//
//  Chat.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.01.2023.
//

import SwiftUI

struct Chat: View {
    @State var vm: ChatVM
    
    var body: some View {
        NavigationSplitView(sidebar: {
            List(vm.rooms, id: \.self, selection: $vm.selectedRomm) { room in
                Text(room.name)
            }
        }, detail: {
            if let selectedRoom = vm.selectedRomm {
                ChatDetail(room: selectedRoom)
            }
        })
        .task {
            await vm.connect()
        }
        .toolbar {
            Button("Join Room") {
                vm.isListRoomPresented.toggle()
            }
        }
        .sheet(isPresented: $vm.isListRoomPresented) {
            RoomListView(viewModel: vm.roomListVM, joinRoom: vm.joinRoomCallBack) 
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat(vm: ChatVM(session: IRCSession(with: IRCConnectionMock(), as: UserInfo.defaultUser)))
    }
}
