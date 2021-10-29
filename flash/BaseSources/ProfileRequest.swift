//
//  ProfileRequest.swift
//  flash
//
//  Created by Songwut Maneefun on 5/8/2564 BE.
//

import Foundation

class ProfileRequest: APIRequest {
    var id: Int?
    
    override var url : String {
        if let id = self.id {
            return "\(apiURL)account/profile/\(id)/"
        }
        return "\(apiURL)account/profile/"
    }
}
