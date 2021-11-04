//
//  ProgressResult.swift
//  AISADMISSION
//
//  Created by Songwut Maneefun on 9/27/2559 BE.
//  Copyright © 2559 Build The Dot. All rights reserved.
//

import UIKit
import ObjectMapper

@objc class ProgressResult: NSObject, Mappable {
    
    func countComplete() -> Int {
        return self.countCheckIn + self.countSubmitSurveyRequired + self.countPassExamRequired
    }
    
    func countTotalRequiedProgress() -> Int {
        return self.countMandatoryCheckIn + self.countSubmitSurveyRequired + self.countAdditionalNoti + self.countSubmitExamRequired + self.countMaterialTodo
    }
    
    var id = 0
    var isActionLog = false
    var percent:Float = 0
    var score = 0
    var contentCount = 0
    var contentComplete = 0
    var countMaterial = 0
    var countMaterialComplete = 0
    var countAttempt = 0
    var countSubmit = 0
    var countMaxSubmit = 0
    var countChecklist = 0
    var countChecklistComplete = 0
    var countStepComplete = 0
    var countStepReject = 0
    var countStepExpire = 0
    var countStep = 0
    var countAdditionalNoti = 0
    var countMaterialTodo = 0
    var countSubmitSurveyRequired = 0
    var countSubmitExamRequired = 0
    var countPassExamRequired = 0
    var countSurveyRequired = 0
    var countTotalProgress = 0
    var countCompleted = 0
    var sectionCount = 0
    var sectionComplete = 0
    var materialCount = 0
    var materialComplete = 0
    var status:ProgressStatus = ProgressStatus.notStart
    var statusDisplay = ""
    var statusLabel = ""
    var timeSpending = ""
    var countCheckIn = 0
    var countMandatoryCheckIn = 0
    var duration = 0
    var durationResume = 0
    var isPass = false
    var fullScore = ""
    var userScore = ""
    var passScore = ""
    var isExpired = false
    var note = ""
    var progressCheckIn: ProgressCheckIn?
    var checkIn: StatusResult?
    var varifyByAdmin: StatusResult?
    var attachFile: StatusResult?
    var progressStepList = [ProgressStepList]()
    var type = 0
    var contentRequestId = 0
    var notifySurvey = 0
    var currentPage = 0
    var datetimeCreate = ""
    var isOverride = false
    
    //TODO: remove
    var statusInt: NSNumber?
    var statusNumber: NSNumber = 0
    var isCompleted: Bool = false
    var timeupdate: String = ""
    var progressStatus: NSNumber = 0.0
    var expiredDisplay = ""
    var resultLabel = ""
    var conditionStatusLabel = ""
    var conditionStatus:ProgressStatus = ProgressStatus.notStart
    var resultStatus:ProgressStatus = ProgressStatus.notStart
    var isAllowTest = false
    var datetimeComplete = ""
    var durationMax: Int = 0
    
    func resultScoreText() -> String {
        return "\(self.userScore) / \(self.fullScore)"
    }
    
    func getTestStatusColor() -> UIColor {
        switch self.resultStatus {
        case .verifying:
            return progressVerifyColor
        case .failed:
            return UIColor(hex: "#e53935")
        default:
            return UIColor(hex: "#7cb342")
        }
    }
    
    func getProgressChecklist() -> Float {
        if self.countChecklist == 0 , self.countChecklistComplete == 0 {
            return 0.0
        } else {
            return self.percent
        }
    }
    
    func getProgressMaterial() -> Float {
        return Float(self.getPrecentMaterial()) / 100
    }
    
    func getPrecentMaterial() -> Int {
        if self.countMaterial == 0 , self.countMaterialComplete == 0 {
            return 0
        } else {//progress.percent.roundInt
            return self.percent.roundInt
            //return Float(self.countMaterialComplete / self.countMaterial).roundInt // if 0 / 0 will error
        }
    }
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        id                          <- map["id"]
        notifySurvey                <- map["count_unsubmitted_survey_required"]
        datetimeComplete            <- map["datetime_complete"]
        isAllowTest                 <- map["is_allow_test"]
        passScore                   <- map["pass_score"]
        fullScore                   <- map["full_score"]
        userScore                   <- map["user_score"]
        percent                     <- map["percent"]
        materialComplete            <- map["material_complete"]
        materialCount               <- map["material_count"]
        contentComplete             <- map["content_complete"]
        contentCount                <- map["content_count"]
        sectionCount                <- map["section_count"]
        sectionComplete             <- map["section_complete"]
        status                      <- map["status"]
        statusDisplay               <- map["status_display"]
        timeSpending                <- map["time_spending"]
        statusLabel                 <- map["status_label"]
        isPass                      <- map["is_pass"]
        isExpired                   <- map["is_expired"]
        note                        <- map["note"]
        progressCheckIn             <- map["progress_check_in"]
        type                        <- map["type"]
        contentRequestId            <- map["content_request"]
        datetimeComplete            <- map["datetime_complete"]
        isAllowTest                 <- map["is_allow_test"]
        passScore                   <- map["pass_score"]
        fullScore                   <- map["full_score"]
        userScore                   <- map["user_score"]
        percent                     <- map["percent"]
        materialComplete            <- map["material_complete"]
        materialCount               <- map["material_count"]
        contentComplete             <- map["content_complete"]
        contentCount                <- map["content_count"]
        sectionCount                <- map["section_count"]
        sectionComplete             <- map["section_complete"]
        status                      <- map["status"]
        statusDisplay               <- map["status_display"]
        timeSpending                <- map["time_spending"]
        statusLabel                 <- map["status_label"]
        isPass                      <- map["is_pass"]
        isExpired                   <- map["is_expired"]
        note                        <- map["note"]
        progressCheckIn             <- map["progress_check_in"]
        
        statusNumber                <- map["status"]
        isCompleted                 <- map["is_complete"]
        timeupdate                  <- map["timeupdate"]
        score                       <- map["score"]
        progressStatus              <- map["progress_status"]
        
        duration                    <- map["duration"]
        durationResume              <- map["duration_resume"]
        expiredDisplay              <- map["expired_display"]
        
        countCheckIn                <- map["user_check_in"]
        countMandatoryCheckIn       <- map["count_check_in"]
        countMaterial               <- map["count_material"]
        countMaterialComplete       <- map["count_material_complete"]
        countAttempt                <- map["count_attempt"]
        countMaxSubmit              <- map["max_submit"]
        countChecklist              <- map["count_checklist"]
        countChecklistComplete      <- map["count_checklist_complete"]
        countStepComplete           <- map["count_step_complete"]
        countStepReject             <- map["count_step_reject"]
        countStepExpire             <- map["count_step_expire"]
        countStep                   <- map["count_step"]
        countAdditionalNoti         <- map["count_unsubmit_survey_required"]
        countMaterialTodo           <- map["count_material_todo"]
        countSubmitSurveyRequired   <- map["count_submit_survey_required"]
        countSubmitExamRequired     <- map["count_submit_exam_required"]
        countPassExamRequired       <- map["count_pass_exam_required"]
        
        countSurveyRequired         <- map["count_survey_required"]
        countTotalProgress          <- map["count_material"]
        countCompleted              <- map["count_material_complete"]
        
        resultLabel                 <- map["result_label"]
        resultStatus                <- map["result_status"]
        conditionStatusLabel        <- map["condition_status_label"]
        conditionStatus             <- map["condition_status"]
        countSubmit                 <- map["count_submit"]
        
        checkIn                     <- map["checkin"]
        varifyByAdmin               <- map["verified_by_admin"]
        attachFile                  <- map["attach_file"]
        progressStepList            <- map["progress_step_list"]
        checkIn                     <- map["checkin"]
        varifyByAdmin               <- map["verified_by_admin"]
        currentPage                 <- map["current_page"]
        durationMax                 <- map["duration_max"]
        datetimeCreate              <- map["datetime_create"]
        isOverride                  <- map["is_override"]
        isActionLog                 <- map["has_action_log"]
    }
    
    @objc class func objectWithDict(_ dict: [String : Any]) -> ProgressResult? {
        let item = Mapper<ProgressResult>().map(JSON: dict)
        return item
    }
    //getTestButtonText
    @objc func getStatusTextTestColor() -> UIColor {
        return self.status.textColor()
    }
    
    @objc func getStatusTextColor() -> UIColor {
        return self.status.statusColor()
    }
    
    @objc func getStatusBackgroundColor() -> UIColor {
        return self.status.backgroundColor()
    }
    
    @objc func getStatus() -> Int {
        return self.status.rawValue
    }
}

class ProgressCheckIn: BaseResult {
    var status: ProgressStatus = ProgressStatus.notStart
    var statusLabel = ""
    var datetimeSubmit = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        status              <- map["status"]
        statusLabel         <- map["status_label"]
        datetimeSubmit      <- map["datetime_submit"]
        
    }
}

@objc public enum ProgressStatus: Int {
    case notStart = 0
    case waitingApprove = 1
    case waitingList = 2
    case waitingForm = 3
    case waitingApproveFlow = 5
    
    case inprogress = 21
    case verifying = 22
    case reSubmit = 6 // qa sanbox, sanbox = 4
    
    case completed = 30
    case contentRequestExpired = -6
    case failed = -5
    case contentCancel = -4
    case rejected = -3
    case expired = -2
    case cancel = -1
    case surveyRequired = 23
    
    func isTakeAction() -> Bool {
        var isAction: Bool!
        switch self {
        case .waitingApprove: isAction = true
        case .waitingList: isAction = false
        case .waitingForm: isAction = false
        case .inprogress: isAction = false
        case .verifying: isAction = false
        case .completed: isAction = true
        case .failed: isAction = false
        case .contentCancel: isAction = false
        case .rejected: isAction = false
        case .expired: isAction = false
        case .cancel: isAction = false
        case .surveyRequired: isAction = true
        default: isAction = false
        }
        
        assert(isAction != nil)
        return isAction
    }
    
    func statusColor() -> UIColor {
        var color: UIColor!
        switch self {
        case .waitingApprove: color = progressWaitingApproveColor
        case .waitingApproveFlow: color = progressWaitingApproveColor
        case .waitingList: color = progressWaitingListColor
        case .waitingForm: color = progressWaitingFormColor
        case .inprogress: color = progressInprogressColor
        case .verifying: color = progressVerifyColor
        case .completed: color = progressCompleteColor
        case .failed: color = progressFailColor
        case .contentCancel: color = progressCancelColor
        case .rejected: color = progressRejectColor
        case .expired: color = progressExpireColor
        case .cancel: color = progressCancelColor
        case .notStart: color = progressNotstartColor
        case .reSubmit: color = progressReSubmitColor
        case .surveyRequired: color = progressWaitingListColor
        case .contentRequestExpired: color = progressExpireColor
        default: color = UIColor.black
        }
        
        assert(color != nil)
        return color
    }
    
    func textColor() -> UIColor {
        var color: UIColor!
        switch self {
        case .waitingApprove: color = UIColor.white
        case .waitingApproveFlow: color = UIColor.white
        case .waitingList: color = UIColor.white
        case .waitingForm: color = UIColor.white
        case .inprogress: color = UIColor.white
        case .verifying: color = UIColor.white
        case .completed: color = UIColor.white//targetConfig.themeColor
        case .failed: color = UIColor.white//ColorHelper.color(AISColor._Progress_Red)
        case .contentCancel: color = UIColor.white
        case .rejected: color = UIColor.white
        case .expired: color = UIColor.white
        case .contentRequestExpired: color = UIColor.white
        case .cancel: color = UIColor.white
        default: color = UIColor.white
        }
        
        assert(color != nil)
        return color
    }
    
    func textPurchaseButtonColor() -> UIColor {
        var color: UIColor!
        switch self {
        case .waitingApprove: color = UIColor.white
        case .waitingList: color = UIColor.white
        case .waitingForm: color = UIColor.white
        case .inprogress: color = UIColor.white
        case .verifying: color = UIColor.white
        case .completed: color = .green
        case .failed: color = .error()
        case .contentCancel: color = UIColor.white
        case .rejected: color = UIColor.white
        case .expired: color = UIColor.darkGray
        case .contentRequestExpired: color = UIColor.darkGray
        case .cancel: color = UIColor.white
        default: color = UIColor.white
        }
        
        assert(color != nil)
        return color
    }
    
    func borderWidth() -> CGFloat {
        var width: CGFloat!
        switch self {
        case .inprogress: width = 0.0
        case .completed: width = 1.0
        case .failed: width = 1.0
        case .expired: width = 1.0
        case .contentRequestExpired: width = 1.0
            default: width = 0.0
        }
        
        assert(width != nil)
        return width
    }
    
    func borderColor() -> UIColor {
        var color: UIColor!
        switch self {
        case .inprogress: color = UIColor.clear
        case .completed: color = .success()
        case .failed: color = .error()
        case .expired: color = UIColor.darkGray
        case .contentRequestExpired: color = UIColor.darkGray
            default: color = UIColor.clear
        }
        
        assert(color != nil)
        return color
    }
    
    func backgroundColor() -> UIColor {
        var color: UIColor!
        switch self {
        case .inprogress: color = progressInprogressColor
        case .completed: color = progressCompleteColor
        case .failed: color = progressFailColor
        case .expired: color = UIColor.darkGray
        case .contentRequestExpired: color = UIColor.darkGray
            default: color = UIColor.clear
        }
        
        assert(color != nil)
        return color
    }
    
    func backgroundPurchaseButtonColor() -> UIColor {
        var color: UIColor!
        switch self {
        case .inprogress: color = progressInprogressColor //unused
        case .completed: color = UIColor.clear //unused
        case .failed: color = UIColor.clear //unused
        case .expired: color = UIColor.clear //unused
        default: color = UIColor.clear
        }
        
        assert(color != nil)
        return color
    }
    
    func iconName() -> String {
        var text: String!
        switch self {
        case .inprogress: text = "IconCheckmark"
        case .failed: text = "iconCancel"
        case .expired: text = "IconLocked"
        default: text = "IconCheckmark"
        }
        
        assert(text != nil)
        return text
    }
    
    func text() -> String {
        var text: String!
        switch self {
        case .inprogress: text = "Start testing" //unused
        case .completed: text = "Completed" //unused
        case .failed: text = "Failed" //unused
        case .expired: text = "Expired"
        default: text = "Unknown"
        }
        
        assert(text != nil)
        return text
    }
    
    func stastusText() -> String {
        var text: String!
        switch self {
        case .inprogress: text = "In Progress"
        case .completed: text = "Completed"
        case .failed: text = "Failed"
        case .expired: text = "Expired"
        default: text = "Unknown"
        }
        
        assert(text != nil)
        return text
    }
}
