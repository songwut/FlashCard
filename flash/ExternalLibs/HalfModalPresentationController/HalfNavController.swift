//
//  HalfNavController.swift
//  connect
//
//  Created by Songwut Maneefun on 3/21/17.
//  Copyright © 2017 Conicle. All rights reserved.
//

import UIKit

class HalfNavController: UINavigationController, HalfModalPresentable {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isHalfModalMaximized() ? .default : .lightContent
    }
}
