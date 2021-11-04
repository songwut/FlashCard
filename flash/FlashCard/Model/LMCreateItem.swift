//
//  LMCreateItem.swift
//  flash
//
//  Created by Songwut Maneefun on 3/11/2564 BE.
//

import Foundation
import ObjectMapper

class LMCreateItem: BaseResult {
    var contentCode: ContentCode = .flash
    var isReady: Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name         <- map["name"]
        contentCode  <- map["code"]
        isReady      <- map["is_available"]
    }
}
