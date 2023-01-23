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
            List {
                ForEach(vm.rooms, id: \.name) { room in
                    Text(room.name)
                }
            }
        }, detail: {
            
        })
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat(vm: ChatVM(userInfo: .defaultUser))
    }
}
