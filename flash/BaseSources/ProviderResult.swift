//
//  ProviderResult.swift
//  Ondemand
//
//  Created by Songwut Maneefun on 5/17/17.
//  Copyright © 2017 Conicle.Co.,Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

class ProviderResult: ContentResult {
    var itemCount = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        itemCount      <- map["item_count"]
    }
}

class ProviderFilterResult: BaseResult {
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}
