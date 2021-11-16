//
//  PublicSetting.swift
//  flash
//
//  Created by Songwut Maneefun on 19/7/2564 BE.
//

import UIKit

let fontConicleText = "DBHeaventRounded"
let fontConicleMedium = "DBHeaventRounded-Med"
let fontConicleBold = "DBHeaventRounded-Bold"

let fontConicleTextIt = "DBHeaventRounded-Italic"
let fontConicleMediumIt = "DBHeaventRounded-MedIt"
let fontConicleBoldIt = "DBHeaventRounded-BoldIt"

var mainCalendar = Calendar.current

var isActiveDictKey = false
var defaultLanguageIndex = 0
var configLocale = ["en", "th"]
var configParagraphLineSpacing:[String: CGFloat] = ["en": 2.0,"th": 5.0]
var isLoginConicle = false


var pathDomain = "develop.conicle.co/"
var domainURL = "https://\(pathDomain)"
var apiURL = "\(domainURL)api/"
var isMaintenance = false

var tagBgDisableColor = UIColor("EBEBEB")
var tagBgEnableColor = UIColor("DFEBF5")
var tagTextEnableColor = UIColor("2196F3")
let defaultUserImage = UIImage(named: "ic_profile_gray")
let defaultImage = UIImage(named: "image-cover-preloading")

let defaultCoverActivity = UIImage(named: "Cover_Activity")
let defaultCoverCategory = UIImage(named: "Cover_Category")
let defaultCoverClass = UIImage(named: "Cover_Class")
let defaultCoverContentProvider = UIImage(named: "Cover_ContentProvider")
let defaultCoverCourse = UIImage(named: "Cover_Course")
let defaultCoverInstructor = UIImage(named: "Cover_Instructor")
let defaultCoverLearningPath = UIImage(named: "Cover_LearningPath")
let defaultCoverLearningProgram = UIImage(named: "Cover_LearningProgram")
let defaultCoverLocation = UIImage(named: "Cover_Location")
let defaultCoverOnboard = UIImage(named: "Cover_Onboard")
let defaultCoverPublicLearning = UIImage(named: "Cover_PublicLearning")
let defaultCoverLearningRoom = UIImage(named: "Cover_LearningRoom")
let defaultCoverFlash = UIImage(named: "flash-cover") ?? UIImage()
