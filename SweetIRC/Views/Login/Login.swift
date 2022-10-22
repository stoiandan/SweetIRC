//
//  Login.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.10.2022.
//

import SwiftUI

struct Login: View {
    @State var user: UserInfo = UserInfo.defaultUser
    
    var body: some View {
        VStack {
            Text("SweetIRC")
                .font(.title)
                .padding()
            
            Form {
                TextField("", text: $user.nickName)
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
