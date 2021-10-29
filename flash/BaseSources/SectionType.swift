//
//  SectionType.swift
//  flash
//
//  Created by Songwut Maneefun on 26/10/2564 BE.
//

import Foundation
import UIKit

enum SectionType: String {
    
    //home
    case none = ""
    case forYou = "progress_account"
    case forYouV2 = "progress_account_content_type"
    case banner = "banner" // previous version -> case banner = "highlight"
    case highlight = "highlight"
    case newsUpdate = "news_update"
    case course = "course"
    case courseConicleX = "course_coniclex"
    case onboard = "onboard"
    case event = "event"//"class"
    case eventProgram = "event_program"
    case survey = "survey"
    case learningPath = "learning_path"
    case slp = "schedule_learning_path"
    case program = "program"
    case instructor = "instructor"
    case test = "exam"//"test"
    case activity = "activity"
    case publicLearning = "public_learning"
    case publicLearningSource = "public_learning_source"//"public_learning_partner"
    case contentProgram = "content_program"
    
    case provider = "provider" // is learning Center
    case new = "new"
    case live = "live"
    case learningMaterial = "learning_content"
    case continueLearning = "continue_learning"
    
    //explore
    case calendar = "calendar"
    case contentCount = "content"
    case explore = "classification"//"explore"
    case category = "category"
    case publicRequest = "publicRequest"
    case learningProgram = "learning_program"
    case customMenu = "custom_menu"
    
    func contentColor() -> UIColor {
        switch self {
        case .event:
            return eventColor
        case .eventProgram:
            return eventColor
        case .course:
            return courseColor
        case .survey:
            return surveyColor
        case .test:
            return testColor
        case .learningPath:
            return learningPathColor
        case .onboard:
            return onboardColor
        case .activity:
            return activityColor
        case .publicLearning:
            return publicLearningColor
        default:
            return programColor
        }
    }
    
    func contentIcon() -> UIImage? {
        var imgName = ""
        switch self {
        case .course:
            imgName = "ic_v2_course"
        case .courseConicleX:
            imgName = "ic_v2_coniclex"
        case .event:
            imgName = "ic_v2_class"
        case .learningPath:
            imgName = "ic_v2_learning_path"
        case .test:
            imgName = "ic_v2_test"
        case .survey:
            imgName = "ic_v2_survey"
        case .onboard:
            imgName = "ic_v2_onboard"
        case .publicLearning:
            imgName = "ic_v2_public_learning"
        case .activity:
            imgName = "ic_v2_activity"
        case .learningProgram:
            imgName = "icLearningProgram"
        case .live:
            imgName = "ic_v2_live"
        case .learningMaterial:
            imgName = "ic_v2_material"
        default:
            imgName = "ic_v2_course"
        }
        return UIImage(named: imgName)
    }
    
    func contentCountText(count: Int, isConicleX:Bool) -> String {
        if isConicleX, self == .course {
            return count.textNumber(many: "course_coniclex_unit").lowercased()
        } else {
            return self.contentCountText(count: count).lowercased()
        }
    }
    
    func contentCountText(count: Int, isConicleX:Bool, tagType:String?) -> String {
        if isConicleX, self == .course {
            return count.textNumber(many: "course_coniclex_unit").lowercased()
        } else {
            if let text = tagType {
                return count.textNumber(many: "\(text)_unit").lowercased()
            } else {
                return self.contentCountText(count: count).lowercased()
            }
        }
    }
    
    func contentCountText(count: Int) -> String {
        switch self {
        case .eventProgram :
            return count.textNumber(many: "class_program_unit")
        case .course:
            return count.textNumber(many: "course_unit")
        case .event:
            return count.textNumber(many: "class_unit")
        case .survey:
            return count.textNumber(many: "survey_unit")
        case .test:
            return count.textNumber(many: "test_unit")
        case .learningPath:
            return count.textNumber(many: "learning_path_unit")
        case .activity:
            return count.textNumber(many: "activity_unit")
        case .publicLearning:
            return count.textNumber(many: "public_learning_unit")
        case .live:
            return count.textNumber(many: "live_unit")
        case .learningMaterial:
            return count.textNumber(many: "learning_material_unit")
        default:
            return count.textNumber(many: "content_unit")
        }
    }
    
    func noContentText() -> String {
        switch self {
        case .course:
            return "No course"
        case .event:
            return "No class"
        case .program:
            return "No program"
        case .instructor:
            return "No instructor"
        case .category:
            return "No category"
        case .provider:
            return "No learning center"
        default:
            return "No content"
        }
        
    }
    
    func unitText() -> String {
        switch self {
        case .course:
            return "course(s)"
        case .event:
            return "class(s)"
        case .program:
            return "program(s)"
        case .instructor:
            return "instructor(s)"
        case .category:
            return "category(s)"
        case .provider:
            return "provider(s)"
        default:
            return "content(s)"
        }
    }
    
    func sectionMenus() -> [String] {
        switch self {
        case .course:
            return [String]()
        case .event:
            return ["Class", "Live", "Event"]
        default:
            return [String]()
        }
    }
    
    func backgroundImage() -> UIImage? {
        var imgName = ""
        switch self {
        case .category:
            imgName = "bg-category"
        case .instructor:
            imgName = "bg-instructor"
        case .provider:
            imgName = "bg-provider"
        case .program:
            imgName = "bg-program"
        default:
            imgName = ""
        }
        return UIImage(named: imgName)
    }
}
