//
//  LogoutRequest.swift
//  LEGO
//
//  Created by Songwut Maneefun on 10/30/17.
//  Copyright © 2017 Conicle. All rights reserved.
//

import Foundation

class LogoutRequest: APIRequest {
    
    var fcmtoken: String?
    
    override var url : String {
        return "\(apiURL)account/logout/mobile/"
    }
    
    override var method: APIMethod {
        return .post
    }
    
    override var paramsType: APIParameterType {
        return .json
    }
    
    override var headers: [String: String]? {
        var dict = [String: String]()
        if let csrftoken = API.getCookie(name: "csrftoken") {
            dict["Accept"] = "application/json"
            dict["Content-Type"] = "application/json"
            dict["X-CSRFToken"] = csrftoken
        }
        return dict
    }
    
    override var params: [String: AnyObject]? {
        
        var dict = [String: AnyObject]()
        if let fcmtoken = self.fcmtoken {
            dict["fcmtoken"] = fcmtoken as AnyObject?
        }
        return dict
    }
}
