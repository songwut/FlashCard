//
//  UIViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import UIKit

extension UIViewController {
    
    var safeAreaTopHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            let topPadding = window.safeAreaInsets.top
            return topPadding
        } else {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top ?? 0
            return topPadding
        }
    }
    
    var safeAreaBottomHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            let topPadding = window.safeAreaInsets.bottom
            return topPadding
        } else {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.bottom ?? 0
            return topPadding
        }
    }
    
}
