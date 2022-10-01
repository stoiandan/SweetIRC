import Foundation

struct UserInfo {
    let nickName: String
    let realName: String
    let userName: String
    let password: String
    
    let server: ServerInfo?
    
    var isInfoFilled: Bool {
        return !(nickName.isEmpty || realName.isEmpty || userName.isEmpty || password.isEmpty || server == nil )
    }
}
