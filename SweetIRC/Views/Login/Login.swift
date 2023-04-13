//
//  Login.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.10.2022.
//

import SwiftUI

struct Login: View {
    @ObservedObject var vm = LoginVM()
    
    var body: some View {
        VStack {
            Text("SweetIRC")
                .font(.title)
                .padding()
            Spacer()
            Form {
                TextField("Nickname:", text: $vm.user.nickName, prompt: Text("nick name..."))
                TextField("Username:", text: $vm.user.userName)
                SecureField("Password:", text: $vm.user
                    .password, prompt: Text("password..."))
                TextField("Real name:", text: $vm.user.realName)
            }
            
            Picker("Server:", selection: $vm.user.server) {
                
                if vm.user.server == nil {
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
            if vm.isLoginEnabled {
                NavigationLink("Login", value: vm.user )
                    .withBlueStyle()
                    .transition(.slide)
                    .rotationEffect(vm.isRotated ? .degrees(180) : .zero)
                    .animation(.default, value: vm.isRotated)
            }
            Spacer()
            Spacer()
            
        }
        .padding()
        .frame(width: 300, height: 500)
        .animation(.default, value: vm.isLoginEnabled)
        
        
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
