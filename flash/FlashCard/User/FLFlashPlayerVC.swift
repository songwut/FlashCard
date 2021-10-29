//
//  FLFlashPlayerVC.swift
//  flash
//
//  Created by Songwut Maneefun on 28/10/2564 BE.
//

import UIKit

class FLFlashPlayerVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.barStyle = .black
        self.setNeedsStatusBarAppearanceUpdate()
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

class WhiteNavigationController: UINavigationController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            print(type(of: self), #function)
            let style = super.preferredStatusBarStyle
            print(type(of: self), style.rawValue)
            return style
    }
}
