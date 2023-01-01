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
                     Text("We're in")
                })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
