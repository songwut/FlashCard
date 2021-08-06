//
//  FLGraphicResult.swift
//  flash
//
//  Created by Songwut Maneefun on 6/8/2564 BE.
//

import Foundation
import ObjectMapper

class FLGraphicPageResult: FLBaseResult {
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

class FLGraphicResult: FLBaseResult {
    var code = ""
    var imageBase64: String?
    var uiimage:UIImage?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        code           <- map["code"]
        imageBase64    <- map["image"]
    }
}
