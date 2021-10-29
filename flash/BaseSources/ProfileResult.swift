//
//  ProfileResult.swift
//  flash
//
//  Created by Songwut Maneefun on 5/8/2564 BE.
//

import Foundation
import ObjectMapper

class ProfileResult: Mappable {
    var image = ""
    var desc = ""
    var title = ""
    var firstName = ""
    var middleName = ""
    var lastName = ""
    var id = 0
    var idCard = ""
    var gender = 0
    var email = ""
    var dateBirth = ""
    var age = ""
    var identifier = NSNumber(value: 0)
    var isResetPassword = NSNumber(value: 0)
    var position = ""
    var organization = ""
    var employeeId:String = ""
    var userId = ""
    var licenceId = ""
    var isSuperuser = false
    var isActive = true
    var isAcceptedActiveConsent: Bool?
    var department = ""
    var levelGroup = ""
    var levelName = ""
    var address = ""
    var supervisor = ""
    var countExperience = ""
    
    var lastActive = ""
    var dateJoined = ""
    var dateStart = ""
    var language = ""
    
    var username = ""
    var password = ""
    var phone: String = ""
    
    lazy var name: String = { [unowned self] in
        if self.middleName.count > 0 {
            return "\(self.firstName) \(self.middleName) \(self.lastName)"
        }
        return "\(self.firstName) \(self.lastName)"
        }()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        username                    <- map["username"]
        password                    <- map["password"]
        id                          <- map["id"]
        idCard                      <- map["id_card"]
        desc                        <- map["desc"]
        image                       <- map["image"]
        title                       <- map["title"]
        firstName                   <- map["first_name"]
        middleName                  <- map["middle_name"]
        lastName                    <- map["last_name"]
        gender                      <- map["gender"]
        email                       <- map["email"]
        dateBirth                   <- map["date_birth"]
        age                         <- map["age"]
        identifier                  <- map["id"]
        language                    <- map["language"]
        isResetPassword             <- map["is_reset_password"]
        position                    <- map["position"]
        organization                <- map["organization"]
        employeeId                  <- map["employee_id"]
        userId                      <- map["code"]
        licenceId                   <- map["code2"]
        isSuperuser                 <- map["is_superuser"]
        isActive                    <- map["is_active"]
        isAcceptedActiveConsent     <- map["is_accepted_active_consent"]
        department                  <- map["department"]
        lastActive                  <- map["last_active"]
        dateStart                   <- map["date_start"]
        dateJoined                  <- map["date_joined"]
        levelGroup                  <- map["level_group"]
        levelName                   <- map["level_name"]
        address                     <- map["address"]
        supervisor                  <- map["supervisor"]
        phone                       <- map["phone"]
    }
    
    class func with(_ dict: [String : Any]) -> ProfileResult? {
        let item = Mapper<ProfileResult>().map(JSON: dict)
        return item
    }
}
