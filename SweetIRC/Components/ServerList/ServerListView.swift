//
//  ServerList.swift
//  SweetIRC
//
//  Created by Dan Stoian on 11/05/2020.
//  Copyright © 2020 Dan Stoian. All rights reserved.
//

import SwiftUI

    struct ServerList: View {
        
        private let servers : [ServerListEntry] = [ServerListEntry(firendlyName: "FreeNode", serverAddress: "irc.freenode.net"), ServerListEntry(firendlyName: "GimpNet", serverAddress: "irc.gimp.org")]
        
        @Binding  private (set) var selectedServer : ServerListEntry
        
        var body: some View {
            VStack {
                Text("Servers: ").font(.headline)
                Picker(selection: $selectedServer, label: EmptyView()){
                    ForEach(servers, id: \.self){
                        Text("\($0.firendlyName)")
                    }
                }.pickerStyle(RadioGroupPickerStyle())
            }.frame(maxWidth: .infinity, alignment: .leading).padding()
        }
    }

struct ServerList_Previews: PreviewProvider {
    static var previews: some View {
        ServerList(selectedServer: Binding.constant( ServerListEntry(firendlyName: "FreeNode", serverAddress: "dummy.co.uk")))
    }
}
