//
//  InstructorResult.swift
//  Ondemand
//
//  Created by Songwut Maneefun on 5/17/17.
//  Copyright © 2017 Conicle.Co.,Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

class InstructorResult: ContentResult {

    var overview = ""
    var position = ""
    var positionType = 0
    var contact = ""
    var providers: [ProviderResult]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        position           <- map["position"]
        contact            <- map["contact"]
        providers          <- map["provider_list"]
        overview           <- map["overview"]
        positionType       <- map["type"]
        
    }
}
