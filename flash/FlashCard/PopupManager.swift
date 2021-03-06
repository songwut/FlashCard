//
//  PopupManager.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import UIKit
import SwiftUI

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
        
        var vc = UIApplication.shared.window?.rootViewController
        if let current = mainVC {
            vc = current
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
        popup = PopupContent(atbTitle: nil, title: "warning".localized(), detail: detail.localized(), icon: icon, otherButtonTitles: nil, closeButtonTitle: "cancel".localized(), confirmAction: confirm)
        popup.closeColor = .info_75()
        popup.confirmColor = .info_75()
        
        var vc = UIApplication.shared.window?.rootViewController
        if let current = mainVC {
            vc = current
        }
        
        PopupViewController.showVC(vc!, content: popup, didClose: btnAction)
    }
    
    class func showWarningUI(_ detail: String, confirm: ActionButton? = nil) -> some View {
        let btnAction = DidAction { (sender) in
            //do after close popup
        }
        
        let popup: PopupContent
        let icon = ImageTint(image: UIImage(named: "ic_v2_alert"), color: .error())
        icon.size = 75
        if let confirmAction = confirm {
            popup = PopupContent(atbTitle: nil, title: "warning".localized(), detail: detail.localized(), icon: icon, otherButtonTitles: nil, closeButtonTitle: "cancel".localized(), confirmAction: confirmAction)
        } else {
            popup = PopupContent(title: "Warning".localized(), detail: detail.localized(), icon: icon, otherButtonTitles: nil,  closeButtonTitle: "OK".localized(), isError: true)
        }
        popup.closeColor = .info_75()
        popup.confirmColor = .info_75()
        
        return UGCPopupView(content: popup, didClose: btnAction, error: nil)
    }
}
