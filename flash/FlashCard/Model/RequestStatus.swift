//
//  RequestStatus.swift
//  flash
//
//  Created by Songwut Maneefun on 1/11/2564 BE.
//

import Foundation


enum RequestStatus: Int {
    case none = 999
    case completed = 30
    case waitForApprove = 1
    case reject = -3
    case requestExpired = -2
    
//    case none = "none"
//    case completed = "completed"
//    case waitForApprove = "waiting_for_approve"
//    case reject = "Reject"
//    case requestExpired = "request_expired"
    
    
    func title() -> String {
        switch self {
        case .completed:
            return "completed".localized()
        case .waitForApprove:
            return "waiting_for_approve".localized()
        case .reject:
            return "reject".localized()
        case .requestExpired:
            return "request_expired".localized()
        default:
            return ""
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .completed:
            return .success()
        case .waitForApprove:
            return .warning()
        case .reject:
            return .error()
        case .requestExpired:
            return .text()
        default:
            return UIColor.white
        }
    }
    
    func bgColor() -> UIColor {
        if self == .completed {
            return self.color().withAlphaComponent(0.1)
        } else {
            return self.color().withAlphaComponent(0.25)
        }
    }
    
    func desc() -> String {
        switch self {
        case .completed:
            return "Cannot edit because of this material has already approved"
        case .waitForApprove:
            return "Cannot edit because of this material is waiting for approve, if you want to edit press button Cancel Request"
        case .reject:
            return "last request status is rejected, if you want to request to publish again you can press Submit to Approve button again"
        case .requestExpired:
            return "last request status is Request Expired, if you want to request to publish again you can press Submit to Approve button again"
        default:
            return ""
        }
    }
}
