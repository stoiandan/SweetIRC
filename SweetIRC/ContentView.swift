//
//  ContentView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 09/05/2020.
//  Copyright © 2020 Dan Stoian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var nickInfo :  String = ""
    @State var nameInfo : String = ""
    @State var userInfo : String = ""
    @State var selectedServer : String = "FreeNode"
    
    
    var body: some View {
        VStack {
            Field(fieldName: "Nick", value: $nickInfo)
            Field(fieldName: "Username", value: $nameInfo)
            Field(fieldName: "Real name", value:  $userInfo)
            ServerList(selectedServer: $selectedServer).frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                
            }){
                Text("Connect")
            }.padding(.bottom)
        }.frame(maxWidth: .infinity, alignment: .topLeading)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
