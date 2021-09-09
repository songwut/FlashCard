//
//  ConsoleLog.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation

var isDebug: Bool {
    #if DEBUG
        return true
    #else
        return false
    #endif
}


public class ConsoleLog {
    
    class func show(_ text: String) {
        if isDebug == true {
            print(text)
        }
    }
    
    class func show(_ text: String, _ value: Any) {
        if isDebug == true {
            print(text, value)
        }
        
    }
    
    class func trackAPI(_ objectAPI:APIRequest? = nil) {
        
        if let api = objectAPI {
            let url = api.url
//            if url.hasPrefix(NotificationFirebaseRegisterRequest().url)
//                || url.hasPrefix(NotificationRequest().url)
//                || url.hasPrefix(LoginRequest().url)
//                || url.hasPrefix(SocialLoginRequest().url)
//                || url.hasPrefix(MaterialReadRequest().url)
//                || url.hasPrefix(VersionRequest().url)
//                || url.hasPrefix(ConfigRequest().url)
//                || url.hasPrefix(WaitingItemNotiRequest().url)
//                || url.hasPrefix(LogoutRequest().url) {
//                return
//            }
        }
    }
    
}
