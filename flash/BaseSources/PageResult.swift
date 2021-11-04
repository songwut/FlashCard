//
//  PageResult.swift
//  LEGO
//
//  Created by Songwut Maneefun on 9/8/17.
//  Copyright © 2017 Conicle. All rights reserved.
//

import Foundation
import ObjectMapper

class PageConfig: BaseResult {
    
    var datetimeUpdate = ""
    var type = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        datetimeUpdate <- map["datetime_update"]
        type           <- map["type"]
    }
}

class PageResult: BaseResult {
    
    var contentList = [ContentResult]()
    var config: PageConfig?
    var previous = ""
    var next: Int?
    var filters = [FilterSectionObj]()
    //var filterList = [FilterResult]()
    var pageSize = 0
    var count = 0
    
    var mlTypeList = [FilterItemResult]()
    var slpTypeList = [FilterItemResult]()
    
    var dictListForTag = [[String: Any]]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        mlTypeList       <- map["content_type_results"]
        slpTypeList      <- map["learning_type_results"]
        config           <- map["config"]
        previous         <- map["previous"]
        next             <- map["next"]
        //filterList       <- map["filter_list"]
        filters          <- map["filter_list"]
        pageSize         <- map["page_size"]
        count            <- map["count"]
        
        dictListForTag        <- map["results"]
    }
    
     func manageObjects() {
        var objs = [ContentResult]()
        for dict in self.dictListForTag {
            
            guard let contentTypeObj = dict["content_type"] as? [String: Any],
               let code = contentTypeObj["code"] as? String else {
                continue
            }
            /*
            let contentCode = ContentCode(rawValue: code)
            
            switch contentCode {
            case .course:
                objs.append(CourseResult(JSON: dict)!)
            case .event:
                objs.append(EventResult(JSON: dict)!)
            case .eventProgram:
                objs.append(EventProgramResult(JSON: dict)!)
            case .learningPath:
                objs.append(LearningPathResult(JSON: dict)!)
            case .activity:
                objs.append(ActivityResult(JSON: dict)!)
            case .live:
                objs.append(LiveDetailResult(JSON: dict)!)
            case .video:
                objs.append(LearningMaterialResult(JSON: dict)!)
            case .audio:
                objs.append(LearningMaterialResult(JSON: dict)!)
            case .pdf:
                objs.append(LearningMaterialResult(JSON: dict)!)
            case .article:
                objs.append(LearningMaterialResult(JSON: dict)!)
            default:
                continue
            }
            */
        
        }
        ConsoleLog.show("getObjects",objs.count)
        contentList = objs
    }
}
