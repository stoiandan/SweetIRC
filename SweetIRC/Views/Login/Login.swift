//
//  Login.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.10.2022.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack {
            Text("SweetIRC")
                .font(.title)
                .padding()
            Spacer()
            Form {
                TextField("Nickname:", text: $store.user.nickName, prompt: Text("nick name..."))
                TextField("Username:", text: $store.user.userName)
                SecureField("Password:", text: $store.user
                    .password, prompt: Text("password..."))
                TextField("Real name:", text: $store.user.realName)
            }
            
            Picker("Server:", selection: $store.user.server) {
                
                if store.user.server == nil {
                    Text("Select a server")
                        .tag(nil as ServerInfo?)
                }
                
                ForEach(ServerInfo.servers, id: \.self) { server in
                    Text(server.friendlyName)
                        .tag(server as ServerInfo?)
                }
            }
            .padding(.top)
            Spacer()
            Button("Login") {
                
            }
            .withBlueStyle()
            
            Spacer()
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 500)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .environmentObject(Store())
    }
}
