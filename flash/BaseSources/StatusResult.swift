//
//  StatusResult.swift
//  flash
//
//  Created by Songwut Maneefun on 3/11/2564 BE.
//

import ObjectMapper

class StatusResult: BaseResult {
    var status:ProgressStatus = ProgressStatus.notStart
    var statusLabel = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status             <- map["status"]
        statusLabel        <- map["status_label"]
    }
}
