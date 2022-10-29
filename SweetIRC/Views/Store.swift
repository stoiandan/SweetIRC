//
//  Store.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.10.2022.
//

import Foundation
import Combine
import SwiftUI


class Store: ObservableObject {
    
    @Published var isLoginEnabled = false
    
    @Published var user = UserInfo.defaultUser
    
    private var subscribtions: Set<AnyCancellable> = Set()
    
    init() {
        $user.sink(receiveValue: {[weak self] user in
                self?.isLoginEnabled = user.isInfoFilled
        }).store(in: &subscribtions)
    }
}
