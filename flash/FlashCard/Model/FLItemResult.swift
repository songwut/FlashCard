//
//  FLItemResult.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation
import ObjectMapper

enum FLStatus: Int {
    case publish = 1
    case unpublish = 0
    
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

class FLDetailResult: LMMaterialResult {
    var countView = 0
    var provider: ProviderResult?
    var category: CategoryResult?
    var instructorList = [InstructorResult]()
    var tagList = [UGCTagResult]()
    var estimateTime = 5 //default
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        contentCode          <- map["content_type.code"]
        countView            <- map["count_view"]
        code                 <- map["code"]
        progress             <- map["progress"]
        estimateTime         <- map["duration"]
        owner                <- map["created_by"]
        datetimePublish      <- map["datetime_publish"]
        category             <- map["category"]
        provider             <- map["provider"]
        instructorList       <- map["instructor_list"]
        tagList              <- map["tag_list"]
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
    var stage: FlashStageView?//ref for delete
    
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

class LMMaterialPageResult: MaterialFlashPageResult {
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
    }
}

class MaterialFlashPageResult: BaseResult {
    var previous: Int?
    var next: Int?
    var nextUrl: String?
    var count = 0
    var pageSize = 24
    var list = [LMMaterialResult]()
    
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


class UGCTagPageResult: BaseResult {
    var list = [UGCTagResult]()
    var next: Int?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        next  <- map["next"]
        list  <- map["results"]
    }
    
    class func with(_ dict: [String : Any]) -> UGCTagPageResult? {
        let item = Mapper<UGCTagPageResult>().map(JSON: dict)
        return item
    }
}

class UGCTagResult: BaseResult {
    var isSelected: Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
    
    class func with(_ dict: [String : Any]) -> UGCTagResult? {
        let item = Mapper<UGCTagResult>().map(JSON: dict)
        return item
    }
}


class LMMaterialResult: BaseResult, Identifiable {
    var nameContent = ""
    let uuid = UUID()
    var progress: ProgressResult?
    var displayStatus: FLStatus = .unpublish
    var owner: OwnerResult?
    var code: String?
    var datetimePublish: String?
    var contentCode: ContentCode = .flash
    var datetimeUpdate = ""
    var datetimeCreate = ""
    var contentRequest: ContentRequest?
    var requestStatus: RequestStatus = .none
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nameContent          <- map["name_content"]
        code                 <- map["code"]
        displayStatus        <- map["is_display"]
        contentCode          <- map["content_type.code"]
        progress             <- map["progress"]
        owner                <- map["created_by"]
        contentRequest       <- map["content_request"]
        requestStatus        <- map["content_request.status"]
        datetimePublish      <- map["datetime_publish"]
        datetimeUpdate       <- map["datetime_update"]
    }
    
}
