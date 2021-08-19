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
    var percent:NSNumber?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id        <- map["id"]
        value     <- map["value"]
        isAnswer  <- map["is_answer"]
        percent   <- map["percent"]
    }
}
