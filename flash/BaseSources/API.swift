//
//  API.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SystemConfiguration

class API {
        
    class func getCookie(name: String) -> String? {
        if let csrftoken = UserManager.shared.csrftoken {
            return csrftoken
        } else if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == name {
                    UserManager.shared.csrftoken = cookie.value
                    return cookie.value
                }
            }
        }
        return nil
    }
    
    class func deleteCookies() {
        let cookieJar = HTTPCookieStorage.shared
        UserManager.shared.csrftoken = nil
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
    class func checkInternet() {
        let isHiddenKeep = UserManager.shared.tabMenu?.isHidden ?? false
        let currentVC = UserManager.shared.currentVC
        // MARK: case Internet disconnect
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
            if let currentVC = UserManager.shared.currentVC {
                UserManager.shared.popUpMaintenance(vc: currentVC)
            }
        } else {
            let popup: PopupContent
            let detailText = "error_network_desc".localized()
            popup = PopupContent(title: "error_network_title".localized(), detail: detailText, icon: UIImage(named: "ic_v2_network_disconnected"), otherButtonTitles: nil,  closeButtonTitle: "try_again".localized(), isError: true)
            
            let didClose = DidAction(handler: { (sender) in
                UserManager.shared.tabMenu?.setTabBar(isHidden: isHiddenKeep)
                if let nav = currentVC?.navigationController as? UINavigationController {
                    nav.hideLoading()
                    nav.popViewController(animated: true)
                    self.checkInternet()
                } else {
                    if let vc = currentVC, vc.errorAutoDismiss {
                        currentVC?.hideLoading()
                        currentVC?.dismiss(animated: true, completion: nil)
                        self.checkInternet()
                    }
                }
            })
            let vc = UserManager.shared.tabMenu ?? UserManager.shared.rootVC
            PopupViewController.showVC(vc!, content: popup, didClose: didClose)
        }
    }
    
    class func createResponseBody(_ responseData: Data?, urlResponse: HTTPURLResponse?, url:String) -> ResponseBody? {
        print("Request url: \(url))")
        print("statusCode: \(String(describing: urlResponse?.statusCode)))")
        print("HTTPURLResponse: \(String(describing: urlResponse)))")
//        API.checkAuthorized(response: urlResponse, responseBody: responseBody)
        
        if let data = responseData, data.count > 0 {
            do {
                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    ConsoleLog.show("Response Body object: \(String(describing: dict))")
                    let responseBody = ResponseBody(detail: dict["detail"] as? String, username: dict["username"] as? [String], password: dict["password"] as? [String], isRemember: dict["is_remember"] as? Bool, language: dict["language"] as? String, urlResponse: urlResponse, dict:dict, dictList:[])
                    //API.checkAuthorized(response: urlResponse, responseBody: responseBody)
                    return responseBody
                    
                } else if let dictList = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    ConsoleLog.show("Response Body list: \(String(describing: dictList))")
                    let responseBody = ResponseBody(detail: nil, username: nil, password: nil, isRemember: nil, language: nil, urlResponse: urlResponse, dict:nil, dictList:dictList)
                    //API.checkAuthorized(response: urlResponse, responseBody: responseBody)
                    return responseBody
                }
                
            } catch {
                ConsoleLog.show("JSON Error: ", error.localizedDescription)
                //API.checkAuthorized(response: urlResponse, responseBody: nil)
                return nil
            }
        }
        //API.checkAuthorized(response: urlResponse, responseBody: nil)
        return nil
    }
    
    class func request<T: Mappable>(_ request : APIRequest ,completionHandler : @escaping (_ responseBody: ResponseBody?, _ item : T?, _ isCache : Bool, _ error : Error?) -> Void) {
        
        let isHiddenKeep = UserManager.shared.tabMenu?.isHidden ?? false
        let currentVC = UserManager.shared.currentVC
        // MARK: case Internet disconnect
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
            if let currentVC = UserManager.shared.currentVC {
                UserManager.shared.popUpMaintenance(vc: currentVC)
            }
        } else {
            let popup: PopupContent
            let detailText = "error_network_desc".localized()
            popup = PopupContent(title: "error_network_title".localized(), detail: detailText, icon: UIImage(named: "ic_v2_network_disconnected"), otherButtonTitles: nil,  closeButtonTitle: "try_again".localized(), isError: true)
            
            let didClose = DidAction(handler: { (sender) in
                UserManager.shared.tabMenu?.setTabBar(isHidden: isHiddenKeep)
                if let nav = currentVC?.navigationController {
                    nav.hideLoading()
                    nav.popViewController(animated: true)
                    self.checkInternet()
                } else {
                    if let vc = currentVC, vc.errorAutoDismiss {
                        currentVC?.hideLoading()
                        currentVC?.dismiss(animated: true, completion: nil)
                        self.checkInternet()
                    }
                }
            })
            let vc = UserManager.shared.tabMenu ?? UserManager.shared.rootVC
            PopupViewController.showVC(vc!, content: popup, didClose: didClose)
        }
        
        let method = Alamofire.HTTPMethod(rawValue: request.method.rawValue)
        let urlString = request.urlStrWithFormat(request.url, method: method)
        let params = request.params ?? request.body
        let keyPath = request.responseKeyPath
        let headers = request.headers
        let encoding = getEncoding(request.paramsType)
        ConsoleLog.trackAPI(request)
        let r = AF.request(urlString, method: method, parameters: params, encoding: encoding, headers: HTTPHeaders(headers!), interceptor: nil)
        r.validate(statusCode: 200..<300)
        r.responseObject(queue: .main, keyPath: keyPath, mapToObject: nil, context: nil) { (response: DataResponse<T, AFError>) in
            switch response.result {
            case .success:
                if let value = response.value {
                    completionHandler(API.createResponseBody(response.data, urlResponse: response.response, url:request.url), value, false, nil)
                }
                
            case .failure(let error):
                completionHandler(API.createResponseBody(response.data, urlResponse: response.response, url:request.url), nil, false, error as NSError)
            }
        }
        
    }
    
    class func requestForItem<T : Mappable>(_ request : APIRequest , completionHandler : @escaping (_ responseBody: ResponseBody?, _ item : T?, _ isCache : Bool, _ error : NSError?) -> Void) {
        
        let method = Alamofire.HTTPMethod(rawValue: request.method.rawValue)
        let urlString = request.urlStrWithFormat(request.url, method: method)
        let params = request.params ?? request.body
        let keyPath = request.responseKeyPath
        let headers = request.headers
        let encoding = getEncoding(request.paramsType)
        ConsoleLog.trackAPI(request)
        let r = AF.request(urlString, method: method, parameters: params, encoding: encoding, headers: HTTPHeaders(headers!), interceptor: nil)
        r.validate(statusCode: 200..<300)
        r.responseObject(queue: .main, keyPath: keyPath, mapToObject: nil, context: nil) { (response: DataResponse<T, AFError>) in
            switch response.result {
            case .success:
                if let value = response.value {
                    completionHandler(API.createResponseBody(response.data, urlResponse: response.response, url:request.url), value, false, nil)
                }
                
            case .failure(let error):
                completionHandler(API.createResponseBody(response.data, urlResponse: response.response, url:request.url), nil, false, error as NSError)
            }
        }
        
    }
    
    class func requestForItems<T : Mappable>(_ request : APIRequest , completionHandler : @escaping (_ responseBody: ResponseBody?, _ items : [T]?, _ isCache : Bool, _ error : NSError?) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue: request.method.rawValue)
        let urlString = request.urlStrWithFormat(request.url, method: method)
        let params = request.params ?? request.body
        let keyPath = request.responseKeyPath
        let headers = request.headers
        let encoding = getEncoding(request.paramsType)
        ConsoleLog.trackAPI(request)
        let r = AF.request(urlString, method: method, parameters: params, encoding: encoding, headers: HTTPHeaders(headers!), interceptor: nil)
        r.validate(statusCode: 200..<300)
        r.responseArray(queue: .main, keyPath: keyPath, context: nil) { (response:DataResponse<[T], AFError>) in
            switch response.result {
            case .success:
                if let value = response.value {
                    completionHandler(API.createResponseBody(response.data, urlResponse: response.response, url:request.url), value, false, nil)
                } else {
                    completionHandler(API.createResponseBody(response.data, urlResponse: response.response, url:request.url), nil, false, response.error! as NSError)
                }
                
            case .failure(let error):
                completionHandler(API.createResponseBody(response.data, urlResponse: response.response, url:request.url), nil, false, error as NSError)
            }
        }
    }
    
    class func requestForStatus(_ request : APIRequest , completionHandler : @escaping (_ responseBody: ResponseBody?, _ status : Bool) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue: request.method.rawValue)
        let encoding = getEncoding(request.paramsType)
        let urlString = request.urlStrWithFormat(request.url, method: method)
        let params = request.params ?? request.body
        let headers = request.headers
        ConsoleLog.trackAPI(request)
        AF.request(urlString, method: method, parameters: params, encoding: encoding, headers: HTTPHeaders(headers!), interceptor: nil)
            .validate(statusCode: 200..<300)
            .response(completionHandler: { (response) in
                if let urlResponse = response.response {
                    completionHandler(API.createResponseBody(response.data, urlResponse: urlResponse, url:request.url), true)
                } else {
                    completionHandler(API.createResponseBody(response.data, urlResponse: response.response, url:request.url), false)
                }
            })
        
    }
    
}

extension API {
    fileprivate class func getEncoding(_ paramType: APIParameterType) -> ParameterEncoding {
        var encoding : ParameterEncoding
        switch paramType {
        case .url:
            encoding = URLEncoding()
        case .urlEncodedInURL:
            encoding = URLEncoding()
        case .json:
            encoding = JSONEncoding.default
        }
        return encoding
    }
}
