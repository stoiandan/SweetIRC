//
//  Chat.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.01.2023.
//

import SwiftUI

struct Chat: View {
    @StateObject var vm: ChatVM
    
    var body: some View {
        NavigationSplitView(sidebar: {
            List(vm.rooms, id: \.self, selection: $vm.selectedRomm) { room in
                Text(room.name)
            }
        }, detail: {
            if let selectedRoom = vm.selectedRomm{
                ChatDetail(room: selectedRoom)
            }
        })
        .onAppear {
            Task {
                await vm.connect()
            }
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat(vm: ChatVM(userInfo: .defaultUser))
    }
}
