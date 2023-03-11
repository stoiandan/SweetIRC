//
//  Chat.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.01.2023.
//

import SwiftUI

struct Chat: View {
    @StateObject var vm: ChatVM
    @State var isListRoomPresented = false
    
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
        .onAppear {
            Task {
                await vm.connect()
            }
        }
        .toolbar {
            Button("Join Room") {
                isListRoomPresented.toggle()
            }
        }
        .sheet(isPresented: $isListRoomPresented) {
            RoomListView(searchEngine: vm.roomListOf)
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat(vm: ChatVM(userInfo: .defaultUser))
    }
}
