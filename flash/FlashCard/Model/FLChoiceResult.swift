//
//  FLChoiceResult.swift
//  flash
//
//  Created by Songwut Maneefun on 16/8/2564 BE.
//

import Foundation
import ObjectMapper

class FLChoiceResult:Mappable {

    var id = 0
    var value = ""
    var isAnswer: Bool = false
    var percent: NSNumber?
    var isHidden = false
    
    var progressValue: Float = 0
    
    func calProgress() {
        if let percent = self.percent {
            progressValue = percent.floatValue / 100
        } else {
            progressValue = 0.0
        }
    }
    
    func infoProgressColor() -> UIColor {
        if self.isAnswer {
            return UIColor.success()
        } else {
            return UIColor("F59293")
        }
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id        <- map["id"]
        value     <- map["value"]
        isHidden  <- map["is_hidden"]
        isAnswer  <- map["is_answer"]
        percent   <- map["percent"]
        
        calProgress()
    }
}

class FLAnswerResult:Mappable {

    var id = 0
    var value = ""
    var choiceId = 0
    var account: OwnerResult?
    
    func createJSON() -> [String: Any]? {
        var dict = [String: Any]()
        //dict["choice_id"] = self.choiceId
        dict["value"] = self.value
        return dict
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id        <- map["id"]
        choiceId  <- map["choice_id"]
        value     <- map["value"]
        account   <- map["account"]
    }
}
