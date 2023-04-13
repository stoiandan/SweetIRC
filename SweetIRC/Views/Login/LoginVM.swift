
import Foundation
import Combine
import SwiftUI

class LoginVM : ObservableObject {
    @Published var isLoginEnabled = false
    
    @Published var isRotated = false

    
    @Published var user = UserInfo.defaultUser
    
    private var subscribtions: Set<AnyCancellable> = Set()
    
    init() {
        $user.sink(receiveValue: {[weak self] user in
            if user.isInfoFilled != self?.isLoginEnabled {
                self?.isLoginEnabled.toggle()
                
                withAnimation(.linear) {
                    self?.isRotated.toggle()
                }
                self?.isRotated.toggle()
            }
                
        }).store(in: &subscribtions)
    }
}
