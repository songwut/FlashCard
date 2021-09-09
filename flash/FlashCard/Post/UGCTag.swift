//
//  UGCTag.swift
//  flash
//
//  Created by Songwut Maneefun on 7/9/2564 BE.
//

import ObjectMapper

class UGCTagPageResult: BaseResult {
    var list = [UGCTagResult]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
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
