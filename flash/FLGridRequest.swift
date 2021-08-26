//
//  FLListRequest.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation

struct FLRequestSt {
    let id: Int
    let endPoint:EndPoint
}

enum EndPoint:String {
    case ugcFlashList = "ugc/flash-card/%@/card/"
    case ugcFlashCreate = "ugc/flash-card/"
    case ugcFlashColor = "ugc/flash-card/color/"
    case ugcFlashSticker = "ugc/flash-card/sticker/"//base64
    case ugcFlashShape = "ugc/flash-card/shape/"//base64
}

class FLRequest: APIRequest {
    
    var flashId:Int = 0
    var endPoint:EndPoint = .ugcFlashList
    var arguments = [String]()
    var selectList = [Int]()
    
    var apiMethod: APIMethod = .get
    
    override var method: APIMethod {
        return self.apiMethod
    }
    
    override var url : String {
        if self.flashId != 0 {
            self.arguments.insert("\(self.flashId)", at: 0)
        }
        let enpointStr = endPoint.rawValue.contains("%@") ? String(format: endPoint.rawValue, arguments: self.arguments) : self.endPoint.rawValue
        return "\(apiURL)\(enpointStr)"
    }
    
    override var params: [String: AnyObject]? {
        var dict = [String: AnyObject]()
        if self.selectList.count > 1 {
            dict["id_list"] = self.selectList as AnyObject?
        }
        return dict
    }
    
    override var headers: [String: String]? {
        if self.method == .post || self.method == .patch || self.method == .delete {
            var dict = [String: String]()
            if let csrftoken = API.getCookie(name: "csrftoken") {
                dict["Accept"] = "application/json"
                dict["Content-Type"] = "application/json"
                dict["X-CSRFToken"] = csrftoken
            }
            return dict
        } else {
            return super.headers
        }
    }
}
