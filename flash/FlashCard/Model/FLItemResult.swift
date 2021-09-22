//
//  FLItemResult.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation
import ObjectMapper

enum FLStatus: Int {
    case unknow = 0
    case unpublish = 1
    case waitForApprove = 2
    case approved = 3
    
    func title() -> String {
        switch self {
        case .unpublish:
            return "Unpublish"
        case .waitForApprove:
            return "Wait For Approve"
        case .approved:
            return "Approve"
        default:
            return ""
        }
    }
    func color() -> UIColor {
        switch self {
        case .unpublish:
            return ColorHelper.primary()
        case .waitForApprove:
            return ColorHelper.warning()
        case .approved:
            return ColorHelper.success()
        default:
            return ColorHelper.primary()
        }
    }
}

class FLDetailResult: MaterialFlashResult {
    var estimateTime: Int?//only min
    //var contentCode: ContentCode?
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
        code                 <- map["code"]
        progress             <- map["progress"]
        owner                <- map["created_by"]
        datetimePublish      <- map["datetime_publish"]
    }
    
    override class func with(_ dict: [String : Any]) -> FLDetailResult? {
        let item = Mapper<FLDetailResult>().map(JSON: dict)
        return item
    }
}

class MaterialFlashResult: BaseResult {
    var progress: Any?
    var status: FLStatus = .unpublish
    var owner: OwnerResult?
    var code: String?
    var datetimePublish: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        code                 <- map["code"]
        progress             <- map["progress"]
        owner                <- map["created_by"]
        datetimePublish      <- map["datetime_publish"]
    }
    
    class func with(_ dict: [String : Any]) -> MaterialFlashResult? {
        let item = Mapper<MaterialFlashResult>().map(JSON: dict)
        return item
    }
}

class OwnerResult: BaseResult {
    
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
    
    var dropboxPage: FLDropboxPageResult?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        image              <- map["image"]
    }
    
    class func with(_ dict: [String : Any]) -> FlashPageResult? {
        let item = Mapper<FlashPageResult>().map(JSON: dict)
        return item
    }
}

class FLDropboxPageResult: FLBaseResult {
    
    var list = [FLMediaResult]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        list              <- map["results"]
    }
    
    class func with(_ dict: [String : Any]) -> FLDropboxPageResult? {
        let item = Mapper<FLDropboxPageResult>().map(JSON: dict)
        return item
    }
}

class FLMediaResult: FLBaseResult {
    var file: String?
    var imageBase64: String?
    var imageData: Data?
    var cardId: Int = 0
    var uuid: String = ""
    var filename: String = ""
    var size: Int = 0
    
    var deviceUrl: URL?

    override func mapping(map: Map) {
        super.mapping(map: map)
        imageBase64       <- map["image"]
        file              <- map["file"]
        cardId            <- map["card_id"]
        uuid              <- map["uuid"]
        filename          <- map["filename"]
        size              <- map["size"]
    }
}

class FLPageDetailResult: FlashPageResult {
    var bgColor = FLColorResult(JSON: ["hex" : "ffffff"])!
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

class MaterialFlashPageResult: BaseResult {
    var count = 0
    var list = [MaterialFlashResult]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        count            <- map["count"]
        list             <- map["results"]
    }
    
    class func with(_ dict: [String : Any]) -> MaterialFlashPageResult? {
        let item = Mapper<MaterialFlashPageResult>().map(JSON: dict)
        return item
    }
}


