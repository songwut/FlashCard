//
//  CategoryResult.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import Foundation
import ObjectMapper

class CategoryResult: BaseResult, Identifiable {
   
    var count = 0
    var new: Int?
    var sort = 0
    var childList = [UGCCategory]()
    var isAll = false
    var subList = [CategoryResult]()
    var allCategory: CategoryResult?
    var isChecked: Bool = false
    
    func reset() {
        for caregory in self.childList {
            caregory.isChecked = false
        }
    }
    
    class func createAll(category:CategoryResult?) -> CategoryResult {
        var id = 0
        var name = "all_category".localized()
        if let c = category {
            id = c.id
            name = c.name
        }
        
        return CategoryResult.with(["id": id, "name": name, "is_all": true])!
    }
    
    func manageSubList() {
        self.subList.removeAll()
        if self.childList.count >= 1 {
            self.subList.append(CategoryResult.createAll(category: self))
            for item in self.childList {
                self.subList.append(item)
            }
            
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        count           <- map["count"]
        new             <- map["new"]
        childList       <- map["child_list"]
        isAll           <- map["is_all"]
        self.manageSubList()
    }
    
    class func with(_ dict: [String : Any]) -> CategoryResult? {
        let item = Mapper<CategoryResult>().map(JSON: dict)
        return item
    }
}
