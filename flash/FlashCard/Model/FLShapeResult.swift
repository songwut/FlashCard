//
//  FLShapeResult.swift
//  flash
//
//  Created by Songwut Maneefun on 5/8/2564 BE.
//

import Foundation
import ObjectMapper

class FLShapePageResult: FLBaseResult {
    var prv: Int?
    var next: Int?
    var count = 0
    var pageSize = 0
    var total = 0
    var list = [FLGraphicResult]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        count        <- map["count"]
        pageSize     <- map["page_size"]
        total        <- map["total"]
        list         <- map["results"]
    }
}
