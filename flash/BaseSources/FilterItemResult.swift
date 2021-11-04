//
//  FilterItemResult.swift
//  flash
//
//  Created by Songwut Maneefun on 3/11/2564 BE.
//

import ObjectMapper

@objc class FilterSectionObj: NSObject, Mappable {
    var param: String?
    var name: String?
    var list: [FilterObj]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        param      <- map["param"]
        name      <- map["name"]
        list    <- map["list"]
    }
    
    @objc class func objectWithDict(_ dict: [String: Any]) -> FilterSectionObj? {
        let item = Mapper<FilterSectionObj>().map(JSON: dict)
        return item
    }
}

@objc class FilterObj: NSObject, Mappable {
    var name: String?
    var value: AnyObject?
    var param = ""
    var isSelected = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name      <- map["name"]
        value     <- map["value"]
    }
    
    @objc class func objectWithDict(_ dict: [String: Any]) -> FilterObj? {
        let item = Mapper<FilterObj>().map(JSON: dict)
        return item
    }
}

class FilterItemResult: BaseResult {
    var tag = 0
    var code = ContentCode.none
    var sort = 0
    var count = 0
    var typeVideo: TypeVideo? //1 video.video ,2 external_video
    var typeSlp = 0 //0 online ,1 schedule
    func slpName() -> String {
        if self.typeSlp == 1 {
            return "schedule_learning_path"
        } else {
            return "online_learning_path"
        }
    }
    
    //local variables
    var collapsed = false
    var isSelected = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        typeSlp     <- map["type"]
        typeVideo   <- map["type"]
        code        <- map["code"]
        sort        <- map["sort"]
        count       <- map["count"]
    }
}
