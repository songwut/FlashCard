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

//UGC change FLDetailResult -> UGCDetailResult
class UGCDetailResult: FLDetailResult {
    var imageVideoList = [UGCCoverResult]()
    var defaultImage = ""
    var fileSize = 0
    var uploadStatus: UploadChunkStatus = .none
    
    func fileSizeDisplay() -> String {
        let mb = Units(bytes:Int64(self.fileSize)).megabytes
        let mbStr = String(format:"%.2f", mb)
        
        let fileText = "file_size".localized()
        return fileText + " \(mbStr)" + "MB."
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        uploadStatus         <- map["upload_status"]
        fileSize             <- map["file_size"]
        imageVideoList       <- map["image_video_list"]
        defaultImage         <- map["default_image"]
    }
}

class FLDetailResult: LMMaterialResult {
    var countView = 0
    var instructor: InstructorResult?
    var provider: ProviderResult?
    var category: CategoryResult?
    var instructorList = [InstructorResult]()
    var tagList = [UGCTagResult]()
    var estimateTime = 0
    var duration = 0
    
    private func countEstimateTime() {
        self.estimateTime = duration.minsFromSec
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        contentCode          <- map["content_type.code"]
        countView            <- map["count_view"]
        code                 <- map["code"]
        progress             <- map["progress"]
        duration             <- map["duration"]
        owner                <- map["created_by"]
        datetimePublish      <- map["datetime_publish"]
        category             <- map["category"]
        provider             <- map["provider"]
        instructor           <- map["instructor"]
        instructorList       <- map["instructor_list"]
        tagList              <- map["tag_list"]
        
        self.countEstimateTime()
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

class LMMaterialResult: BaseResult, Identifiable, GridItem {
    
    var nameContent = ""
    var uuid: UUID = UUID()
    var progress: ProgressResult?
    var displayStatus: FLStatus = .unpublish
    var owner: OwnerResult?
    var code: String?
    var datetimePublish: String?
    var contentCode: ContentCode = .flashcard
    var datetimeUpdate = ""
    var datetimeCreate = ""
    var contentRequest: ContentRequest?
    var requestStatus: RequestStatus = .none
    var datetimeAgo = ""
    var url: String?
    
    var hexBgColor: String?
    
    func isShowPreview() -> Bool {
        switch self.contentCode {
        case .flashcard:
            return true
        case .video, .audio, .pdf:
            return self.url != nil
        default:
            return true
        }
    }
    
    func editedDatetime() -> String {
        let dateText = formatter.with(dateFormat: "d MMM yyyy, HH:mm", dateString: self.datetimeUpdate)
        return "edited".localized() + ":" + dateText
    }
    
    func isHiddenEdit() -> Bool {
        if self.requestStatus == .approved
            || self.requestStatus == .inprogress
            || self.requestStatus == .notStart {
            return true
        } else {
            return false
        }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        url                  <- map["url"]
        nameContent          <- map["name_content"]
        code                 <- map["code"]
        displayStatus        <- map["is_display"]
        contentCode          <- map["content_type.code"]
        progress             <- map["content_request.progress"]
        owner                <- map["created_by"]
        contentRequest       <- map["content_request"]
        requestStatus        <- map["content_request.status"]
        datetimePublish      <- map["datetime_publish"]
        datetimeUpdate       <- map["datetime_update"]
        
        datetimeAgo = datetimeUpdate.dateTimeAgo()
    }
    
}
