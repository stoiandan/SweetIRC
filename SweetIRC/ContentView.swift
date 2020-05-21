//
//  ContentView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 09/05/2020.
//  Copyright © 2020 Dan Stoian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var selectedServer : String = "FreeNode"
    
    @State var showNextScreen = false;
    
    @ObservedObject var userInformation: UserInformation = UserInformation()
    
    var body: some View {
        Group {
            if showNextScreen {
                UserView(userInfo: self.userInformation)
            } else {
                self.mainBody
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
    @State var userInfo: UserInformation
    var body: some View {
        VStack {
            Text("\(userInfo.realName)")
            Text("\(userInfo.nickName)")
            Text("\(userInfo.userName)")
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
