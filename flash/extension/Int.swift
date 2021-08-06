//
//  Int.swift
//  flash
//
//  Created by Songwut Maneefun on 4/8/2564 BE.
//

import Foundation
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
