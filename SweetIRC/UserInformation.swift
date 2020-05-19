//
//  UserInformation.swift
//  SweetIRC
//
//  Created by Geart Otten on 18/05/2020.
//  Copyright © 2020 Dan Stoian. All rights reserved.
//

import Foundation

class UserInformation: ObservableObject {
    @Published var name: String = ""
    @Published var nickName: String = ""
    @Published var realName: String = ""
}
