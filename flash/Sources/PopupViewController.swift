//
//  PopupViewController.swift
//  LEGO
//
//  Created by Lullaby on 5/3/2561 BE.
//  Copyright © 2561 Conicle. All rights reserved.
//

import UIKit

struct ActionButton {
    var title: String?
    var action: DidAction?
}

class PopupContent {
    var atbTitle: NSMutableAttributedString?
    var title:String?
    var detail:String?
    var icon: Any?
    var otherButtonTitles: [ActionButton]?
    var closeButtonTitle: String?
    var confirmAction: ActionButton?
    var isError: Bool?
    
    var isDesignSystem = false
    var titleColor = ColorHelper.primary()
    var closeColor = UIColor.gray
    var closeColorBackground = UIColor.clear
    var confirmColor = ColorHelper.primary()
    
    var countDown: Int?
    
    func showOn(_ viewController: UIViewController?, isNewPopUp: Bool = false) {
        if isNewPopUp, let vc = viewController {
            NewPopUpViewController.showVC(vc, content: self)
            
        } else if let vc = viewController {
            PopupViewController.showVC(vc, content: self)
        }
    }
    
    init(atbTitle: NSMutableAttributedString? = nil, title: String? = nil, detail: String? = nil, icon: Any? = nil,otherButtonTitles: [ActionButton]? = nil, closeButtonTitle: String, confirmAction: ActionButton? = nil) {
        self.title = title
        self.atbTitle = atbTitle
        self.detail = detail
        self.icon = icon
        self.otherButtonTitles = otherButtonTitles
        self.closeButtonTitle = closeButtonTitle
        self.confirmAction = confirmAction
    }
    
    init(atbTitle: NSMutableAttributedString? = nil, title: String, detail: String?, icon: Any?, otherButtonTitles: [ActionButton]?, closeButtonTitle: String, isError: Bool? = nil) {
        self.title = title
        self.atbTitle = atbTitle
        self.detail = detail
        self.icon = icon
        self.otherButtonTitles = otherButtonTitles
        self.closeButtonTitle = closeButtonTitle
        self.isError = isError
    }
}

class PopupViewController: UIViewController {
    
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var popupImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var contentWidth: NSLayoutConstraint!
    
    @IBOutlet weak var contentRight: NSLayoutConstraint!
    @IBOutlet weak var contentLeft: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewRightConstraint: NSLayoutConstraint!
    
    var content: Any?
    var error: NSError?
    var statusCode = 0
    var didClose: DidAction?
    var countDown = 0
    var closeButtonTitle = ""
    var timerCountdown:Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        definesPresentationContext = true
        self.cardView.popIn()
        //self.blurView.effect = UIBlurEffect(style: blurEffect)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.blurView.effect = UIBlurEffect(style: blurEffect)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = .clear
        self.view.accessibilityIdentifier = "pop_view_xctest"
        self.titleLabel.accessibilityIdentifier = "title_pop_label_xctest"
        self.detailLabel.accessibilityIdentifier = "detail_pop_label_xctest"
        self.closeButton.accessibilityIdentifier = "close_pop_button_xctest"
        self.detailLabel.textColor = .black
        self.titleLabel.font = FontHelper.getFontSystem(.heading4, font: .bold)
        self.detailLabel.font = FontHelper.getFontSystem(.paragraph, font: .regular)
        self.closeButton.titleFont = FontHelper.getFontSystem(.heading6, font: .regular)
        self.confirmButton.titleFont = FontHelper.getFont(.regular, size: .title)
        self.cardView.setShadow(radius: 10, opacity: 0.2)
        self.closeButton.setTitleColor(.black, for: .normal)
        if let responseBody = self.content as? ResponseBody {
            self.manageResponseBody(responseBody, error: self.error)
            
        } else if let popup = self.content as? PopupContent {
            self.managePopupContent(popup)
            
        } else if let error = self.error {
            self.manageError(error)
        }
        
        if UIDevice.isIpad() {
            self.contentWidth.priority = UILayoutPriority(rawValue: 746)
            self.contentLeft.priority = UILayoutPriority(rawValue: 100)
            self.contentRight.priority = UILayoutPriority(rawValue: 100)
            self.cardView.setWidthConstraint(600)
        } else {
            self.contentWidth.priority = UILayoutPriority(rawValue: 382)
            self.contentLeft.priority = UILayoutPriority(rawValue: 900)
            self.contentRight.priority = UILayoutPriority(rawValue: 900)
        }
    }
    
    func manageError(_ error: NSError) {
        self.popupImg.image = UIImage(named: "ic_error")
        self.popupImg.tintColor = .red
        self.detailLabel.attributedText = createHintAtb(fieldName: "", text: error.localizedDescription)
        self.titleLabel.text = ""
       
        self.closeButton.setTitle("close".localized(), for: .normal)
        
    }
    
    func manageResponseBody(_ responseBody: ResponseBody, error: Error?) {
        var isBody = false
        self.confirmButton.removeFromSuperview()
        self.middleView.removeFromSuperview()
        self.popupImg.image = UIImage(named: "ic_error")
        self.popupImg.tintColor = UIColor("E53935")
        let multiAtb = NSMutableAttributedString()
        
        if let username = responseBody.username {
            isBody = true
            multiAtb.append(createHintAtb(fieldName: "", text: username[0].localized()))
        }
        if let password = responseBody.password {
            isBody = true
            multiAtb.append(createHintAtb(fieldName: "", text: password[0].localized()))
        }
        if let detail = responseBody.detail {
            isBody = true
            multiAtb.append(createHintAtb(fieldName: "", text: detail.localized()))
        }
        
        var codeStr = ""
        if let code = responseBody.urlResponse?.statusCode {
            #if DEBUG
            codeStr = " (\(code))"
            #endif
            isBody = true
            multiAtb.append(createHintAtb(fieldName: "", text: "\(codeStr)"))
        }
        self.detailLabel.textAlignment = .center
        if isBody {
            self.detailLabel.attributedText = multiAtb
            self.titleLabel.text = ""
        } else if let err = error {
            self.detailLabel.attributedText = createHintAtb(fieldName: "", text: err.localizedDescription)
            self.titleLabel.text = ""
        } else {
            self.detailLabel.attributedText = createHintAtb(fieldName: "", text: responseBody.getJSONString())
            self.titleLabel.text = ""
        }
        
    }
    
    func managePopupContent(_ popupContent: PopupContent) {
        if let confirmAction = popupContent.confirmAction {
            self.confirmButton.setTitle(confirmAction.title, for: .normal)
            self.imageHeight.priority = UILayoutPriority(rawValue: 900)
            self.imageHeight.constant = 0
            self.titleTop.constant = 0
            self.detailLabel.textAlignment = .center
            self.detailLabel.font = FontHelper.getFont(.regular, size: .normal)
        } else {
            self.confirmButton.removeFromSuperview()
            self.middleView.removeFromSuperview()
        }
        if let icon = popupContent.icon as? UIImage {
            self.popupImg.image = icon
            self.detailLabel.textAlignment = .center
//            self.imageRatio.priority = UILayoutPriority(rawValue: 900)
            self.imageHeight.priority = UILayoutPriority(rawValue: 100)
            self.imageHeight.constant = 60
            
        } else if let icon = popupContent.icon as? ImageTint {
            self.popupImg.image = icon.image
            self.popupImg.tintColor = icon.tintColor
            self.popupImg.contentMode = .scaleAspectFit
            self.imageHeight.priority = UILayoutPriority(rawValue: 900)
            self.imageHeight.constant = icon.size
        } else {
            self.imageHeight.priority = UILayoutPriority(rawValue: 900)
            self.imageHeight.constant = 0
        }
        if let _ = popupContent.isError {
//            self.imageWeight.constant = 150
            self.detailLabel.textAlignment = .center
        }
        
        self.confirmButton.setTitleColor(popupContent.confirmColor, for: .normal)
        self.closeButton.setTitleColor(popupContent.closeColor, for: .normal)
        self.closeButton.backgroundColor = popupContent.closeColorBackground
        self.titleLabel.textColor = .black
        self.closeButtonTitle = popupContent.closeButtonTitle ?? "close".localized()
        self.closeButton.setTitle(self.closeButtonTitle, for: .normal)
        
        if let countDown = popupContent.countDown {
            self.countDown = countDown
            self.prepareCount()
            self.timerCountdown = Timer.scheduledTimer(timeInterval: Double(1.0), target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
            self.manageCountDownText(count: self.countDown)
        }
        
        if popupContent.isDesignSystem {
            self.closeButton.cornerRadius = 4
            self.confirmButton.cornerRadius = 4
            self.lineView.backgroundColor = .clear
            self.closeButton.setTitleColor(.white, for: .normal)
        }
        
        if popupContent.closeColorBackground == .clear {
            self.stackViewTopConstraint.constant = 0
            self.stackViewBottomConstraint.constant = 0
            self.stackViewLeftConstraint.constant = 0
            self.stackViewRightConstraint.constant = 0
            
        } else if popupContent.isDesignSystem {
            self.stackViewTopConstraint.constant = 0
            self.stackViewBottomConstraint.constant = 30
            self.stackViewLeftConstraint.constant = 86
            self.stackViewRightConstraint.constant = 86
        } else {
            self.stackViewTopConstraint.constant = 8
            self.stackViewBottomConstraint.constant = 8
            self.stackViewLeftConstraint.constant = 8
            self.stackViewRightConstraint.constant = 8
        }
        
        if let titleAtb = popupContent.atbTitle {
            self.titleLabel.textColor = .black
            self.titleLabel.attributedText = titleAtb
            self.detailLabel.text = ""
        } else {
            self.titleLabel.text = popupContent.title ?? ""
            self.detailLabel.text = popupContent.detail ?? ""
        }
    }
    
    func prepareCount() {
        self.timerCountdown?.invalidate()
        self.timerCountdown = Timer()
    }
    
    func manageCountDownText(count:Int?) {
        if let c = count {
            let textCount = self.closeButtonTitle + " " + "(\(c))"
            self.closeButton.setTitle(textCount, for: .normal)
        } else {
            self.closeButton.setTitle(self.closeButtonTitle, for: .normal)
        }
    }
    
    @objc func updateCountdown() {
        if(self.countDown >= 0) {
            self.manageCountDownText(count: self.countDown)
        } else {
            self.manageCountDownText(count: self.countDown)
            self.prepareCount()
            self.closeBtnPressed(self.closeButton)
        }
        self.countDown -= 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let popup = self.content as? PopupContent {
                popup.confirmAction?.action?.handler(sender)
            }
            UserManager.shared.currentPopup = nil
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.didClose?.handler(sender)
            UserManager.shared.currentPopup = nil
        }
    }
    
    func setContent(icon: UIImage, title: String, detail: String, closeTitle: String) {
        self.popupImg.image = icon
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
    
    func createHintAtb(fieldName: String, text: String) -> NSMutableAttributedString {
        let color = UIColor("E53935")
        let font = FontHelper.getFont(.regular, size: .normal)
        let multiAtb = NSMutableAttributedString()
        multiAtb.append(Utility.attributedText(with: "\(fieldName)\(text)\n", font: font, color: color))
        return multiAtb
    }
    
    class func showVC(_ viewController: UIViewController, content: Any?, didClose: DidAction? = nil, error: NSError? = nil) {
        if let vc = UserManager.shared.currentPopup {
            vc.dismiss(animated: false) {
                PopupViewController.openVC(viewController, content: content, didClose: didClose, error: error)
            }
        } else {
            if viewController.isKind(of: CourseDetailViewController.self) {
                PopupViewController.openVCByParentViewcontroller(viewController,
                                                                 content: content,
                                                                 didClose: didClose,
                                                                 error: error)
            } else{
                PopupViewController.openVC(viewController, content: content, didClose: didClose, error: error)
            }
        }
    }
    
    class func openVCByParentViewcontroller(_ viewController: UIViewController, content: Any?, didClose: DidAction? = nil, error: NSError? = nil) {
        let vc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.content = content
        vc.didClose = didClose
        vc.error = error
        UserManager.shared.currentPopup = vc
        viewController.present(vc, animated: false, completion: nil)
    }
    
    class func openVC(_ viewController: UIViewController, content: Any?, didClose: DidAction? = nil, error: NSError? = nil) {
        let vc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.content = content
        vc.didClose = didClose
        vc.error = error
//        vc.isHeroEnabled = true
//        vc.heroModalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        UserManager.shared.currentPopup = vc
        viewController.present(vc, animated: false, completion: nil)
    }
}
