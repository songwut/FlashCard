//
//  Int.swift
//  flash
//
//  Created by Songwut Maneefun on 4/8/2564 BE.
//

import Foundation

extension Int {
    var seconds: Int {
        return self
    }
    
    var isEvenNumber: Bool {
        return Double(self % 2) == 0.0
    }
    
    var minutes: Int {
        return self.seconds * 60
    }
    
    var hours: Int {
        return self.minutes * 60
    }
    
    var days: Int {
        return self.hours * 24
    }
    
    var weeks: Int {
        return self.days * 7
    }
    
    var months: Int {
        return self.weeks * 4
    }
    
    var years: Int {
        return self.months * 12
    }
    
    var sec: Int {
        return Int((self % 3600) % 60)
    }
    var dayFromSec: Int {
        return Int(self / 86400)
    }
    
    var minsFromSec: Int {
        return (Int(self % 3600) / 60)
    }
    
    func isValueInside(unit: String) -> Bool {
        return unit.range(of: "%@") != nil
    }
    
    func unit(_ unitString: String) -> String {
        let textArray = unitString.localized().components(separatedBy: " | ")
        if textArray.count == 1 {
            return "\(textArray[0])"
            
        } else if textArray.count == 2 {
            let oneText = textArray[0]
            let manyText = textArray[1]
            if self == 1 {
                return "\(oneText)"
            } else {
                return "\(manyText)"
            }
        } else {
            return "\(unitString.localized())"
        }
    }
    
    func textNumber(one:String = "", many:String, noString:String = "") -> String {
        let unit = self.unit(many)
        if self == 0, noString.count > 0 {
            return "\(noString.localized())"
        } else {
            if self.isValueInside(unit: unit) {
                return String(format: "\(unit)", self)// view_unit = %@ View | %@ Views
            } else {
                return "\(self) \(unit)" // view_unit = View | Views
            }
        }
    }
    
    var materialMin: String {
        let sec = self.sec
        let mins = self.minsFromSec
        
        var str = ""
        var unit = "minute".localized()
        
        if mins >= 1 || sec >= 1 {
            str = str + String(format: "%02d:%02d", mins, sec)
            unit = mins.unit("minute")
            
        } else {
            str = "00:00"
            unit = mins.unit("minute")
        }//PO confirm App unit or not ?
        return str
    }
}
