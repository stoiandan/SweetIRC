//
//  ChatDetail.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.01.2023.
//

import SwiftUI

struct ChatDetail: View {
    @ObservedObject var room: IRCSession.IRCChannel
    @State private var buffer = ""
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(room.messages, id: \.self ) { message in
                            Text(message)
                        }
                }
            }
            
            HStack(spacing: .zero) {
                TextField("", text: $buffer, prompt: Text("enter text here..."))
                Button("Send") {
                    
                }
            }
            .padding(.top)
        }
    }
}

struct ChatDetail_Previews: PreviewProvider {
    static var previews: some View {
    
        ChatDetail(room: .dummy)
    }
}
