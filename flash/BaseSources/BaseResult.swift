//
//  BaseResult.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import UIKit
import ObjectMapper

class BaseResult:Mappable {

    var id = 0
    var idString = ""
    var name = ""
    var title = ""
    var desc = ""
    var image = ""
    var imageURL: URL?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        idString  <- map["id"]
        id        <- map["id"]
        title     <- map["title"]
        name      <- map["name"]
        desc      <- map["desc"]
        image     <- map["image"]
        imageURL  <- (map["image"], URLTransform())
    }
}
