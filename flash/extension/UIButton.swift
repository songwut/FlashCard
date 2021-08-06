//
//  UIButton.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import UIKit

extension UIButton {
    
    func setStyleColor(_ isEnabled: Bool, titleColor:UIColor, bgColor:UIColor) {
        self.isEnabled = isEnabled
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = bgColor
    }

    var titleFont: UIFont {
        get {
            return (self.titleLabel?.font)!
        }
        set {
            self.titleLabel?.font = newValue
        }
    }
}
