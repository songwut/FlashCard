//
//  ContentCode.swift
//  flash
//
//  Created by Songwut Maneefun on 26/10/2564 BE.
//

import Foundation

enum TypeVideo: Int {
    case video = 1
    case youtube = 2
}

enum ContentCode: String {
    //https://gitlab.conicle.co/hrd/conicle/wikis/data-dictionary-content-type
    //4.0
    case none = ""
    case forYou = "for_you"
    case all = "all"
    case event = "event.event"
    case tagEvent = "tag_type=event" //for event.event that is tag_type=event
    case eventProgram = "event_program.eventprogram"
    case survey = "survey.survey"
    case newsupdate = "news_update.newsupdate"
    case eventSession = "event.session"
    
    case category = "category.category"
    case instructor = "instructor.instructor"
    case instructorAccount = "instructor.account"
    case provider = "provider.provider"
    
    //4.1
    case courseConicleX = "course.coniclex"
    case course = "course.course"
    case onboard = "onboard.onboard"
    case test = "exam.exam"
    case learningPath = "learning_path.learningpath"
    case program = "content_program.contentprogram"
    case about = "about"
    case activity = "activity.activity"
    case publicLearning = "public_learning.publiclearning"
    case publicLearningRequest = "public_learning.publicrequest"
    
    case publicRequest = "public_request.publicrequest"
    case contentRequest = "content_request.contentrequest"
    case dashboard = "dashboard"
    case learningHistory = "learning_history.learninghistory"
    
    case scheduleLearningPath = "learning_path.schedule"
    
    case live = "live.live"
    
    case video = "video.video"
    case audio = "audio.audio"
    case pdf = "material.pdf"
    case article = "material.article"
    case learningMaterial = "learning_content.learningcontent"
    case flash = "flashcard.flashcard"
    
    func path() -> String {
        if self == .video {
            return "video"
        } else if self == .audio {
            return "audio"
        } else {
            return "course"
        }
    }
    
    func getColor() -> UIColor? {
        var color: UIColor = .config_primary()
        switch self {
        case .event:
            color = eventColor
        case .eventProgram:
            color = eventColor
        case .course:
            color = courseColor
        case .instructorAccount:
            color = .config_primary()
        case .survey:
            color = surveyColor
        case .onboard:
            color = onboardColor
        case .test:
            color = testColor
        case .learningPath:
            color = learningPathColor
        case .scheduleLearningPath:
            color = learningPathColor
        case .activity:
            color = activityColor
        case .publicLearning:
            color = publicLearningColor
        case.contentRequest:
            color = publicRequestColor
        case.publicRequest:
            color = publicLearningColor//publicRequestColor
        case.live:
            color = liveColor
        case.video:
            color = videoColor
        case.audio:
            color = audioColor
        case.pdf:
            color = pdfColor
        case.article:
            color = articleColor
        case.flash:
            color = flashcardColor
        default:
            color = .gray
        }
        return color
    }
    
    func getDefaultImage() -> UIImage {
        if self == .event {
            return defaultCoverClass!
            
        } else if self == .course {
            return defaultCoverCourse!
            
        } else if self == .activity {
            return defaultCoverActivity!
            
        } else if self == .learningPath {
            return defaultCoverLearningPath!
            
        } else if self == .publicLearning {
            return defaultCoverPublicLearning!
            
        } else if self == .onboard {
            return defaultCoverOnboard!
            
        } else {
            return defaultImage!
        }
    }
    
    func getType() -> SectionType {
        if self == .event {
            return SectionType.event
            
        } else if self == .survey {
            return SectionType.survey
            
        }  else if self == .test {
            return SectionType.test
            
        }  else if self == .learningPath {
            return SectionType.learningPath
            
        } else {
            return SectionType.course
        }
    }
    func cellContentHeight() -> CGFloat {
        if self == .event {
            return EventDefault.contentHeight()
            
        } else if self == .survey {
            return SurveyDefault.contentHeight()
            
        } else if self == .test {
            return SurveyDefault.contentHeight()
            
        } else {
            return ContentRateDefault.contentHeight()
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
    
    func icon() -> UIImage? {
        var imgName = ""
        switch self {
        case .course:
            imgName = "ic_v2_course"
        case .event:
            imgName = "ic_v2_class"
        case .tagEvent:
            imgName = "ic_v2_event"
        case .eventProgram:
            imgName = "ic_v2_class_program"
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
        case .publicRequest:
            imgName = "ic_v2_public_request"
        case .activity:
            imgName = "ic_v2_activity"
        case .contentRequest:
            imgName = "ic-publicLearning"
        case .live:
            imgName = "ic_v2_live"
        case .all:
            imgName = "ic_v2_material"
        case .category:
            imgName = "ic_v2_category"
        case .provider:
            imgName = "ic_v2_content_provider"
        case .program:
            imgName = "ic_v2_learning_program"
        case .instructor:
            imgName = "ic_v2_instructor"
        case .video:
            imgName = "ic_v2_video2"//ic_v2_youtube with type 2
        case .audio:
            imgName = "ic_v2_audio2"
        case .learningMaterial:
            imgName = "ic_v2_material"
        case .article:
            imgName = "ic_v2_article"
        case .pdf:
            imgName = "ic_v2_pdf"
        default:
            imgName = "ic_v2_coniclex"
        }
        return UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
    }
    
    func name() -> String {
        switch self {
        case .test:
            return "test"
        case .course:
            return "course"
        case .learningPath:
            return "learning_path"
        case .onboard:
            return "onboard"
        case .event:
            return "event"
        case .eventProgram:
            return "event_program"
        case .survey:
            return "survey"
        case .publicLearning:
            return "public_learning"
        case .newsupdate:
            return "news_update"
        case .forYou:
            return "for_you"
        case .eventSession:
            return "session"
        case .activity:
            return "activity"
        case .all:
            return "content"
        case .category:
            return "category"
        case .provider:
            return "provider"
        case .program:
            return "content-program"
        case .instructor:
            return "instructor"
        case .live:
            return "live"
        case .video:
            return "video"
        case .audio:
            return "audio"
        case .pdf:
            return "doc"
        case .article:
            return "article"
        case .learningMaterial:
            return "learning_material"
        default:
            return "contents"
        }
    }
    
    func noContentText() -> String {
        switch self {
        case .course:
            return "No course"
        case .event:
            return "No class"
        case .onboard:
            return "No onboard"
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
    
    func contentCountText(count: Int) -> String {
        switch self {
        case .course:
            return count.textNumber(many: "courses")
        case .event:
            return count.textNumber(many: "events")
        case .survey:
            return count.textNumber(many: "surveys")
        case .live:
            return count.textNumber(many: "lives")
        case .test:
            return count.textNumber(many: "tests")
        case .activity:
            return count.textNumber(many: "activitys")
        case .scheduleLearningPath:
            return count.textNumber(many: "scheduleLearningPaths")
        case .learningPath:
            return count.textNumber(many: "learningPaths")
        case .eventProgram:
            return count.textNumber(many: "eventPrograms")
        case .onboard:
            return count.textNumber(many: "onboards")
        case .publicLearning:
            return count.textNumber(many: "publicLearnings")
        case .video:
            return count.textNumber(many: "videos")
        case .audio:
            return count.textNumber(many: "audios")
        case .learningMaterial:
            return count.textNumber(many: "learningMaterials")
        case .newsupdate:
            return count.textNumber(many: "newsupdates")
        case .all:
            return count.textNumber(many: "contents")
        default:
            return count.textNumber(many: "contents")
        }
    }
    
    func unitText() -> String {
        switch self {
        case .course:
            return "course(s)"
        case .event:
            return "class(s)"
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
}
