//
//  RequestStatus.swift
//  LEGO
//
//  Created by Songwut Maneefun on 1/11/2564 BE.
//  Copyright © 2564 BE conicle. All rights reserved.
//

import UIKit

enum RequestStatus: Int {
    case none = 999
    case approved = 30
    
    case expired = -2
    case requestExpired = -6
    
    case rejected = -3
    case canceledByUser = -1
    
    //waiting_for_approve
    case notStart = 0
    case inprogress = 21//inprogress
    case waitForApprove = 1
    
//    case none = "none"
//    case completed = "completed"
//    case waitForApprove = "waiting_for_approve"
//    case reject = "Reject"
//    case requestExpired = "request_expired"
    
//    from web compare next time
//    approveStatusCode: {
//        '-11': 'canceled_by_assignment',
//        '-6': 'request_expired',
//        '-3': 'rejected',
//        '-2': 'expired',
//        '-1': 'canceled_by_user',
//        '0': 'waiting_approve',
//        '1': 'waiting_approve',
//        '21': 'waiting_approve',
//        '30': 'approved'
//      }
    
    func title() -> String? {
        switch self {
        case .approved:
            return "approved".localized()
        case .notStart:
            return "progress_waiting_for_approve".localized()
        case .inprogress:
            return "progress_waiting_for_approve".localized()
        case .waitForApprove:
            return "progress_waiting_for_approve".localized()
        case .rejected:
            return "rejected".localized()
        case .expired:
            return "request_expired".localized()
        case .requestExpired:
            return "request_expired".localized()
        default:
            return nil
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .approved:
            return UIColor("17CC8D")
        case .notStart:
            return .warning()
        case .inprogress:
            return .warning()
        case .waitForApprove:
            return .warning()
        case .rejected:
            return .error()
        case .canceledByUser:
            return .error()
        case .requestExpired:
            return .text()
        default:
            return .black
        }
    }
    
    func bgColor() -> UIColor {
        if self == .approved {
            return self.color().withAlphaComponent(0.1)
        } else {
            return self.color().withAlphaComponent(0.25)
        }
    }
    
    func descDict() -> String {
        switch self {
        case .approved:
            return "request_approved_remark"
        case .notStart:
            return "request_waiting_remark"
        case .inprogress:
            return "request_waiting_remark"
        case .waitForApprove:
            return "request_waiting_remark"
        case .rejected:
            return "request_failed_remark"
        case .requestExpired:
            return "request_expired_remark"
        default:
            return ""
        }
    }
}
