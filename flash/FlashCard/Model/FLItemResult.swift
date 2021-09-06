//
//  FLItemResult.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation
import ObjectMapper

class FLDetailResult: FLBaseResult {
    var progress: Any?
    var createdBy: [String: AnyObject]?
//    "datetime_create": "2021-08-04T09:55:45.443966",
//            "datetime_update": "2021-08-04T09:55:45.444002",
//            "is_display": 0,
//            "content_type": {
//                "id": 379,
//                "code": "flashcard.flashcard"
//            },
//            "created_by": {
//                "id": 20,
//                "image": "account/2019/05/1e6c9040-747.jpg",
//                "name": "Admin No7 Palida"
//            },
//            "tag_list": [],
//            "instructor_list": null,
//            "category": null,
//            "provider": null
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        progress             <- map["progress"]
        createdBy            <- map["created_by"]
    }
    
    class func with(_ dict: [String : Any]) -> FLDetailResult? {
        let item = Mapper<FLDetailResult>().map(JSON: dict)
        return item
    }
}

class FlCardResult: FLBaseResult {
    var bgColor = "FFFFFF"
    var list = [FlashPageResult]()
    var total = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        total         <- map["total"]
        list          <- map["results"]
    }
    
    class func with(_ dict: [String : Any]) -> FlCardResult? {
        let item = Mapper<FlCardResult>().map(JSON: dict)
        return item
    }
}

class FlashPageResult: FLBaseResult {
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        image              <- map["image"]
    }
    
    class func with(_ dict: [String : Any]) -> FlashPageResult? {
        let item = Mapper<FlashPageResult>().map(JSON: dict)
        return item
    }
}

class FLPageDetailResult: FlashPageResult {
    var bgColor = "FFFFFF"
    var componentList = [FlashElement]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        bgColor              <- map["data.bg_color"]
        componentList        <- map["data.component"]
    }
    
    override class func with(_ dict: [String : Any]) -> FLPageDetailResult? {
        let item = Mapper<FLPageDetailResult>().map(JSON: dict)
        return item
    }
}

class FLNewResult: FLBaseItemResult {
    var total = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        total        <- map["total"]
    }
}

class FLItemResult: FLBaseItemResult {
    var pageList = [FlashPageResult]()
    var dictPageList = [[String : AnyObject]]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        sort         <- map["sort"]
        pageList     <- map["pageList"]
        dictPageList <- map["pageList"]//for copy
    }
    
    class func with(_ dict: [String : Any]) -> FLItemResult? {
        let item = Mapper<FLItemResult>().map(JSON: dict)
        return item
    }
}

class FLListResult: FLBaseResult {
    var total = 0
    var list = [FLItemResult]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        total        <- map["total"]
        list         <- map["results"]
    }
}

class FLBaseItemResult: FLBaseResult {
    
    var sort = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        sort        <- map["sort"]
    }
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



