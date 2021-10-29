//
//  TabBarMenuViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import UIKit

class TabBarMenuViewController: UITabBarController {
    var isHidden: Bool {
        get {
            return self.tabBar.isHidden
        }
        set {
            self.tabBar.isHidden = newValue
        }
    }
    
    func setTabBar(isHidden: Bool) {
        if self.isHidden != isHidden {
            self.isHidden = isHidden
        }
    }
}
