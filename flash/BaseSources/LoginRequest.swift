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
    
    override var body: [String: Any]? {
        //var dict = APIRequest.getDefaultParam()
        var dict = [String: Any]()
        dict["username"] = username
        dict["password"] = password
        dict["is_remember"] = isRemember
        dict["language"] = self.language
        
        if isLoginConicle {
            dict["is_conicle_login"] = true
            
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
    
    override var body: [String: Any]? {
        //var dict = APIRequest.getDefaultParam()
        var dict = [String: Any]()
        dict["token"] = code
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
    
    override var body: [String: Any]? {
        var dict = [String: Any]()
        dict["code"] = code
        return dict
    }
}
