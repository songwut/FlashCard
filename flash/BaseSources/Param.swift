//
//  Param.swift
//  flash
//
//  Created by Songwut Maneefun on 2/3/2565 BE.
//

import Foundation

class OnboardParam {
    var onboardId: Int?
    var sectionId: Int?
    var slotId: Int?//create path at request file
    
    init(onboardId: Int?, sectionId: Int?) {
        self.onboardId = onboardId
        self.sectionId = sectionId
    }
    
    func pathAPI() -> String? {
        var str: String = ""
        if let onboardId = self.onboardId {
            str = "onboard/" + "\(onboardId)/"
        }
        if let seltionId = self.sectionId {
            str = str + "section/\(seltionId)/"
        }
        return str
    }
}

class APIParam {
    weak var crossVC:UIViewController?
    //weak var learningPath: LearningPathResult?
    var sectionId:Int?
    //var section: SectionSLPResult?
    var eventProgramId:Int?
    
    var slpId = 0
    var slpType:SLPType?
    var slotId: Int?
    
//    init(learningPath: LearningPathResult, section: SectionSLPResult?) {
//        self.learningPath = learningPath
//        self.slpId = learningPath.id
//        self.slpType = learningPath.slpType
//        self.section = section
//        if let s = section {
//            self.sectionId = s.id
//        }
//        
//    }
    
    init(slpId:Int, slpType: SLPType, sectionId: Int?) {
        self.slpId = slpId
        self.slpType = slpType
        self.sectionId = sectionId
    }
    
    func learningPathAPI() -> String? {
        var str = "learning-path/"
        if let slpType = self.slpType {
            if let scheduleApi = slpType.scheduleApi() { //content in SLP
                str = str + "\(scheduleApi)/"
            }
            str = str + "\(self.slpId)/"
            
            if let seltionId = self.sectionId {
                str = str + "section/\(seltionId)/"
            }
            return str
        } else {
            return nil
        }
    }
}



enum SLPTypeInt: Int {
    case all = -1
    case online = 0
    case schedule = 1
    
    func type() -> SLPType {
        var str = SLPType.online.rawValue
        
        if self == .schedule {
            str = SLPType.schedule.rawValue
            
        }
        return SLPType(rawValue: str) ?? SLPType.online
    }
    
    func scheduleApi() -> String? {
        if self == .schedule {
            return "schedule"
        } else {
            return nil
        }
    }
}

enum SLPType: String {//use home, home.title
    case schedule = "schedule_learning_path"
    case online = "learning_path"
    //case all = "learning_path"
    //case online = 0
    //case schedule = 1
    
    func scheduleApi() -> String? {
        if self == .schedule {
            return "schedule"
        } else {
            return nil
        }
    }
}



class Parent {
    var id:Int?
    var slotId: Int?
    var sectionId:Int?
    var code: ContentCode = .course
    var name = "course"
    
    init(id: Int, sectionId: Int?) {
        self.id = id
        self.sectionId = sectionId
    }
    
    func apiParam(_ title:String) -> String {
        var str = ""
        self.name = (title == "course") ? "course" : "class"
        self.code = (title == "course") ? .course : .event
        if let id = self.id {
            str = str + "\(title)/\(id)/"
        }
        if let slotId = self.slotId {
            str = str + "slot/\(slotId)/"
        }
        if let sectionId = self.sectionId {
            str = str + "section/\(sectionId)/"
        }
        return str
    }
    
    func apiParamArticle(_ title:String) -> String {
        var str = ""
        if let id = self.id {
            str = str + "\(title)/\(id)/"
        }
       
        if let sectionId = self.sectionId {
            str = str + "section/\(sectionId)/"
        }
        return str
    }
    
    func apiParamPdf(_ title:String) -> String {
        var str = ""
        self.name = (title == "course") ? "course" : "class"
        self.code = (title == "course") ? .course : .event
        if let id = self.id {
            str = str + "\(title)/\(id)/"
        }
        return str
    }
}
