//
//  ContentView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 09/05/2020.
//  Copyright © 2020 Dan Stoian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var nickName : String = ""
    @State var userName : String = ""
    @State var realName : String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Nickname: ")
                TextField("Please enter your nickname...", text: $nickName).frame(width: 250.0)
                Spacer()
            }
            HStack {
                Text("Username: ")
                TextField("Please enter your username...", text: $userName).frame(width: 250.0)
                Spacer()
                
            }
            HStack {
                Text("Real name: ")
                TextField("Please enter your real name...", text: $realName).frame(width: 250.0)
                Spacer()
                
            }
            List {
                Text("Servers: ").font(.headline)
                ForEach(0..<10, id: \.self){ index in
                    Text("\(index)")
                }
            }.listStyle(SidebarListStyle())
            Button(action: {
                
            }){
                Text("Connect")
            }.padding(.bottom)
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
