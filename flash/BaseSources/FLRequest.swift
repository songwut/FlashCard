//
//  FLRequest.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation

struct EndPointParam {
    var dict: [String: Any]?
    
    func tail() -> String {
        var tail = ""
        if let dict = self.dict {
            tail = tail + "?"
            for (key, value) in dict {
                var strValue = ""
                if let str = value as? String {
                    strValue = "\(str)"
                } else if let int = value as? Int {
                    strValue = "\(int)"
                }
                tail = tail + "&" + "\(key)=\(strValue)"
            }
        }
        return tail
    }
}

class FLRequest: APIRequest {
    
    var flashId:Int = 0
    var endPoint:EndPoint = .ugcFlashCard
    var arguments = [String]()
    var parameter: [String: Any]?
    var apiMethod: APIMethod = .get
    var apiType: APIParameterType = .url
    var nextUrl : String?
    var contentType = "application/json"
    var accept = "application/json"
    var endPointParam: EndPointParam?
    
    override var method: APIMethod {
        return self.apiMethod
    }
    
    override var paramsType: APIParameterType {
        return .json
    }
    
    override var url : String {
        if let nextUrl = self.nextUrl {//pagination
            return nextUrl
        }
        if self.flashId != 0 {
            self.arguments.insert("\(self.flashId)", at: 0)
        }
        var enpointStr = endPoint.rawValue.contains("%@") ? String(format: endPoint.rawValue, arguments: self.arguments) : self.endPoint.rawValue
        if let endPointParam = self.endPointParam {
            enpointStr = enpointStr + endPointParam.tail()
        }
        return "\(apiURL)\(enpointStr)"
    }
    
    override var body: [String: Any]? {
        if let param = self.parameter {
            return param
        } else {
            return nil
        }
    }
    
    override var headers: [String: String]? {
        if self.method == .post || self.method == .patch || self.method == .delete {
            var dict = [String: String]()
            if let csrftoken = API.getCookie(name: "csrftoken") {
                dict["Accept"] = self.accept
                dict["Content-Type"] = self.contentType
                dict["X-CSRFToken"] = csrftoken
            }
            return dict
        } else {
            return super.headers
        }
    }
}

