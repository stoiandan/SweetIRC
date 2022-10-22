//
//  Store.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.10.2022.
//

import Foundation


class Store: ObservableObject {
    
    @Published var user = UserInfo.defaultUser
}
