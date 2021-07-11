//
//  FLToolHelper.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import UIKit

struct FLToolHelper {
    var vc: UIViewController!
    var halfModalDelegate: HalfModalTransitioningDelegate!
    var toolBarVC: FLToolViewController!
    
    init(vc: UIViewController, toolBar:FLToolViewController) {
        self.vc = vc
        self.toolBarVC = toolBar
        
        
    }
    
}
