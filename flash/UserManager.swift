//
//  UserManager.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import UIKit

class UserManager: NSObject {
    class var shared: UserManager {
        
        struct Static {
            static let instance: UserManager = UserManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
    }
    var tabMenu: UIViewController?
    var rootVC: UIViewController?
    var currentPopup: UIViewController?
}
