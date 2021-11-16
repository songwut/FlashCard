//
//  FLRequest.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation

enum EndPoint:String {
    case ugcFlashCardDetail = "ugc/flash-card/%@/"
    case ugcCardIdDropbox = "ugc/flash-card/%@/card/%@/dropbox/"
    case ugcCardList = "ugc/flash-card/%@/card/"
    case ugcCardListDuplicate = "ugc/flash-card/%@/card/duplicate/"
    case ugcCardDetailUserAnswer = "ugc/flash-card/%@/card/%@/answer/"
    case ugcCardListDetail = "ugc/flash-card/%@/card/%@/"
    case ugcFlashCard = "ugc/flash-card/"
    case ugcFlashColor = "ugc/flash-card/color/"
    case ugcFlashSticker = "ugc/flash-card/sticker/"
    case ugcFlashShape = "ugc/flash-card/shape/"
    
    case ugcFlashPostSubmit = "ugc/flash-card/%@/content-request/submit/"
    case ugcFlashPostCancel = "ugc/flash-card/%@/content-request/cancel/"
    
    case myContent = "content/my-content/"
    case tagList = "dashboard/tag/type/MATERIAL_TYPE/"
    case learningContentCoverList = "learning-content/content-cover/"
    case subCategory = "sub-category/"
    case learningMaterialDetail = "%@/%@/%@"//LM/type/id
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
        let enpointStr = endPoint.rawValue.contains("%@") ? String(format: endPoint.rawValue, arguments: self.arguments) : self.endPoint.rawValue
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

