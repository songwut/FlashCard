//
//  LoginRequest.swift
//  flash
//
//  Created by Songwut Maneefun on 5/8/2564 BE.
//

import Foundation

class LoginRequest: APIRequest {
    
    var username: String!
    var password: String!
    var isRemember = false
    var language = configLocale[defaultLanguageIndex]
    
    override var url : String {
        if isLoginConicle {
            return "\(apiURL)account/login/"
        } else {
            return "\(apiURL)account/login/mobile/"
        }
    }
    
    override var method: APIMethod {
        return .post
    }
    
    override var params: [String: AnyObject]? {
        //var dict = APIRequest.getDefaultParam()
        var dict = [String: AnyObject]()
        dict["username"] = username as AnyObject?
        dict["password"] = password as AnyObject?
        dict["is_remember"] = isRemember as AnyObject?
        dict["language"] = self.language as AnyObject?
        
        if isLoginConicle {
            dict["is_conicle_login"] = true as AnyObject?
            
        }
        return dict
    }
}

class AccountValidate: APIRequest {
    
    var code = ""
    
    override var url : String {
        return "\(apiURL)account/validate/"
        
    }
    
    override var method: APIMethod {
        return .post
    }
    
    override var params: [String: AnyObject]? {
        //var dict = APIRequest.getDefaultParam()
        var dict = [String: AnyObject]()
        dict["token"] = code as AnyObject?
        return dict
    }
}

class LoginQRCode: APIRequest {
    var code = ""
    
    override var url : String {
        return "\(apiURL)account/login/qrcode/"
        
    }
    
    override var method: APIMethod {
        return .post
    }
    
    override var params: [String: AnyObject]? {
        var dict = [String: AnyObject]()
        dict["code"] = code as AnyObject?
        return dict
    }
}
