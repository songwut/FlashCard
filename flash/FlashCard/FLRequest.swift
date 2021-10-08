//
//  FLRequest.swift
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
    case ugcFlashCardDetail = "ugc/flash-card/%@/"
    case ugcCardIdDropbox = "ugc/flash-card/%@/card/%@/dropbox/"
    case ugcCardList = "ugc/flash-card/%@/card/"
    case ugcCardListDetail = "ugc/flash-card/%@/card/%@/"
    case ugcFlashCreate = "ugc/flash-card/"
    case ugcFlashColor = "ugc/flash-card/color/"
    case ugcFlashSticker = "ugc/flash-card/sticker/"
    case ugcFlashShape = "ugc/flash-card/shape/"
}

class FLRequest: APIRequest {
    
    var flashId:Int = 0
    var endPoint:EndPoint = .ugcFlashCreate
    var arguments = [String]()
    var selectList = [Int]()
    var parameter: [String: AnyObject]?
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
        if let param = self.parameter {
            return param
        }
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

