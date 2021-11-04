//
//  ContentPeriodResult.swift
//  flash
//
//  Created by Songwut Maneefun on 3/11/2564 BE.
//

import ObjectMapper

enum PeriodType:Int {
    case noExpiry = 0
    case schedule = 1
    case duration = 2
    
}

class ContentPeriodResult: BaseResult {
    
    var datetimeActive = ""
    var datetimeStart = ""
    var datetimeEnd = ""
    var typeExpire = PeriodType.noExpiry
    var typeExpireLabel = ""
    var duration = 0 //sec
    var isActive = false
    
//    lazy var timeText: String = {
//        if self.datetimeStart == "" , self.datetimeEnd == "" {
//            return unlimitText
//        } else {
//            return Utility.textCompareDate(start: self.datetimeStart, end: self.datetimeEnd)
//        }
//    }()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id                    <- map["id"]
        datetimeStart         <- map["datetime_start"]
        datetimeEnd           <- map["datetime_end"]
        typeExpireLabel       <- map["type_expire_label"]
        duration              <- map["duration"]
        isActive              <- map["is_active"]
        //typeExpire            <- map["type_expire"]
        
        datetimeActive        <- map["datetime_active"]
    }
}
