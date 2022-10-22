//
//  View+BlueButton.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.10.2022.
//

import Foundation
import SwiftUI

struct BlueButtonStyle: ViewModifier {
    
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(.plain)
            .font(.system(size: 18))
            .padding(.horizontal)
            .background(.blue)
            .clipShape(Capsule())
    }
}


extension View {
    func withBlueStyle() -> some View {
        self.modifier(BlueButtonStyle())
    }
}
