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
                    let session = IRCSession(with: IRCConnection(streamTask: streamTask), as: user)
                    Chat(vm: ChatVM(session: session))
                        .frame(minWidth: 800, minHeight: 600)
                })
        }
    }
}

#Preview {
    ContentView()
}

