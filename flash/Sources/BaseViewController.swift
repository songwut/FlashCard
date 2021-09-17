//
//  BaseViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import UIKit

class BaseViewController: UIViewController {

    var errorAutoDismiss = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BaseViewController: BaseViewProtocol {
    func showProgressLoading() {
        self.showLoading(nil)
    }
    
    func hideProgressLoading() {
        self.hideLoading()
    }
}
