//
//  Formatter.swift
//  Ondemand
//
//  Created by Songwut Maneefun on 9/15/17.
//  Copyright © 2017 Conicle.Co.,Ltd. All rights reserved.
//

import Foundation

extension Date {
    
    func countMinute(with date: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.minute], from: date1, to: date2)
        
        return components.minute ?? 0
    }
    
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   == 1 { return "\(years(from: date)) year"   } else if years(from: date)   > 1 { return "\(years(from: date)) years"   }
        if months(from: date)  == 1 { return "\(months(from: date)) month"  } else if months(from: date)  > 1 { return "\(months(from: date)) month"  }
        if weeks(from: date)   == 1 { return "\(weeks(from: date)) week"   } else if weeks(from: date)   > 1 { return "\(weeks(from: date)) weeks"   }
        if days(from: date)    == 1 { return "\(days(from: date)) day"    } else if days(from: date)    > 1 { return "\(days(from: date)) days"    }
        if hours(from: date)   == 1 { return "\(hours(from: date)) hour"   } else if hours(from: date)   > 1 { return "\(hours(from: date)) hours"   }
        if minutes(from: date) == 1 { return "\(minutes(from: date)) minute" } else if minutes(from: date) > 1 { return "\(minutes(from: date)) minutes" }
        return ""
    }
}

extension String {
    
    var dateFromISO8601: Date? {
        return formatsManager.serverDateTime(self)
        
        /*
        let conicleServer = Region(calendar: Calendars.gregorian, zone: Zones.asiaBangkok, locale: Locales.thaiThailand)
        //let dateInRegion =  DateInRegion.(self, region: conicleServer)
        if let dateInRegion =  DateInRegion(self, region: conicleServer) {
            ConsoleLog.show("dateFromISO8601: \(self) | timezone: \(dateInRegion.region.timeZone) | locale: \(dateInRegion.region.locale)")
            
            //serverCalendar = dateInRegion.region.calendar
            
            mainCalendar = Calendar.current//dateInRegion.region.calendar
            mainCalendar.timeZone = NSTimeZone.local
            formatter.dateTime.timeZone = NSTimeZone.local//dateInRegion.region.timeZone
            formatter.dateTime.locale = Locale.current//dateInRegion.region.locale // Locale(identifier: Localized.currentLanguage())//
            formatter.dateTime.calendar = Calendar.current//.region.calendar
            ConsoleLog.show("dateInRegion.absoluteDate: \(dateInRegion.date)")
            return dateInRegion.date
        } else {
            return nil
        }
        */
        //return Formatter.iso8601.date(from: self)// "Mar 22, 2017, 10:22 AM"
    }
}
