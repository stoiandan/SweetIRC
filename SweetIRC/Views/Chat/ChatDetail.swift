//
//  ChatDetail.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.01.2023.
//

import SwiftUI

struct ChatDetail: View {
    let messages: [String]
    @State private var buffer = ""
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(messages.indices, id: \.self ) { idx in
                        Text(messages[idx])
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
        ChatDetail(messages: ["You: Hi!","You: Hi!", "Geana2014: Hi how are you!"])
    }
}
