//
//  UserManager.swift
//  flash
//
//  Created by Songwut Maneefun on 5/8/2564 BE.
//

import UIKit

class UserManager: NSObject {
    class var shared: UserManager {
        
        struct Static {
            static let instance: UserManager = UserManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
    }
    var currentVC: BaseViewController?
    var tabMenu: TabBarMenuViewController?
    var rootVC: UIViewController?
    var currentPopup: UIViewController?
    var csrftoken: String?
    var profile: ProfileResult!
    
    // MARK: case server maintenance
    func popUpMaintenance(vc: BaseViewController) {
        if isMaintenance {
            let btnAction = DidAction { (sender) in
                // not use exit(0) because it will log as crash
                UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
            }
            let popup: PopupContent
            let detailText = "error_server_maintenance_desc".localized()
            popup = PopupContent(title: "error_server_maintenance_title".localized(), detail: detailText, icon: UIImage(named: "ic_v2_server_maintenance"), otherButtonTitles: nil,  closeButtonTitle: "close_application".localized(), isError: true)
            
            let vc = UserManager.shared.tabMenu ?? UserManager.shared.rootVC
            PopupViewController.showVC(vc!, content: popup, didClose: btnAction)
            
        }
    }
    
    func isLoggedin() -> Bool {
        let isLoggedin = UserDefaults.standard.bool(forKey: "isLoggedin")
        return isLoggedin
    }
    
    func updateProfile(completion: (()->())?) {
        let request = ProfileRequest()
        API.requestForItem(request) { [weak self] (responseBody: ResponseBody?, profile: ProfileResult?, isCache, error) in
            
            if let profile = profile {
                self?.profile = profile
            } else {
                //self.loginAPI()
            }
            completion?()
        }
    }
}
