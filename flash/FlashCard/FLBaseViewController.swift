//
//  FLBaseViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 21/10/2564 BE.
//

import UIKit

class FLBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.window?.overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}
