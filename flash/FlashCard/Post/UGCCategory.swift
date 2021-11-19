//
//  UGCCategory.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import Foundation
import ObjectMapper

class UGCCategoryPageResult: BaseResult {
    var list = [UGCCategory]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        list  <- map["results"]
    }
    
    class func with(_ dict: [String : Any]) -> UGCCategoryPageResult? {
        let item = Mapper<UGCCategoryPageResult>().map(JSON: dict)
        return item
    }
}

class UGCCategory: CategoryResult {
    var isSelected: Bool = false
    var isExpaned: Bool = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.manageSubList()
    }
    
    override class func with(_ dict: [String : Any]) -> UGCCategory? {
        let item = Mapper<UGCCategory>().map(JSON: dict)
        return item
    }
}

struct UGCData {
    func categoryList() -> [UGCCategory] {
        var items = [UGCCategory]()
        items.append(UGCCategory(JSON: ["name" : "name1"])!)
        items.append(UGCCategory(JSON: ["name" : "name2"])!)
        items.append(UGCCategory(JSON: ["name" : "name3"])!)
        items.append(UGCCategory(JSON: ["name" : "name4"])!)
        items.append(UGCCategory(JSON: ["name" : "name5"])!)
        return items
    }
    
}
