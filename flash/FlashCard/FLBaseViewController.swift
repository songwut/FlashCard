//
//  FLBaseViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 21/10/2564 BE.
//

import UIKit
import IQKeyboardManagerSwift

class FLBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        UIApplication.shared.window?.overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}
