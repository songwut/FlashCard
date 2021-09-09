//
//  ViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 4/6/2564 BE.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet private weak var stageButton: UIButton!
    
    
    
    func getCenter(_ view: UIView) -> CGPoint {
        let parentFrame = view.superview?.frame ?? .zero
        let x = (parentFrame.width - view.frame.width) / 2
        let y = (parentFrame.height - view.frame.height) / 2
        return CGPoint(x: x, y: y)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = FlashStyle.screenColor
        
        let screenHeight = self.view.frame.height
        let screenWidth = self.view.frame.width
        let screenRatio:CGFloat = 16 / 9
        let height = screenWidth * screenRatio
        var stageFrame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        
        if stageFrame.height > screenHeight {//ipad 3:4 will use this case
            //need scale down height
            //ratioDown 0.x - 1.0
            let ratioDown = screenHeight / stageFrame.height
            let newHeight = stageFrame.height * ratioDown
            let newWidth = stageFrame.width * ratioDown
            let newX = (screenWidth - newWidth) / 2
            let updateFrame = CGRect(x: newX, y: 0, width: newWidth, height: newHeight)
            stageFrame = updateFrame
        }
        //calculate for ipad stageFrame
        
        
        
        // Do any additional setup after loading the view.
        self.stageButton.addTarget(self, action: #selector(self.stageButtonPressed(_:)), for: .touchUpInside)
        
        self.loginPressed(nil)
    }
    
    @objc func stageButtonPressed(_ sender: UIButton) {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLStageViewController")
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func openFlashPlayer(_ sender: UIButton) {
        let s = UIStoryboard(name: "FlashUserDisplay", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLPlayerViewController")
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func openProgressUI(_ sender: UIButton) {
        
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLProgressUIController")
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func categoryListPressed(_ sender: UIButton) {
        JSON.read("ugc-flash-card-category") { (object) in
            if let dictList = object as? [[String : Any]],
               let detail = UGCCategoryPageResult(JSON: ["results": dictList]) {
                let mockList = detail.list
                let host = UIHostingController(rootView: UGCCatagoryListView(items: mockList))
                if let nav = self.navigationController {
                    nav.pushViewController(host, animated: true)
                } else {
                    self.present(host, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func tagListSelectPressed(_ sender: UIButton) {
        JSON.read("ugc-flash-card-tag-list") { (object) in
            if let dict = object as? [String : Any],
               let detail = UGCTagPageResult(JSON: dict) {
                let mockList = detail.list
                let tagListVC = TagListSelectViewController()
                tagListVC.tagList = mockList
                if let nav = self.navigationController {
                    nav.pushViewController(tagListVC, animated: true)
                } else {
                    self.present(tagListVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func flPostPressed(_ sender: UIButton) {
        JSON.read("ugc-flash-card-tag-list") { (object) in
            if let dict = object as? [String : Any],
               let detail = FLDetailResult(JSON: dict) {
                let model = FLPostViewModel(detail)
                let flPostVC = FLPostViewController.instantiate(viewModel: model)
                if let nav = self.navigationController {
                    nav.pushViewController(flPostVC, animated: true)
                } else {
                    self.present(flPostVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func popupImageLimitPressed(_ sender: UIButton) {
        PopupManager.showWarning("You can upload 20 images per page !", at: self)
    }
    
    @IBAction func popupImageSizePressed(_ sender: UIButton) {
        PopupManager.showWarning("Your image is too powerful\n(Maximum size is 4 MB)\nPlease upload again", at: self)
    }
    
    @IBAction func popupVideoLimitPressed(_ sender: UIButton) {
        PopupManager.showWarning("Your video is too powerful\n(Maximum length is 60 seconds)\nPlease upload again", at: self)
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton?) {
        if UserManager.shared.isLoggedin() {
            UserManager.shared.updateProfile {
                if let user = UserManager.shared.profile {
                    PopupManager.showWarning("Login SUCCESS: User ID  \(user.id)", at: self)
                } else {
                    self.loginAPI()
                }
            }
        } else {
            self.loginAPI()
        }
    }
    
    func loginAPI() {
        let username = "sysadmin"
        let password = "sysadminConicle"
        
        self.showLoading(nil)
        let request = LoginRequest()
        request.username = username
        request.password = password
        request.isRemember = true
        API.request(request) { (responseBody: ResponseBody?, profile: ProfileResult?, isCache, error) in
            self.hideLoading()
            if let profile = profile {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "isLoggedin")
                    UserDefaults.standard.synchronize()
                    UserManager.shared.profile = profile
                }
                PopupManager.showWarning("Login SUCCESS: User ID  \(profile.id)", at: self)
            }
        }
    }
}

