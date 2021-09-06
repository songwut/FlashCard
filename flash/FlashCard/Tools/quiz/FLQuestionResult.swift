//
//  FLQuestionResult.swift
//  flash
//
//  Created by Songwut Maneefun on 16/8/2564 BE.
//

import Foundation
import ObjectMapper

class FLQuestionResult:Mappable {

    var id = 0
    var value = ""
    var choiceList = [FLChoiceResult]()
    var answer: FLAnswerResult?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id           <- map["id"]
        value        <- map["value"]
        choiceList   <- map["choice"]
        answer       <- map["choice"]
    }
}
