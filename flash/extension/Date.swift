//
//  Date.swift
//  connect
//
//  Created by Songwut Maneefun on 3/7/17.
//  Copyright © 2017 Conicle. All rights reserved.
//

import Foundation

let formatter = FormatterFormats()
let formatsManager = FormatterFormats()

let calendar = Calendar(identifier: .gregorian)
class Dates {
    static func printDatesBetween(_ startDate: Date, _ endDate: Date, calendar:Calendar) -> [Date] {
        var dates = [Date]()
        var startDate = startDate
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"//"yyyy-MM-dd"
        
        while startDate <= endDate {
            dates.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        return dates
    }
}

enum ServerDateTimeFormat:String {
    case type1 = "yyyy-MM-dd" //2018-08-09 // count 10
    case type2 = "yyyy-MM-dd'T'HH:mm:ssZZZ" //"2018-08-09T05:30:00+07:00" count 25
    case type3 = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"// "2018-08-07T14:59:26.086179+07:00" count 32
    case type4 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//2018-08-15T22:30:00Z// Android
    case type5 = "yyyy-MM-dd'T'HH:mm:ssZ" //2018-08-15T22:30:00Z ount 20
}

class FormatterFormats {
    
    lazy var serverDateTime: DateFormatter = {
        
        var dateTime: DateFormatter = DateFormatter()
        dateTime.calendar = Calendar(identifier: .gregorian)
        dateTime.locale = Locale(identifier: "th_TH")
        dateTime.timeZone = TimeZone(abbreviation: "GMT+7")
        return dateTime
    }()
    
    lazy var dateTime: DateFormatter = {
        var dateTime: DateFormatter = DateFormatter()
        dateTime.timeZone = NSTimeZone.local
        dateTime.locale = Locale.current
        dateTime.calendar = Calendar.current
        return dateTime
    }()
    
    
    class var sharedInstance:FormatterFormats {
        return formatter
    }
    
    func serverDateTime(_ dateString: String) -> Date? {
        //server to device : "GMT+7" -> "UTC"
        //server datetime format multi type need to check
        let type1 = "yyyy-MM-dd" //2018-08-09 // count 10
        let type2 = "yyyy-MM-dd'T'HH:mm:ssZZZ" //"2018-08-09T05:30:00+07:00" count 25
        let type3 = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"// "2018-08-07T14:59:26.086179+07:00" count 32
        let type4 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//2018-08-15T22:30:00Z// Android
        let type5 = "yyyy-MM-dd'T'HH:mm:ssZ" //2018-08-15T22:30:00Z ount 20
        var format = ""
        
        switch dateString.count {
        case 10:
            format = ServerDateTimeFormat.type1.rawValue
        case 20:
            format = ServerDateTimeFormat.type5.rawValue
        case 24:
            format = ServerDateTimeFormat.type4.rawValue
        case 25:
            format = ServerDateTimeFormat.type2.rawValue
        default:
            format = ServerDateTimeFormat.type3.rawValue
        }
        serverDateTime.dateFormat = format
        return serverDateTime.date(from: dateString)
    }
    
    func fromDateTime(dateString: String) -> Date? {
        dateTime.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateTime.date(from: dateString)
    }
    
    func with(dateFormat: String, date: Date, dateStyle:DateFormatter.Style? = nil, calendar:Calendar? = nil) -> String {
        if let style = dateStyle {
            dateTime.dateStyle = style
        } else {
            dateTime.dateFormat = dateFormat
        }
        dateTime.locale = Locale(identifier: Localized.shared.language)
        dateTime.calendar = calendar as Calendar? ?? Calendar.current
        
        //dateTime.calendar = mainCalendar
        return dateTime.string(from: date)
    }
    
    func withDatetimeUpdate(dateFormat: String = "yyyy-MM-dd HH:mm:ss", dateString: String) -> String {
        dateTime.timeZone = NSTimeZone.local
        dateTime.locale = Locale(identifier: Localized.currentLanguage())//identifier by app setting
        dateTime.calendar = mainCalendar
        dateTime.dateFormat = dateFormat
        if let date = dateString.dateFromISO8601 {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = ServerDateTimeFormat.type4.rawValue
            return dateTime.string(from: date)
        }
        return dateString
    }
    
    func with(dateFormat: String = "yyyy-MM-dd HH:mm:ss", dateString: String) -> String {
        /*
        dateTime.dateFormat = dateFormat
        dateTime.timeZone = mainCalendar.timeZone
        if let date = getDate(dateString: dateString) {
            dateTime.dateFormat = dateFormat
            return dateTime.string(from: date)
        }
        */
        /*
        if let date = dateString.dateFromISO8601 {
        //if let date = getDate(dateString: dateString) {
            dateTime.calendar = mainCalendar
            //dateTime.timeZone = mainCalendar.timeZone
            dateTime.dateFormat = dateFormat
            return dateTime.string(from: date)
        }
        
        */
        
        dateTime.timeZone = NSTimeZone.local
        dateTime.locale = Locale(identifier: Localized.currentLanguage())//identifier by app setting
        dateTime.calendar = mainCalendar
        dateTime.dateFormat = dateFormat
        //convert to local device
        if let date = dateString.dateFromISO8601 {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = ServerDateTimeFormat.type4.rawValue
            if let convertedDate = dateFormatterGet.date(from: dateString) { //for request form feild dateList
                // valid format
                let addedHours = convertedDate.addingTimeInterval((60 * 60) * 7)
                return dateTime.string(from: addedHours)
            }
            return dateTime.string(from: date)
        }
        return dateString
    }
    
    func date(format: String = "d MMM yyyy", dateString: String) -> Date? {
        
        if let date = dateString.dateFromISO8601 {
            return date
        }
        return nil
    }
    
    func dateWith(dateFormat: String = "yyyy-MM-dd HH:mm:ss", dateString: String) -> Date? {

        if let date = dateString.dateFromISO8601 {
            return date
        }
        return nil
    }
    
    func with(style: DateFormatter.Style = .medium, isoDateString: String) -> String {
        
        if let date = isoDateString.dateFromISO8601 {
            dateTime.dateStyle = style
            return dateTime.string(from: date)
        }
        return isoDateString
    }
    
    func timeAgowith(_ dateString: String) -> String {
        if let date = dateString.dateFromISO8601 {
            return date.timeAgoSinceNow()
        }
        return dateString
    }
    
    
    
    init() {
        //dateTime.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //let gregorianCalendar = Calendar(identifier: .gregorian)
        //dateTime.calendar = gregorianCalendar
        //dateTime.timeZone = TimeZone(identifier: "UTC")
        
        let gregorianCalendar = Calendar(identifier: .gregorian)
        dateTime.calendar = gregorianCalendar
        dateTime.timeZone = gregorianCalendar.timeZone //TimeZone(identifier: "BE")
    }
    
}

struct DateComponentUnitFormatter {
    
    private struct DateComponentUnitFormat {
        let unit: Calendar.Component
        
        let singularUnit: String
        let pluralUnit: String
        
        let futureSingular: String
        let pastSingular: String
    }
    
    private let formats: [DateComponentUnitFormat] = [
        
//        DateComponentUnitFormat(unit: .year,
//                                singularUnit: "year",
//                                pluralUnit: "years",
//                                futureSingular: "Next year",
//                                pastSingular: "Last year"),
//
//        DateComponentUnitFormat(unit: .month,
//                                singularUnit: "month",
//                                pluralUnit: "months",
//                                futureSingular: "Next month",
//                                pastSingular: "Last month"),
//
//        DateComponentUnitFormat(unit: .weekOfYear,
//                                singularUnit: "week",
//                                pluralUnit: "weeks",
//                                futureSingular: "Next week",
//                                pastSingular: "Last week"),
 
        DateComponentUnitFormat(unit: .day,
                                singularUnit: "day",
                                pluralUnit: "days",
                                futureSingular: "Tomorrow",
                                pastSingular: "Yesterday"),
        
        DateComponentUnitFormat(unit: .hour,
                                singularUnit: "hour",
                                pluralUnit: "hours",
                                futureSingular: "In an hour",
                                pastSingular: "An hour ago"),
        
        DateComponentUnitFormat(unit: .minute,
                                singularUnit: "minute",
                                pluralUnit: "minutes",
                                futureSingular: "In a minute",
                                pastSingular: "A minute ago"),
        
        DateComponentUnitFormat(unit: .second,
                                singularUnit: "second",
                                pluralUnit: "seconds",
                                futureSingular: "Just now",
                                pastSingular: "Just now")
        
        ]
    
    func string(forDateComponents dateComponents: DateComponents, useNumericDates: Bool) -> String {
        for format in self.formats {
            let unitValue: Int
            
            switch format.unit {
//            case .year:
//                unitValue = dateComponents.year ?? 0
//            case .month:
//                unitValue = dateComponents.month ?? 0
//            case .weekOfYear:
//                unitValue = dateComponents.weekOfYear ?? 0
            case .day:
                unitValue = dateComponents.day ?? 0
            case .hour:
                unitValue = dateComponents.hour ?? 0
            case .minute:
                unitValue = dateComponents.minute ?? 0
            case .second:
                unitValue = dateComponents.second ?? 0
            default:
                assertionFailure("Date does not have requried components")
                return ""
            }
            
//            return "\(unitValue) \(format.pluralUnit) ago"
            
            switch unitValue {
            case 2 ..< Int.max:
                return "\(unitValue) \(format.pluralUnit) ago"
            case 1:
                return useNumericDates ? "\(unitValue) \(format.singularUnit) ago" : format.pastSingular
            case -1:
                return useNumericDates ? "In \(-unitValue) \(format.singularUnit)" : format.futureSingular
            case Int.min ..< -1:
                return "In \(-unitValue) \(format.pluralUnit)"
            default:
                break
            }
            
        }
        
        return "Just now"
    }
}
let formatStr = "dd-MM-yyyy HH:mm:ss"

extension Date {
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    var hour0x: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh"
        return dateFormatter.string(from: self)
    }
    
    var minute0x: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
    
    
    func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatStr
        dateFormatter.calendar = mainCalendar
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale(identifier: Localized.currentLanguage())
        return dateFormatter
    }
    
    func timeAgoSinceNow(useNumericDates: Bool = false) -> String {
        let calendar = mainCalendar
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        let formatter = DateComponentUnitFormatter()
        return formatter.string(forDateComponents: components, useNumericDates: useNumericDates)
    }
    
    func isSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    func isSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    var isWeek: Bool {
        return isSameWeek(date: Date())
    }
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    var isTheFuture: Bool {
        return Date() < self
    }
    
    var isPast: Bool {
        return Date() > self
    }
    
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    func getTimeAgoSinceNow(dateText:String, numericDates:Bool = false) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        var timeAgoText = "just_now".localized()
        
        if let second = components.second {
            if (second >= 20) {
                timeAgoText = second.textNumber(many: "sec_ago_unit".localized())
            }
        }
        
        if let minute = components.minute, minute > 0  {
            timeAgoText = minute.textNumber(many: "min_ago_unit".localized())
        }
        
        if let hour = components.hour, hour > 0 {
            timeAgoText = hour.textNumber(many: "hr_ago_unit".localized())
        }
        
        if let day = components.day, day > 0 {
            if (day >= 7) {
                timeAgoText = dateText
            } else {
                timeAgoText = day.textNumber(many: "day_ago_unit".localized())
            }
        }
        
        return timeAgoText
    }
    
    private func stringToReturn(flag:Bool, strings: (String, String)) -> String {
        if (flag){
            return strings.0
        } else {
            return strings.1
        }
    }
    
    
}
