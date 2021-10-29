//
//  ContentResult.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import Foundation
import ObjectMapper

class ContentResult: BaseResult {
    
    //var typeVideo: TypeVideo = .video
    //var videoType: TypeVideo = .video
    //var slpType:SLPType = SLPType.online
    var typeLearningPath = 0
    //var status = 1
    var linkShare = ""
    var datetimeEnd = "" //2017-10-30T08:00:00+07:00"
    var datetimeStart = "" //2018-01-31T06:00:00+07:00"
    var code = ContentCode.none
    var newCode = ""
    //var contentTypeCode = ContentCode.none
    var isDependency = false
    var isMessenger = false // course, event, leanringPath
    var contentCount = 0
    //var enrollCondition: EnrollConditionResult?
    //var categoryContentType: ContentTypeResult?
    var contentSource = ""
    var contentLevel: BaseResult?
    var price = 0.0
    var discountPrice = 0.0
    //var competencyList = [CompetencyObject]()
    var durationExpired = 0
    var datetimeExpired: String?
    var label = ""
    var enrollmentRequired = true
    
    
    func updateType() {
        //self.slpType = typeLearningPath == 0 ? .online : .schedule
    }
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        //videoType               <- map["video_type"]
        //typeVideo               <- map["type"]
        newCode                 <- map["code"]
        datetimeExpired         <- map["datetime_expire"]
        durationExpired         <- map["duration_expire"]
        //competencyList          <- map["competency_list"]
        typeLearningPath        <- map["type_learning_path"]
        id                      <- map["id"]
        name                    <- map["name"]
        image                   <- map["image"]
        imageURL                <- (map["image"], URLTransform())
        linkShare               <- map["link_share"]
        datetimeEnd             <- map["datetime_end"]
        datetimeStart           <- map["datetime_start"]
        isDependency            <- map["is_dependency"]
        isMessenger             <- map["is_messenger"]
        //contentTypeCode         <- map["content_type.code"]
        //contentTypeCode         <- map["content_type"]
        //code                    <- map["code"]
        contentCount            <- map["count"]
        //enrollCondition         <- map["enroll_condition"]
        //categoryContentType     <- map["content_type"]
        contentSource           <- map["source"]
        contentLevel            <- map["content_level"]
        price                   <- map["price"]
        discountPrice           <- map["discount_price"]
        label                   <- map["label"]
        enrollmentRequired      <- map["enrollment_required"]
        
        self.updateType()
    }
    
}
