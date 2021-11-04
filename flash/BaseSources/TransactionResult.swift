//
//  TransactionResult.swift
//  LEGO
//
//  Created by Songwut Maneefun on 10/10/17.
//  Copyright © 2017 Conicle. All rights reserved.
//

import Foundation
import ObjectMapper

enum MethodLabel: String {
    case none = ""
    case enrolled = "enrolled"
    case assigned = "assigned"
    
    func color() -> UIColor {
        switch self {
        case .enrolled:
            return labelEnrollColor
        case .assigned:
            return labelAssignColor
        default : return UIColor.black
        }
    }
}

enum TransactionStatus: Int {
    case unknow = 999
    case contentRequestExpired = -6
    case rejected = -3
    case expired = -2
    case cancel = -1
    case success = 0
    case waitingApprove = 1
    case inWaitingList = 2
    case formSubmit = 3
    case formProcess = 4
    case waitingContentRequest = 5
    case completed = 30
}

class TransactionResult: Mappable {
    
    var label = ""
    var datetimeStart = ""
    var datetimeEnd = ""
    var datetimeUpdate = ""
    var dayLeft = ""
    var methodLabel: String?
    var status = TransactionStatus.unknow
    
    //var contentType: ContentTypeResult?
    var isExpired = false
    var progress: ProgressResult?
    var progressSnap:  ProgressResult?
    //var form: FormResult?
    var countMaterial = 0
    var countMaterialComplete = 0
    var isActionLog = false
    
    var isAcceptTerm: Bool?
    var isAllowStart = true
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        //form                    <- map["form"]
        label                   <- map["status_label"]
        datetimeStart           <- map["datetime_start"]
        datetimeEnd             <- map["datetime_end"]
        dayLeft                 <- map["day_left"]
        //contentType             <- map["content_type"]
        isExpired               <- map["is_expired"]
        progress                <- map["progress"]
        progressSnap            <- map["progress_snap"]
        status                  <- map["status"]
        methodLabel             <- map["method_label"]
        isAcceptTerm            <- map["is_accept_terms"]
        isAllowStart            <- map["is_allow_start"]
        countMaterial           <- map["count_material"]
        countMaterialComplete   <- map["count_material_complete"]
        isActionLog             <- map["has_action_log"]
        datetimeUpdate          <- map["datetime_update"]
    }
    
    func getMethodLabel() -> MethodLabel {
        let label = MethodLabel(rawValue: self.methodLabel!)
        return label ?? MethodLabel.none
    }
}
