//
//  ErrorType.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation

enum ErrorType: Int {
    case emailEmpty = 1001
    case invalidEmail = 1002
    case passwordEmpty = 1003
    case confirmPasswordEmpty = 1004
    case passwordMismatch = 1005
    // present string message for each error code
    func domain() -> String {
        switch self {
        case .emailEmpty: return "Please enter your email."
        case .invalidEmail: return "The email you entered does not in the correct format. Please recheck and try again."
        case .passwordEmpty: return "Please enter your password"
        case .confirmPasswordEmpty: return "Please enter your confirm password"
        case .passwordMismatch: return "Your password does not match the confirm password"
        }
        
    }
}
