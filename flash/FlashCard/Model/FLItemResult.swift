//
//  FLItemResult.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation
import ObjectMapper

enum FLStatus: Int {
    case publish = 0
    case unpublish = 1
    
    func title() -> String {
        switch self {
        case .publish:
            return "publish".localized()
        case .unpublish:
            return "Unpublish".localized()
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .publish:
            return .config_primary()
        case .unpublish:
            return .error()
        }
    }
}

enum FLRequestStatus: String {
    case none = "none"
    case completed = "completed"
    case waitForApprove = "waiting_for_approve"
    case reject = "Reject"
    case requestExpired = "request_expired"
    
    func title() -> String {
        return self.rawValue.localized()
    }
    
    func color() -> UIColor {
        switch self {
        case .completed:
            return .success()
        case .waitForApprove:
            return .warning()
        case .reject:
            return .error()
        case .requestExpired:
            return .text()
        default:
            return UIColor.white
        }
    }
    
    func bgColor() -> UIColor {
        if self == .completed {
            return self.color().withAlphaComponent(0.1)
        } else {
            return self.color().withAlphaComponent(0.25)
        }
    }
}

class FLDetailResult: MaterialFlashResult {
    var countView = 0
    var provider: BaseResult?
    var category: CategoryResult?
    var instructor: BaseResult?
    var tagList = [UGCTagResult]()
    
    var estimateTime: Int?//only min
    
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
        contentCode          <- map["content_type.code"]
        countView            <- map["count_view"]
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

class MaterialFlashResult: BaseResult, Identifiable {
    let uuid = UUID()
    var progress: Any?
    var status: FLStatus = .unpublish
    var owner: OwnerResult?
    var code: String?
    var datetimePublish: String?
    var contentCode: ContentCode = .flash
    var datetimeUpdate = ""
    var datetimeCreate = ""
    var requestStatus: FLRequestStatus = .none
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        code                 <- map["code"]
        contentCode          <- map["content_type.code"]
        progress             <- map["progress"]
        owner                <- map["created_by"]
        datetimePublish      <- map["datetime_publish"]
        datetimeUpdate       <- map["datetime_update"]
    }
    
    class func with(_ dict: [String : Any]) -> MaterialFlashResult? {
        let item = Mapper<MaterialFlashResult>().map(JSON: dict)
        return item
    }
}

class OwnerResult: BaseResult {
    
}


class FLFlashDetailResult: FLBaseResult {
    var bgColor = "FFFFFF"
    var list = [FLCardPageResult]()
    var total = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        total         <- map["total"]
        list          <- map["results"]
    }
    
    class func with(_ dict: [String : Any]) -> FLFlashDetailResult? {
        let item = Mapper<FLFlashDetailResult>().map(JSON: dict)
        return item
    }
}

class FLCardPageResult: FLBaseResult {
    var order = 0
    var sort:Int? //not order in api
    var dropboxPage: FLDropboxPageResult?
    var stage: FLStageView?//ref for delete
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        sort               <- map["sort"]
        image              <- map["image"]
    }
    
    class func with(_ dict: [String : Any]) -> FLCardPageResult? {
        let item = Mapper<FLCardPageResult>().map(JSON: dict)
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
    var imageBase64: String?
    var imageData: Data?
    
    var file: String?
    var cardId: Int = 0
    var uuid: String = ""
    var filename: String = ""
    var size: Int = 0
    
    var deviceVideoUrl: URL?
    var mp4VideoUrl: URL?

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

class FLCardPageDetailResult: FLCardPageResult {
    var bgColor = FLColorResult(JSON: ["hex" : "ffffff"])!
    var componentList = [FlashElement]()
    
    var coverImageBase64: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        bgColor              <- map["data.bg_color"]
        componentList        <- map["data.component"]
    }
    
    override class func with(_ dict: [String : Any]) -> FLCardPageDetailResult? {
        let item = Mapper<FLCardPageDetailResult>().map(JSON: dict)
        return item
    }
}

class FLNewResult: FLCardPageResult {
    var total = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        total        <- map["total"]
    }
}
/*
class FLItemResult: FLBaseItemResult {
    var pageList = [FLCardPageResult]()
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
}*/

class FLBaseItemResult: FLBaseResult {
    
    var sort = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        sort        <- map["sort"]
    }
}

class FLBaseResult:Mappable, Equatable, Identifiable {
    static func == (lhs: FLBaseResult, rhs: FLBaseResult) -> Bool {
        return lhs.id == rhs.id
    }

    var id = 0
    var name = ""
    var title = ""
    var desc = ""
    var image = ""
    var imageURL: URL?
    
    var index = 0//selected in grid
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id        <- map["id"]
        title     <- map["title"]
        name      <- map["name"]
        desc      <- map["desc"]
        image     <- map["image"]
        imageURL  <- (map["image"], URLTransform())
        index     <- map["index"]
    }
}

class MaterialFlashPageResult: BaseResult {
    var previous: Int?
    var next: Int?
    var nextUrl: String?
    var count = 0
    var pageSize = 24
    var list = [MaterialFlashResult]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nextUrl          <- map["next_url"]
        next             <- map["next"]
        previous         <- map["previous"]
        count            <- map["count"]
        pageSize         <- map["page_size"]
        list             <- map["results"]
        
    }
    
    class func with(_ dict: [String : Any]) -> MaterialFlashPageResult? {
        let item = Mapper<MaterialFlashPageResult>().map(JSON: dict)
        return item
    }
}

class UserAnswerPageResult: BaseResult {
    var previous: Int?
    var next: Int?
    var count = 0
    var pageSize = 24
    var choiceList = [FLChoiceResult]()
    var userAnswerList = [FLAnswerResult]()

    override func mapping(map: Map) {
        super.mapping(map: map)
        self.next         <- map["next"]
        self.previous     <- map["previous"]
        self.count        <- map["count"]
        self.pageSize     <- map["page_size"]
        choiceList        <- map["choice"]
        userAnswerList    <- map["results"]
    }
}
