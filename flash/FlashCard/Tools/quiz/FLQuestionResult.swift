//
//  FLQuestionResult.swift
//  flash
//
//  Created by Songwut Maneefun on 16/8/2564 BE.
//

import Foundation
import ObjectMapper

class FLQuestionResult:FlashElement {
    var value = ""
    var choiceList = [FLChoiceResult]()
    var answer: FLAnswerResult?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id           <- map["id"]
        value        <- map["value"]
        choiceList   <- map["choice"]
        answer       <- map["answer"]
    }
}
