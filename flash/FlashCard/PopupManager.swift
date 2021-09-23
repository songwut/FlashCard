//
//  PopupManager.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import UIKit

class PopupManager: NSObject {
    class var shared: PopupManager {
        
        struct Static {
            static let instance: PopupManager = PopupManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
    }
    //var tabMenu: UIViewController?
    //var rootVC: UIViewController?
    var currentPopup: UIViewController?
    
    //Flash Card
    class func showWarning(_ detail: String, at mainVC: UIViewController? = nil) {
        let btnAction = DidAction { (sender) in
            //do after close popup
        }
        let popup: PopupContent
        let icon = ImageTint(image: UIImage(named: "ic_v2_alert"), color: UIColor.error())
        icon.size = 75
        popup = PopupContent(title: "Warning".localized(), detail: detail.localized(), icon: icon, otherButtonTitles: nil,  closeButtonTitle: "OK".localized(), isError: true)
        popup.closeColor = UIColor.error()
        popup.confirmColor = UIColor.error()
        
        var vc = UIApplication.shared.keyWindow?.rootViewController
        if let current = mainVC {
            vc = current
        } else {
            vc = UserManager.shared.tabMenu ?? UserManager.shared.rootVC
        }
        
        PopupViewController.showVC(vc!, content: popup, didClose: btnAction)
    }
    
    class func showWarning(_ detail: String, confirm: ActionButton? = nil, at mainVC: UIViewController? = nil) {
        let btnAction = DidAction { (sender) in
            //do after close popup
        }
        let popup: PopupContent
        let icon = ImageTint(image: UIImage(named: "ic_v2_alert"), color: .error())
        icon.size = 75
        //popup = PopupContent(title: "warning".localized(), detail: detail.localized(), icon: icon, otherButtonTitles: "confirm".localized(),  closeButtonTitle: "cancel".localized(), isError: true)
        popup = PopupContent(atbTitle: nil, title: "warning".localized(), detail: detail.localized(), icon: icon, otherButtonTitles: nil, closeButtonTitle: "cancel".localized(), confirmAction: confirm)
        popup.closeColor = .info75()
        popup.confirmColor = .info75()
        
        var vc = UIApplication.shared.keyWindow?.rootViewController
        if let current = mainVC {
            vc = current
        } else {
            vc = UserManager.shared.tabMenu ?? UserManager.shared.rootVC
        }
        
        PopupViewController.showVC(vc!, content: popup, didClose: btnAction)
    }
}
