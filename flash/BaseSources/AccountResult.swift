//
//  AccountResult.swift
//  Ondemand
//
//  Created by Songwut Maneefun on 7/27/17.
//  Copyright © 2017 Conicle.Co.,Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

class AccountResult: BaseResult {
    var firstName = ""
    var lastName = ""
    var email = ""
    var username = ""
    var codeText = ""
    
    var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        codeText           <- map["code"]//public request
        firstName          <- map["first_name"]
        lastName           <- map["last_name"]
        email              <- map["email"]
        username           <- map["username"]
    }
}
