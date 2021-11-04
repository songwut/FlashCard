//
//  LearningMaterialResult.swift
//  LEGO
//
//  Created by Chisanapong Intasae on 15/10/2563 BE.
//  Copyright © 2563 conicle. All rights reserved.
//

import Foundation
import ObjectMapper

class LearningMaterialResult: ContentResult, Identifiable {
    var requestStatus: RequestStatus = .none
    var owner: OwnerResult?
    var status: FLStatus = .publish
    
    var results = [LearningMaterialDetailResult]()
    var datetimeCreate = ""
    var datetimeUpdate = ""
    var datetimePublish = ""
    var total = 0
    var url = ""
    var nameContent = ""
    var webContent = ""
    var uuid: String?
    var description = ""
    var duration = 0
    var countView = 0
    var category: CategoryResult?
    var provider: ProviderResult?
    var transaction: TransactionResult?
    var contentTypeId = 0
    var capacity = 0
    var countTransaction = 0
    var isAllowDownload = true
    
    // TODO : Change to [BaseResult]
    
    var tagList = [BaseResult]()  // extra
    var instructorList: [InstructorResult]?
    var contentPeriodDoing: ContentPeriodResult?
    
    func isYoutube() -> Bool {
        return false
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        requestStatus           <- map["request_status"]
        countTransaction        <- map["count_transaction"]
        webContent              <- map["content"]
        capacity                <- map["capacity"]
        nameContent             <- map["name_content"]
        datetimeCreate          <- map["datetime_create"]
        datetimeUpdate          <- map["datetime_update"]
        datetimePublish         <- map["datetime_publish"]
        total                   <- map["total"]
        url                     <- map["url"]
        uuid                    <- map["uuid"]
        description             <- map["desc"]
        duration                <- map["duration"]
        countView               <- map["count_view"]
        category                <- map["category"]
        provider                <- map["provider"]
        transaction             <- map["transaction"]
        instructorList          <- map["instructor_list"]
        tagList                 <- map["tag_list"]
        contentTypeId           <- map["content_type.id"]
        isAllowDownload         <- map["is_allow_download"]
    }
}

class LearningMaterialDetailResult: LearningMaterialResult {
    
    var progress: ProgressResult?
    var isDiscussion = false
    var isEnrolled: Bool {
        if let _ = self.progress {
            return true
        } else {
            return false
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        isDiscussion            <- map["is_discussion"]
        progress          <- map["transaction.progress"]
        
    }
}


class LearningMaterialTagList: BaseResult {
    
    var code = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        code             <- map["code"]
        
    }
}


class LearningMaterialPageResult: PageResult {
    
    var list = [LearningMaterialResult]()
    var relatedList = [ContentResult]()
    var tagRalateList = [LearningMaterialTagList]()
//var contentTypeList = [SearchFilterResult]()
    //var filterTypeList = [FilterItemResult]()

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        list             <- map["results"]
        tagRalateList    <- map["tag_relate_list"]
        //contentTypeList  <- map["content_type_results"]
        //filterTypeList   <- map["filter_content_type"]
        relatedList      <- map["results"]
        
        manageObjects()

    }
}

class LearningMaterialEnrollResult: LearningMaterialResult {
    
    var isAllowStart = true
    var form = ""
    var waitingNo = 0
    var taskId = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        isAllowStart                 <- map["is_allow_start"]
        form                         <- map["form"]
        waitingNo                    <- map["waiting_no"]
        taskId                       <- map["task_id"]
    }
}


class LMMaterialResult: BaseResult, Identifiable {
    let uuid = UUID()
    var progress: Any?
    var status: FLStatus = .unpublish
    var owner: OwnerResult?
    var code: String?
    var datetimePublish: String?
    var contentCode: ContentCode = .flash
    var datetimeUpdate = ""
    var datetimeCreate = ""
    var requestStatus: RequestStatus = .none
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        code                 <- map["code"]
        contentCode          <- map["content_type.code"]
        progress             <- map["progress"]
        owner                <- map["created_by"]
        datetimePublish      <- map["datetime_publish"]
        datetimeUpdate       <- map["datetime_update"]
    }
    
}
