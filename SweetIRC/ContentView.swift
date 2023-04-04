//
//  ContentView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 01.10.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Login()
                .navigationDestination(for: UserInfo.self, destination: { user in
                    let streamTask = createStreamTask(to: user.server!)
                    let session = IRCSession(with: IRCConnection(streamTask: streamTask))
                    Chat(vm: ChatVM(session: session, user: user))
                        .frame(minWidth: 800, minHeight: 600)
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
