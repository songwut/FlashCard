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
    var isAnswer: Bool?
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
        if let isAnswer = self.isAnswer, isAnswer {
            return UIColor.success()
        } else {
            return UIColor.config_primary_25()
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
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id        <- map["id"]
        choiceId  <- map["choice_id"]
        value     <- map["value"]
    }
}
