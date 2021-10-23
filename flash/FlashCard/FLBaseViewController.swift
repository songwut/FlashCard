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
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}
