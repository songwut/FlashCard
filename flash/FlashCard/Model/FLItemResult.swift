//
//  FLItemResult.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation
import ObjectMapper

class FLItemResult: FLBaseResult {
    
}

class FLPageResult: FLBaseResult {
    var list = [FLItemResult]()
}



class FLBaseResult:Mappable {

    var id = 0
    var name = ""
    var title = ""
    var desc = ""
    var image = ""
    var imageURL: URL?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id        <- map["id"]
        title     <- map["title"]
        name      <- map["name"]
        desc      <- map["desc"]
        image     <- map["image"]
        imageURL  <- (map["image"], URLTransform())
    }
}
