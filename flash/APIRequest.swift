//
//  APIRequest.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation
import Alamofire

enum APIMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum APIParameterType {
    case url
    case urlEncodedInURL
    case json
}

class APINewRequest {
    
    var method: APIMethod = .get
    
    var paramsType: APIParameterType {
        return .url
    }
    
    var url: String {
        return apiURL
    }
    
    var params: [String: AnyObject]? {
        return nil
    }
    
    var isDismissIfError: Bool {
        return true
    }
    
    var encoding: URLEncoding {
        return URLEncoding.default
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var responseKeyPath: String {
        return ""
    }

    func urlStrWithFormat(_ urlStr: String, method: HTTPMethod) -> String {
        var urlFormat = urlStr
        if method == .get, !urlStr.contains("resumable") {
            if urlStr.contains("?") {
                urlFormat = urlFormat + "&format=json"
            } else {
                urlFormat = urlStr + "?format=json"
            }
        }
        return urlFormat
    }
    
}

class APIRequest {
    
    var method: APIMethod {
        return .get
    }
    
    var paramsType: APIParameterType {
        return .url
    }
    
    var url: String {
        return apiURL
    }
    
    var params: [String: AnyObject]? {
        return nil
    }
    
    var isDismissIfError: Bool {
        return true
    }
    
    var encoding: URLEncoding {
        return URLEncoding.default
    }
    
    var headers: [String: String]? {
        return APIRequest.getDefaultLoggedInHeader()
    }
    
    class func getDefaultLoggedInHeader() -> [String: String] {
        var params = [String: String]()
        //var params = self.getDefaultHeader()
/*
        if let sessionid = API.getCookie(name: "sessionid") {
            //params["Accept"] = "application/json"
            //params["Content-Type"] = "application/json"
            params["sessionid"] = sessionid
        }
        */
        return params
    }
    
    var responseKeyPath: String {
        return ""
    }

    func urlStrWithFormat(_ urlStr: String, method: HTTPMethod) -> String {
        var urlFormat = urlStr
        if method == .get, !urlStr.contains("resumable") {
            if urlStr.contains("?") {
                urlFormat = urlFormat + "&format=json"
            } else {
                urlFormat = urlStr + "?format=json"
            }
        }
        return urlFormat
    }
    
}


class JSONRequest {
    func requestList(_ fileName:String, completion : @escaping (_ item : Any)-> Void) {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            return
        }
        do {
            let jsonData = try Data(contentsOf: url)
            let responseObj = try JSONSerialization.jsonObject(with: jsonData)
            completion(responseObj)
        } catch {
            //handle error
            print(error)
        }
    }
}


