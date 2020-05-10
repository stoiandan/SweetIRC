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

    
    var body: some View {
        VStack {
            Field(fieldName: "Nick", value: $nickInfo)
            Field(fieldName: "Username", value: $nameInfo)
            Field(fieldName: "Real name", value:  $userInfo)

            List {
                Text("Servers: ").font(.headline)
                ForEach(0..<10, id: \.self){ index in
                    Text("\(index) ")
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
