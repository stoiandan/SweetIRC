//
//  Field.swift
//  SweetIRC
//
//  Created by Dan Stoian on 10/05/2020.
//  Copyright © 2020 Dan Stoian. All rights reserved.
//

import SwiftUI

struct Field: View {
    
    let fieldName: String
    
    @Binding var value : String 

    
    var body: some View {
        HStack{
            Text("\(fieldName): ").frame(minWidth: 74, alignment: .leading)
            TextField("Please enter your \(fieldName.lowercased())...", text: $value).frame(width: 250)
            Spacer()
        }
    }
}

struct Field_Previews: PreviewProvider {
    static var previews: some View {
        Field(fieldName: "Name", value: Binding.constant("Joe"))
    }
}
