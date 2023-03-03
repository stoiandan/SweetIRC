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
                            .padding(.bottom, 0.2)
                                .font(.system(size: 12))

                        }
                }
            }
            
            HStack(spacing: .zero) {
                TextField("", text: $buffer, prompt: Text("enter text here..."))
                    .font(.system(size: 14))
                    .cornerRadius(43)
                Button("Send") {
                    
                }
                .withBlueStyle()
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
