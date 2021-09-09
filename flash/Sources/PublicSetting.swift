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
