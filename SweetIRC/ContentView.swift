//
//  ContentView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 09/05/2020.
//  Copyright © 2020 Dan Stoian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var showNextScreen = false;
    
    @ObservedObject var userInformation: UserInformation = UserInformation()
    
    @State var selectedServer : ServerListEntry = ServerListEntry(firendlyName: "FreeNode", serverAddress: "irc.freenode.net")
    
    var body: some View {
        showView()
    }
    
    func showView() -> some View {
        Group {
            if showNextScreen {
                UserView(userInfo: self.userInformation, showPrev:  $showNextScreen)
            } else {
                self.mainBody.padding()
            }
        }
    }
}


extension ContentView {
    private var mainBody : some View {
        VStack {
            Field(fieldName: "Nick", value: $userInformation.nickName)
            Field(fieldName: "Username", value: $userInformation.userName)
            Field(fieldName: "Real name", value:  $userInformation.realName)
            ServerList(selectedServer: $selectedServer)
            Button("Connect"){
                self.showNextScreen.toggle()
                let coonection = Connection(userInfo: self.userInformation, serverAddress: self.selectedServer.serverAddress)
                coonection.conenct()
            }.disabled(!userInformation.isCompleted).padding(.bottom)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UserView: View {
    @ObservedObject var userInfo: UserInformation
    
    @Binding var showPrev : Bool
    
    var body: some View {
        VStack {
            TextField("Rea Name: ", text: $userInfo.realName)
            TextField("User Name:",text: $userInfo.userName)
            TextField("Nick Name:", text: $userInfo.nickName)
            Button("Go back"){
                self.showPrev.toggle()
            }
        }
    }
}
