//
//  ViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 4/6/2564 BE.
//

import UIKit
import SwiftUI

var flashFixId = 260

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        flashFixId = Int(NSString(string: textField.text ?? "6").intValue)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class ViewController: UIViewController {
    
    @IBOutlet private weak var stageButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passTextField: UITextField!
    @IBOutlet private weak var flashIdField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    @IBOutlet private weak var flashIdTextField: UITextField!
    
    func getCenter(_ view: UIView) -> CGPoint {
        let parentFrame = view.superview?.frame ?? .zero
        let x = (parentFrame.width - view.frame.width) / 2
        let y = (parentFrame.height - view.frame.height) / 2
        return CGPoint(x: x, y: y)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = FlashStyle.screenColor
        self.flashIdTextField.delegate = self
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
        
        self.flashIdField.text = "\(flashFixId)"
        self.passTextField.isSecureTextEntry = true
        if let user = UserDefaults.standard.string(forKey: "user_key") {
            self.usernameTextField.text = user
            self.passTextField.text = UserDefaults.standard.string(forKey: "pass_key")
        } else {
            UserDefaults.standard.setValue("sysadmin@conicle.com", forKey: "user_key")
            UserDefaults.standard.setValue("sysadminConicle", forKey: "pass_key")
            UserDefaults.standard.synchronize()
        }
        
        if self.usernameTextField.text == "", self.passTextField.text == "" {
            UserDefaults.standard.setValue("sysadmin@conicle.com", forKey: "user_key")
            UserDefaults.standard.setValue("sysadminConicle", forKey: "pass_key")
            UserDefaults.standard.synchronize()
            
            self.usernameTextField.text = "sysadmin@conicle.com"
            self.passTextField.text = "sysadminConicle"
        }
        
        self.loginPressed(loginButton)
    }
    
    @IBAction func myMaterialPressed(_ sender: UIButton) {
        
        let viewModel = FLFlashCardViewModel()
        self.showLoading(nil)
        viewModel.callAPIMyFlashCard(.get) { (myFlashDetail) in
            self.hideLoading()
            guard let myFlashDetail = myFlashDetail else { return }
            let vc = UIHostingController(rootView: MyMaterialListView(myMaterialFlash: myFlashDetail, list: myFlashDetail.list))
            vc.view.backgroundColor = .white
            if let nav = self.navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func stageButtonPressed(_ sender: UIButton) {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLEditorViewController") as! FLEditorViewController
        vc.viewModel.flashId = flashFixId
        vc.createStatus = .new
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func editFlashButtonPressed(_ sender: UIButton) {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLEditorViewController") as! FLEditorViewController
        vc.viewModel.flashId = flashFixId
        vc.createStatus = .edit
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func openFlashPlayer(_ sender: UIButton) {
        let s = UIStoryboard(name: "FlashUserDisplay", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLPlayerViewController") as! FLPlayerViewController
        vc.viewModel.flashId = flashFixId
        vc.playerState = .user
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func openFlashPlayerPreview(_ sender: UIButton) {
        let s = UIStoryboard(name: "FlashUserDisplay", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLPlayerViewController") as! FLPlayerViewController
        vc.viewModel.flashId = flashFixId
        vc.playerState = .preview
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    @IBAction func openFlashPlayerSwiftUI(_ sender: UIButton) {
        let viewModel = FLFlashPlayerViewModel(flashId: flashFixId)
        let vm = FLFlashCardViewModel(flashId: flashFixId)
        let flashPlayerView = FLFlashPlayerView(viewModel: viewModel,vm:vm, dismiss: {_ in
            self.presentedViewController?.dismiss(animated: true)
        })
        
        let vc = UIHostingController(rootView: flashPlayerView)
        vc.view.backgroundColor = .white
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true) {
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
                let host = UIHostingController(rootView: UGCCatagoryListView(items: mockList) { category in
                    print("UGCCatagoryListView: select: \(category.name)")
                })
                if let nav = self.navigationController {
                    nav.pushViewController(host, animated: true)
                } else {
                    self.present(host, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func tagListSelectPressed(_ sender: UIButton) {
        let tagListVC = TagListSelectViewController()
        if let nav = self.navigationController {
            nav.pushViewController(tagListVC, animated: true)
        } else {
            self.present(tagListVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tagListPressed(_ sender: UIButton) {
        let tagListVC = TagListViewController()
        if let nav = self.navigationController {
            nav.pushViewController(tagListVC, animated: true)
        } else {
            self.present(tagListVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func flPostPressed(_ sender: UIButton) {
        self.showLoading(nil)
        let model = FLFlashCardViewModel()
        model.flashId = flashFixId
        self.hideLoading()
        let vc = FLPostViewController.instantiate(viewModel: model)
        vc.createStatus = .edit
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
        
        /*
        JSON.read("ugc-flash-card-detail") { (object) in
            if let dict = object as? [String : Any],
               let detail = FLDetailResult(JSON: dict) {
                let model = FLFlashCardViewModel()
                model.detail = detail
                let flPostVC = FLPostViewController.instantiate(viewModel: model)
                if let nav = self.navigationController {
                    nav.pushViewController(flPostVC, animated: true)
                } else {
                    self.present(flPostVC, animated: true, completion: nil)
                }
            }
        }
        */
    }
    
    @IBAction func newPostPressed(_ sender: UIButton) {
        let model = FLFlashCardViewModel()
        let vc = FLPostViewController.instantiate(viewModel: model)
        vc.createStatus = .new
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
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
        let username = self.usernameTextField.text ?? "sysadmin@conicle.com"
        let password = self.passTextField.text ?? "sysadminConicle"
        
        UserDefaults.standard.setValue(username, forKey: "user_key")
        UserDefaults.standard.setValue(password, forKey: "pass_key")
        UserDefaults.standard.synchronize()
        
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
        let username = self.usernameTextField.text ?? "sysadmin@conicle.com"
        let password = self.passTextField.text ?? "sysadminConicle"
        
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

