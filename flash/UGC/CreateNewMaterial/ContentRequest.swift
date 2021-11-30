//
//  ContentRequest.swift
//  flash
//
//  Created by Songwut Maneefun on 29/11/2564 BE.
//

import ObjectMapper

class ContentRequest: BaseResult {
    var status: RequestStatus = .none
    var datetimeCreate = ""
    var code = ""
    var datetimeUpdate = ""
    var statusLabel = ""
    var progress: ProgressResult?
    var typeRule = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status          <- map["status"]
        code            <- map["code"]
        progress        <- map["progress"]
        typeRule        <- map["type_rule"]
        statusLabel     <- map["status_label"]
    }
}
