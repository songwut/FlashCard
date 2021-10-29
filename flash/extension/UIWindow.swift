//
//  UIWindow.swift
//  flash
//
//  Created by Songwut Maneefun on 28/10/2564 BE.
//

import Foundation
import MBProgressHUD

extension UIWindow {
    func getView() -> UIView? {
        return UIApplication.shared.window
    }
    
    func showLoading(_ text: String?) {
        guard let view = getView() else { return }
        var hud = MBProgressHUD(for: view)
        if let hud = hud {
            hud.show(animated: false)
        } else {
            hud = MBProgressHUD.showAdded(to: view, animated: false)
        }
        
        if let textStr = text {
            hud?.label.text = textStr
        }
    }
    
    func showText(_ text: String?) {
        guard let view = getView() else { return }
        var hud = MBProgressHUD(for: view)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideLoading))
        hud?.addGestureRecognizer(tap)
        if let hud = hud {
            hud.show(animated: false)
        } else {
            hud = MBProgressHUD.showAdded(to: view, animated: false)
        }
        
        if let textStr = text {
            hud?.label.text = textStr
        }
        hud?.mode = MBProgressHUDMode.text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.hideLoading()
        }
    }
    
    func alertHUD(_ errorType:ErrorType){
        self.alertHUD(errorType.domain().localized())
    }
    
    func alertHUD(_ msg:String){
        guard let view = getView() else { return }
        let hud = MBProgressHUD(for: view)
        hud?.label.text = msg
        hud?.hide(animated: true, afterDelay: 1.0)
    }
    
    @objc func hideLoading() {
        guard let view = getView() else { return }
        let hud = MBProgressHUD(for: view)
        hud?.hide(animated: true, afterDelay: 0.1)
    }
}
