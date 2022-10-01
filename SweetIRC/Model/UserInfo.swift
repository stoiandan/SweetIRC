import Foundation

public struct UserInfo {
    public static  let defaultUser = UserInfo(nickName: "dirk01", realName: "Dirk Abenhof", userName: "dirnk", password: "dirksis", server: ServerInfo.servers[0])
    public var nickName = ""
    public var realName = ""
    public var userName = ""
    public var password = ""
    
    public var server: ServerInfo?
    
    public var isInfoFilled: Bool {
        return !(nickName.isEmpty || realName.isEmpty || userName.isEmpty || password.isEmpty || server == nil )
    }
}
