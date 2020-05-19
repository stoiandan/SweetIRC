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
    
    @ObservedObject var userInformation: UserInformation = UserInformation()
    
    var body: some View {
        NavigationView {
            VStack {
                Field(fieldName: "Nick", value: $userInformation.nickName)
                Field(fieldName: "Username", value: $userInformation.name)
                Field(fieldName: "Real name", value:  $userInformation.realName)
                ServerList(selectedServer: $selectedServer)
                
                NavigationLink(destination: UserView(userInfo: self.userInformation)) {
                    Text("Connect")
                }
            }
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
            Text("\(userInfo.name)")
            Text("\(userInfo.nickName)")
            Text("\(userInfo.realName)")
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
