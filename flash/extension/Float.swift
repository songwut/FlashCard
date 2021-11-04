//
//  Float.swift
//  flash
//
//  Created by Songwut Maneefun on 3/11/2564 BE.
//

import Foundation

extension Float {
    var priority: UILayoutPriority {
        return UILayoutPriority(rawValue: self)
    }
    
    var scoreText: String {
        if self.decimal == 0.0, self == 0.0 {
            return "0"
        } else if self > 0.0  {
            return "\(Int(self))"
        } else {
            return "\(self)"
        }
    }
    
    var decimal:Float {
        return self - floor(self)
    }
    
    var roundInt: Int {
        if self.decimal >= 0.5 {
            return Int(ceil(self))//up
        } else {
            return Int(floor(self))//down
        }
    }
    
    var roundUpInt: Int {
        if self.decimal >= 0.1 {
            return Int(ceil(self))//up away
        } else {
            return Int(floor(self))//down
        }
    }
    
    var roundStar: Int {
        let decimal:Float = self.decimal
        var f:Float = self
        if decimal <= 0.2   {
            return Int(floor(self))//down
            
        } else if decimal <= 0.7 {
            return Int(f.rounded(.down) + 0.5)
            
        } else {
            return Int(ceil(self))//up
        }
    }
    
    func withCommas() -> String {
        return String(format: "%.02f", self)
    }
    
    func twoDigitAfterDecimal() -> Double {
        return Double((self*100).rounded()/100)
    }
    
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value:self)) {
            return formattedNumber
        }
        return String(format: "%.02f", self)
    }
    
    func twoDigitAfterDecimal() -> Double {
        return Double((self*100).rounded()/100)
    }
}
