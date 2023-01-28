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
            List(vm.rooms.indices, id: \.self, selection: $vm.selectedRommIndex) { idx in
                Text(vm.rooms[idx].name)
            }
        }, detail: {
            if  let selection = vm.selectedRommIndex,
                let selectedRoom = vm.rooms[selection] {
                ChatDetail(messages: selectedRoom.messages)
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
