//
//  Int.swift
//  flash
//
//  Created by Songwut Maneefun on 4/8/2564 BE.
//

import Foundation

extension Int {
    
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
}
