//
//  UIApplication.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import UIKit


extension UIApplication {
    var window: UIWindow? {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window
    }
    
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 1212312121
            if let statusBar = window?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag

                window?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.window?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
}
