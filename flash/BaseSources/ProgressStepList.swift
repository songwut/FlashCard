//
//  ProgressStepList.swift
//  flash
//
//  Created by Songwut Maneefun on 3/11/2564 BE.
//

import ObjectMapper

class ProgressStepList: BaseResult {
    var step = 0
    var accountApprove: AccountResult?
    var countApprover = 0
    var isAuto = false
    var isApprovable = false
    var status = ProgressStatus.notStart
    var statusLabel = ""
    var message = ""
    var datetimeStart = ""
    var datetimeEnd = ""
    var datetimeComplete = ""
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        step                    <- map["step"]
        accountApprove          <- map["account_approve"]
        countApprover           <- map["count_approver"]
        isAuto                  <- map["is_auto"]
        isApprovable            <- map["is_approvable"]
        status                  <- map["status"]
        statusLabel             <- map["status_label"]
        message                 <- map["message"]
        datetimeStart           <- map["datetime_start"]
        datetimeEnd             <- map["datetime_end"]
        datetimeComplete        <- map["datetime_complete"]
        
    }
}
