//
//  FLPostViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 8/9/2564 BE.
//

import UIKit
import SwiftUI
import GrowingTextView
import AVFoundation
import IQKeyboardManagerSwift

final class FLPostViewController: UIViewController, NibBased, ViewModelBased {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var imageButton: UIButton!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var titleRequireLabel: UILabel!
    @IBOutlet private weak var titleLimitLabel: UILabel!
    
    @IBOutlet private weak var idView: UIView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var idValueLabel: UILabel!
    
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var descTextView: GrowingTextView!
    @IBOutlet private weak var descLimitLabel: UILabel!
    
    @IBOutlet private weak var ownerLabel: UILabel!
    @IBOutlet private weak var ownerValueLabel: UILabel!
    @IBOutlet private weak var updateLabel: UILabel!
    @IBOutlet private weak var updateValueLabel: UILabel!
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var timeValueLabel: UILabel!
    @IBOutlet private weak var timeMinLabel: UILabel!
    @IBOutlet private weak var timeScaleView: UIView!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var plusButton: UIButton!
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var categoryView: UIView!
    @IBOutlet private weak var categoryTextView: GrowingTextView!
    
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var tagPlaceholderLabel: UILabel!
    @IBOutlet private weak var tagContentView: UIView!
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var tagView: TagListView!
    @IBOutlet private weak var tagHeight: NSLayoutConstraint!
    @IBOutlet private weak var tagRequireLabel: UILabel!
    
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var statusPin: UIView!
    @IBOutlet private weak var statusValueLabel: UILabel!
    
    @IBOutlet private weak var requestStackView: UIStackView!
    @IBOutlet private weak var requestLabel: UILabel!
    @IBOutlet private weak var requesValue: UIButton!
    @IBOutlet private weak var requesIcon: UIImageView!
    @IBOutlet private weak var requesDesc: UILabel!
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var gotoBackButton: UIButton!
    
    private let tagRequireText = String(format: "input_xx".localized(), "tag".localized().lowercased())
    
    var createStatus:FLCreateStatus = .new
    var isCustomNavBarBack = false
    var latestTags: [UGCTagResult]?
    
    var viewModel: FLFlashCardViewModel! {
        didSet {
            let _ = self.viewModel.detail
        }
    }
    
    private var imageBase64:String?
    private var time = 1
    private var imageCoverData: Data?
    private let formatText = "d MMM yyyy HH:mm"
    private var isNeedUpdate = false
    private var isNeedChangeBarItems = true
    
    private var backBtn = UIBarButtonItem()
    private var editBtn = UIBarButtonItem()
    private var previewBtn = UIBarButtonItem()
    private var tagTextColor: UIColor = .text()
    private var tagBGTextColor: UIColor = .text()
    private let requireColor =  UIColor(hex: "ff3e2b")
    private let fontTitle = UIFont.font(16, .medium)
    private let fontValue = UIFont.font(16, .text)
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePressed))
        var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    deinit {
        ConsoleLog.show("complete removed : FLPostViewController")
    }
    
    @objc func titleTextFieldChange(_ textField: UITextField) {
        if let text = textField.text {
            let maxLength = FlashStyle.post.maxChaTitle
            textField.text = String(text.prefix(maxLength))
            let countText = textField.text?.count ?? 0
            self.updateTitleLimit(countText)
        }
    }
    
    var selectedCategory: CategoryResult? {
        didSet {
            guard let category = self.selectedCategory else { return  }
            self.categoryTextView.text = category.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.scrollView.alpha = 0.0
        backBtn = UIBarButtonItem(image: UIImage(named: "ic-arrow-nav-back"), style: .plain, target: self, action: #selector(self.backPressed))
        editBtn = UIBarButtonItem(image: UIImage(named: "ic_v2_edit"), style: .plain, target: self, action: #selector(self.editPressed))
        previewBtn = UIBarButtonItem(image: UIImage(named: "ic_v2_preview"), style: .plain, target: self, action: #selector(self.previewPressed))
        backBtn.tintColor = headerTextColor
        editBtn.tintColor = headerTextColor
        previewBtn.tintColor = headerTextColor
        
        self.keyboardManager(false)
        self.footerView.setShadow(radius: 16, opacity: 0.09, color: .black, offset: CGSize(width: 0, height: -2))
        self.titleTextField.delegate = self
        self.titleTextField.addTarget(self, action: #selector(self.titleTextFieldChange(_:)), for: .editingChanged)
        self.coverImageView.cornerRadius = 8
        self.titleLabel.attributedText = self.fieldAtbText(title: "title_name_material",
                                                         isRequire: true,
                                                         font: self.fontTitle)
        self.titleRequireLabel.font = fontValue
        self.titleRequireLabel.text = ""
        self.titleRequireLabel.textColor = .error()
        self.tagStackView.isHidden = true
        self.tagRequireLabel.isHidden = true
        self.tagRequireLabel.text = self.tagRequireText
        self.tagRequireLabel.font = fontValue
        self.tagRequireLabel.textColor = .error()
        self.descLimitLabel.font = .font(12, .text)
        self.descLimitLabel.textColor = .lightGray
        self.titleLimitLabel.font = .font(12, .text)
        self.titleLimitLabel.textColor = .lightGray
        self.titleTextField.font = fontValue
        self.titleTextField.textColor = .text()
        self.idView.borderWidth = 1
        self.idView.cornerRadius = 9
        self.idLabel.text = "content_id".localized()
        self.ownerLabel.text = "created_by".localized()
        self.updateLabel.text = "update_date".localized()
        self.timeLabel.text = "estimate_time".localized()
        self.descLabel.text = "description".localized()
        self.submitButton.setTitle("submit_to_approve".localized(), for: .normal)
        self.idLabel.font = fontTitle
        self.idValueLabel.font = UIFont.font(14, .text)
        self.descLabel.font = fontTitle
        self.descTextView.maxLength = FlashStyle.post.maxChaDesc
        self.descTextView.borderWidth = 1
        self.descTextView.borderColor = UIColor("A9A9A9")
        self.descTextView.backgroundColor = .white
        self.descTextView.placeholder = FlashStyle.post.descPlaceHolder
        self.descTextView.placeholderColor = .text25()
        self.descTextView.textColor = .text()
        self.descTextView.font = fontValue
        self.descTextView.delegate = self
        self.descTextView.inputAccessoryView = self.inputToolbar
        self.ownerLabel.font = fontTitle
        self.ownerValueLabel.font = fontValue
        self.ownerValueLabel.textColor = .text()
        self.updateLabel.font = fontTitle
        self.updateValueLabel.font = fontValue
        self.updateValueLabel.textColor = .text()
        self.timeLabel.font = fontTitle
        self.timeMinLabel.font = fontTitle
        self.timeMinLabel.text = "minutes".localized()
        self.timeMinLabel.textColor = .text()
        self.timeValueLabel.font = fontTitle
        self.categoryLabel.font = fontTitle
        self.categoryTextView.borderColor = .clear
        self.categoryTextView.isUserInteractionEnabled = false
        self.categoryTextView.font = fontValue
        self.categoryTextView.textColor = .text()
        self.categoryTextView.placeholder = FlashStyle.post.categoryPlaceHolder
        self.categoryTextView.placeholderColor = .text25()
        self.tagLabel.font = fontTitle
        self.tagPlaceholderLabel.font = fontValue
        self.tagPlaceholderLabel.text = FlashStyle.post.tagPlaceHolder
        self.tagPlaceholderLabel.textColor = .text25()
        self.statusLabel.font = fontTitle
        self.statusValueLabel.font = fontValue
        self.idView.backgroundColor = .clear
        self.requestLabel.font = fontTitle
        self.requesDesc.font = .font(10, .medium)
        self.requesDesc.textColor = .text75()
        self.requesIcon.image = UIImage(named: "info")
        self.requesIcon.tintColor = .config_secondary_50()
        self.categoryView.isUserInteractionEnabled = true
        self.tagContentView.isUserInteractionEnabled = true
        
        let tapCategory = UITapGestureRecognizer(target: self, action: #selector(self.categoryPressed(_:)))
        self.categoryView.addGestureRecognizer(tapCategory)
        
        let tapTag = UITapGestureRecognizer(target: self, action: #selector(self.tagViewPressed))
        self.tagContentView.addGestureRecognizer(tapTag)
        self.tagContentView.updateLayout()
        self.tagContentView.backgroundColor = .white
        self.tagView.backgroundColor = .clear
        self.tagView.updateLayout()
        self.tagView.delegate = self
        self.tagView.tagLineBreakMode = .byTruncatingTail
        
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.isHidden = true
        self.cancelButton.isHidden = true
        self.gotoBackButton.setTitleColor(.config_primary(), for: .normal)
        self.gotoBackButton.borderColor = .config_primary()
        self.coverImageView.image = nil
        self.imageButton.isHidden = true
        self.imageButton.backgroundColor = UIColor.elementBackground()
        self.updateGotoBackTitle()
        self.serDefaultUI()
        
        if self.createStatus == .new {
            guard let profile = UserManager.shared.profile else { return }
            self.showLoading(nil)
            self.viewModel.callAPINewFlashCard(profile: profile) { [weak self] (newDetail) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    guard let detail = newDetail else { return }
                    self.viewModel.materialId = detail.id
                    self.loadDetail(detail)
                }
            }
        }
    }
    
    private func updateGotoBackTitle() {
        let homeVC = self.navigationController?.viewControllers.first { $0.className.contains(find: "Home") }
        
        if let _ = homeVC {
            let backTitle = String(format: "go_to_xx".localized(), "homepage".localized())
            self.gotoBackButton.setTitle(backTitle, for: .normal)
        } else {
            let backTitle = String(format: "go_to_xx".localized(), "my_material".localized())
            self.gotoBackButton.setTitle(backTitle, for: .normal)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.viewModel.detail?.name = self.titleTextField.text ?? ""
        self.viewModel.detail?.desc = self.descTextView.text ?? ""
        self.callAPIFlashDetailUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
        self.callAPIFlashDetail()
    }
    
    @IBAction func timePlusPressed(_ sender: UIButton) {
        self.time = self.time + 1
        self.enableMinusButton(isEnable: self.time >= 1)
        self.timeValueLabel.text = "\(self.time)"
        self.timeMinLabel.text = self.timeMinText(time: self.time)
        self.viewModel.detail?.estimateTime = self.time
        self.isNeedUpdate = true
        ConsoleLog.show("timeNumber: \(self.time)")
    }
    
    @IBAction func timeMinusPressed(_ sender: UIButton) {
        
        self.time = self.time - 1
        self.enableMinusButton(isEnable: self.time >= 1)
        self.timeValueLabel.text = "\(self.time)"
        self.timeMinLabel.text = self.timeMinText(time: self.time)
        self.viewModel.detail?.estimateTime = self.time
        self.isNeedUpdate = true
        ConsoleLog.show("timeNumber: \(self.time)")
    }
    
    @objc func backPressed() {
        if self.isRequireField() {
            return
        }
        
        if self.isNeedUpdate {
            let json = self.createJSON()
            ConsoleLog.show("callAPIFlashDetailUpdate")
            self.showLoading(nil)
            self.viewModel.callAPIFlashDetailUpdate(parameter: json) { [weak self] (updatedDetail) in
                self?.hideLoading()
                self?.isNeedUpdate = false
                self?.createStatus = .edit//reset to edit
                self?.backAfterUpdate()
            }
        } else {
            self.backAfterUpdate()
        }
    }
    
    func backAfterUpdate() {
        guard let detail = self.viewModel.detail else { return }
        if detail.requestStatus == .approved
            || detail.requestStatus == .inprogress
            || detail.requestStatus == .notStart {
            
            if self.viewModel.isFromCreate {
                //dissmiss to parent VC (home, mylibrary, mymaterial) if come from create
                self.customDismiss(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func editPressed() {
        if self.isRequireField() {
            return
        }
        self.callAPIFlashDetailUpdate()
        
        if self.viewModel.contentCode == .flashcard {
            if let _ = self.navigationController?.viewControllers.last as? FLEditorViewController {
                //case from new flashcard has flPostVC in last
                self.navigationController?.popViewController(animated: true)
            } else {
                //case edit exiting content
                let s = UIStoryboard(name: "FlashCard", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "FLEditorViewController") as! FLEditorViewController
                vc.createStatus = .edit
                vc.isTurnBack = true
                vc.viewModel =  self.viewModel
                if let nav = self.navigationController {
                    nav.pushViewController(vc, animated: true)
                } else {
                    self.present(vc, animated: true, completion: nil)
                }
            }
        } else if self.viewModel.contentCode == .video
                    ||  self.viewModel.contentCode == .audio {
            
            guard let detail = self.viewModel.detail else { return }
            let model = UGCCreateMediaViewModel(mId: self.viewModel.materialId,
                                                contentCode: self.viewModel.contentCode)
            model.detail = detail
            //this trick to hide postbutton in nav bar
            model.isComeFromEditPost = true
            
            let createVideoView =  UGCCreateMediaSwiftUIView(isCreated: false)
                .environmentObject(model)
            let vc = UIHostingController(rootView: createVideoView)
            vc.view.backgroundColor = .white
            if let nav = self.navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func previewPressed() {
        if self.isRequireField() {
            return
        }
        
        self.callAPIFlashDetailUpdate()
        
        if self.viewModel.contentCode == .flashcard {
            let s = UIStoryboard(name: "FlashUserDisplay", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "FLPlayerViewController") as! FLPlayerViewController
            vc.isShowInfo = false
            vc.playerState = .preview
            vc.viewModel =  self.viewModel
            
            if let nav = self.navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
            
        } else if self.viewModel.contentCode == .video
                    ||  self.viewModel.contentCode == .audio {
            
            guard let detail = self.viewModel.detail,
                  let mediaUrl = URL(string: detail.url ?? "") else { return }
            let contentCode = self.viewModel.contentCode
            let model = UGCPlayerFullScreenViewModel(contentCode: contentCode,
                                                     isNeedStopWhenClose: true,
                                                     mediaUrl: mediaUrl,
                                                     coverImage: detail.image,
                                                     currentTime: 0.0)
            OpenVCHelper.openUGCMediaPreview(viewModel: model, mainVC: self)
            //auto rotation swiftUI : UGCCustomPlayerView can open fullscreen but need custom more
            //fix rotation uikit : UGCPlayerFullScreenViewController
        }
    }
    
    @IBAction func imagePressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.image"]
        picker.videoQuality = .typeHigh
        picker.isEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func categoryPressed(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        gesture.view?.isUserInteractionEnabled = false
        self.showLoading(nil)
        self.viewModel.callAPICategoryList { [weak self] (listResult) in
            gesture.view?.isUserInteractionEnabled = true
            self?.hideLoading()
            guard let list = listResult else { return }
            var categoryView = UGCCatagoryListView(items: list)
            categoryView.delegate = self
            let host = UIHostingController(rootView: categoryView)
            if let nav = self?.navigationController {
                nav.pushViewController(host, animated: true)
            } else {
                self?.present(host, animated: true, completion: nil)
            }
        }
    }
    
    @objc func tagViewPressed() {
        self.view.endEditing(true)
        let detail = self.viewModel.detail!
        
        if let tagList = self.latestTags {
            self.openTagListVC(tags: tagList)
        } else {
            self.latestTags = nil
            
            for tag in detail.tagList {
                let tagSet = detail.tagList.first {$0.id == tag.id}
                tagSet?.isSelected = true
            }
            self.openTagListVC(tags: detail.tagList)
        }
    }
    
    func openTagListVC(tags:[UGCTagResult]) {
        var idTags = [Int]()
        for tag in tags {
            idTags.append(tag.id)
        }
        
        let s = UIStoryboard(name: "TagSelect", bundle: nil)
        let tagListVC = s.instantiateViewController(withIdentifier: "TagListSelectViewController") as! TagListSelectViewController
        tagListVC.viewModel.selectTagId = idTags
        tagListVC.delegate = self
        if UIDevice.isIpad() {
            tagListVC.modalTransitionStyle = .crossDissolve
            tagListVC.modalPresentationStyle = .overFullScreen
            
            self.present(tagListVC, animated: true, completion: nil)
        } else {
            if let nav = self.navigationController {
                nav.pushViewController(tagListVC, animated: true)
            }
        }
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if !self.isRequireField() {
            let detail = self.viewModel.detail!
            self.openPopupWith(detail: detail)
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        let detail = self.viewModel.detail!
        self.openPopupWith(detail: detail)
    }
    
    func openPopupWith(detail: FLDetailResult) {
        let detail = self.viewModel.detail!
        var desc = "confirm_submit_material".localized()
        if detail.requestStatus == .approved {
            desc = "confirm_cancel_request".localized()
        }
        
        let confirm = ActionButton(
            title: "confirm".localized(),
            action: DidAction(handler: { [weak self] (sender) in
                self?.callApiPost(requestStatus: detail.requestStatus)
            })
        )
        PopupManager.showWarning(desc, confirm: confirm, at: self)
    }
    
    func callApiPost(requestStatus: RequestStatus) {
        self.isNeedUpdate = true
        
        if requestStatus == .inprogress || requestStatus == .notStart {
            self.callAPIFlashDetailCancel()//cancel
            
        } else if requestStatus == .none || requestStatus == .requestExpired {
            self.callAPIFlashDetailUpdate(isSubmit: true)//submit
        }
    }
    
    func callAPIFlashDetail() {
        self.viewModel.callAPIFlashDetail(.get) { [weak self] (detail) in
            DispatchQueue.main.async {
                self?.loadDetail(detail)
            }
        }
    }
    
    func callAPIFlashDetailUpdate(isSubmit: Bool = false) {
        if self.isNeedUpdate {
            let json = self.createJSON()
            ConsoleLog.show("callAPIFlashDetailUpdate")
            self.viewModel.callAPIFlashDetailUpdate(parameter: json) { [weak self] (updatedDetail) in
                self?.isNeedUpdate = false
                self?.createStatus = .edit//reset to edit
                self?.loadDetail(updatedDetail)
                if isSubmit {
                    self?.callAPIFlashDetailSubmit()
                }
            }
        }
    }
    
    func callAPIFlashDetailSubmit() {
        self.viewModel.callAPIFlashDetailSubmit { [weak self] (detail) in
            self?.viewModel.detail?.contentRequest?.status = .approved
            self?.viewModel.detail?.displayStatus = .unpublish
            self?.loadDetail(detail)
            self?.isNeedUpdate = true
            self?.isNeedChangeBarItems = true
            self?.callAPIFlashDetail()
        }
    }
    
    func customDismiss(animated: Bool = true) {//Dismiss many cas
        let nav = self.navigationController
        
        let myMaterialListView = nav?.viewControllers.first { $0.className.contains(find: "MyMaterialListView") }
        if let targetVC = myMaterialListView {
            //case create new in MyMaterialListView
            self.navigationController?.popToViewController(targetVC, animated: animated)
            return
        }
        
        let myLibraryVC = nav?.viewControllers.first { $0.className.contains(find: "MyLibraryViewController") }
        if let targetVC = myLibraryVC {
            nav?.popToViewController(targetVC, animated: animated)
            return
        }
        
        let dHomeVC = nav?.viewControllers.first { $0.className.contains(find: "DynamicHomeViewController") }
        if let targetVC = dHomeVC {
            nav?.popToViewController(targetVC, animated: animated)
            return
        }
    }
    
    func callAPIFlashDetailCancel() {
        self.viewModel.callAPIFlashDetailCancel { [weak self]  (detail) in
            self?.isNeedChangeBarItems = true
            self?.callAPIFlashDetail()
        }
    }
    
    func createJSON() -> [String: Any]? {
        let detail = self.viewModel.detail!
        
        var dict = [String: Any]()
        
        var tags = [Int]()
        if let latestTags = self.latestTags {
            for tag in latestTags {
                tags.append(tag.id)
            }
        }
        
        dict["name_content"] = self.titleTextField.text
        dict["desc"] = self.descTextView.text
        if self.viewModel.isUpdateDuration() {
            dict["duration"] = self.time
        }
        dict["created_by"] = detail.owner?.id ?? UserManager.shared.profile.id
        
        if let imageBase64 = self.imageBase64 {
            dict["image"] = imageBase64
        }
        if let category = self.selectedCategory {
            dict["category"] = category.id
        }
        
        dict["tag_list"] = tags
        dict["is_display"] = false
        
        return dict
    }
    
    @IBAction func myMaterialPressed(_ sender: UIButton) {
        if self.isRequireField() {
            return
        }
        
        if self.isNeedUpdate {
            let json = self.createJSON()
            ConsoleLog.show("callAPIFlashDetailUpdate")
            self.showLoading(nil)
            self.viewModel.callAPIFlashDetailUpdate(parameter: json) { [weak self] (updatedDetail) in
                self?.hideLoading()
                self?.isNeedUpdate = false
                self?.createStatus = .edit//reset to edit
                self?.customDismiss()
            }
        } else {
            self.customDismiss()
        }
    }
    
    private func serDefaultUI() {
        self.titleTextField.text = ""
        self.descTextView.text = ""
        self.updateValueLabel.text = ""
        self.categoryTextView.text = ""
        self.updateValueLabel.text = ""
        self.idView.isHidden = true
    }
    
    private func loadDetail(_ detail: FLDetailResult?) {
        self.scrollView.alpha = 1.0
        self.hideLoading()
        guard let detail = detail else { return }
        self.time = detail.estimateTime
        
        self.titleTextField.text = detail.nameContent
        self.descTextView.text = detail.desc
        
        self.updateTitleLimit(detail.nameContent.count)
        self.updateDescLimit(detail.desc.count)
        
        if let imageCoverData = self.imageCoverData,
           let uiimage = UIImage(data: imageCoverData) {
            self.coverImageView.image = uiimage
        } else {
            self.coverImageView.setImage(detail.image, placeholderImage: defaultCoverFlash)
        }
        
        self.ownerValueLabel.text = detail.owner?.name ?? ""
        self.categoryTextView.text = self.getCatagoryName(detail)
        
        let dateTime = formatter.with(dateFormat: formatText, dateString: detail.datetimeUpdate)
        self.updateValueLabel.text = dateTime
        if self.viewModel.contentCode == .video
            || self.viewModel.contentCode == .audio {
            self.imageButton.isHidden = true
            self.timeScaleView.isHidden = true
            self.timeValueLabel.isHidden = true
            self.timeMinLabel.text =  detail.duration.materialMin
            
        } else {
            self.imageButton.isHidden = false
            self.timeScaleView.isHidden = false
            self.timeValueLabel.isHidden = false
            self.timeValueLabel.text = "\(self.time)"
            let minStr = self.time.textNumber(many: "minutes")
            let minUnit = minStr.replace("\(self.time) ", withString: "")
            self.timeMinLabel.text = minUnit
        }
        
        self.idView.isHidden = detail.code == ""
        self.idValueLabel.text = detail.code
        self.idValueLabel.textColor = detail.contentCode.getColor()
        self.idView.borderColor = detail.contentCode.getColor()
        self.statusValueLabel.text = detail.displayStatus.title()
        
        let requestStatus = detail.requestStatus
        self.requesValue.backgroundColor = requestStatus.bgColor()
        self.requesValue.setTitleColor(requestStatus.color(), for: .normal)
        self.requesValue.setTitle(requestStatus.title(), for: .normal)
        self.requesDesc.text = requestStatus.descDict().localized()
        self.statusPin.backgroundColor = detail.displayStatus.color()
        self.requestStackView.isHidden = detail.contentRequest == nil
        self.tagStackView.isHidden = !tagMaterialTypeIsDisplay
        self.tagLabel.attributedText = self.fieldAtbText(title: "tag".localized(),
                                                         isRequire: tagMaterialTypeIsRequired,
                                                         font: self.fontTitle)
        
        if self.isNeedChangeBarItems {
            //protech case goto tag,category
            //custom BarButton UIKit and SwiftUI
            self.navigationItem.setHidesBackButton(true, animated:false)
            
            let buttonItems = detail.isHiddenEdit() ? [self.previewBtn] : [self.previewBtn, self.editBtn]
            
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = buttonItems
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = self.backBtn
            
            self.isNeedChangeBarItems = false
        }
        
        if requestStatus == .approved  {
            self.submitButton.backgroundColor = .disable()
            self.submitButton.isUserInteractionEnabled = false
            self.submitButton.isHidden = false
            self.cancelButton.isHidden = true
            
        } else if requestStatus == .requestExpired ||  requestStatus == .rejected  {
            self.submitButton.backgroundColor = .config_primary()
            self.submitButton.isUserInteractionEnabled = true
            self.submitButton.isHidden = false
            self.cancelButton.isHidden = true
            
        } else if requestStatus == .inprogress || requestStatus == .notStart {
            self.cancelButton.backgroundColor = .config_primary()
            self.cancelButton.isUserInteractionEnabled = true
            self.submitButton.isHidden = true
            self.cancelButton.isHidden = false
            
        } else {
            self.submitButton.isHidden = false
            self.cancelButton.isHidden = true
            self.requestStackView.isHidden = true
        }
        
        if detail.requestStatus == .inprogress
            || requestStatus == .notStart
            || detail.requestStatus == .approved {
            self.enableUI(isEnable: false)
        } else {
            self.enableUI(isEnable: true)
        }
        
        self.manageTagContentViewWith(tags: latestTags ?? detail.tagList)
    }
    
    private func updateTitleLimit(_ count: Int) {
        let maxLength = FlashStyle.post.maxChaTitle
        self.titleLimitLabel.text = "\(count)/\(maxLength) " + "character_limit".localized()
    }
    
    private func updateDescLimit(_ count: Int) {
        let maxLength = FlashStyle.post.maxChaDesc
        self.descLimitLabel.text = "\(count)/\(maxLength) " + "character_limit".localized()
    }
    
    private func fieldAtbText(title: String, isRequire: Bool, font: UIFont) -> NSAttributedString {
        let atbTitle = Utility.attributedText(with: title.localized(), font: font, color: .black)
        if isRequire {
            let atbRequire = Utility.attributedText(with: " *", font: font, color: self.requireColor)
            atbTitle.append(atbRequire)
        }
        return atbTitle
    }
    
    private func enableMinusButton(isEnable: Bool) {
        let disableColor = UIColor.disable()
        self.minusButton.isUserInteractionEnabled = isEnable
        self.minusButton.tintColor = isEnable ? .config_primary() : disableColor
    }
    
    private func enableUI(isEnable: Bool) {
        
        let isEnableMinusUI = isEnable && self.time >= 1
        self.enableMinusButton(isEnable: isEnableMinusUI)
        
        let disableColor = UIColor.disable()
        let textColor = UIColor.text()
        imageButton.isUserInteractionEnabled = isEnable
        titleTextField.isEnabled = isEnable
        titleTextField.textColor = isEnable ? textColor : disableColor
        descTextView.isUserInteractionEnabled = isEnable
        descTextView.textColor = isEnable ? textColor : disableColor
        timeValueLabel.textColor = isEnable ? textColor : disableColor
        plusButton.isUserInteractionEnabled = isEnable
        plusButton.tintColor = isEnable ? .config_primary() : disableColor
        categoryTextView.textColor = isEnable ? textColor : disableColor
        categoryView.isUserInteractionEnabled = isEnable
        
        tagButton.isEnabled = isEnable
        tagContentView.isUserInteractionEnabled = isEnable
        tagView.isUserInteractionEnabled = isEnable
        tagView.tagBackgroundColor = isEnable ? tagBgEnableColor : .text(0.1)
        
        tagView.textColor = isEnable ? tagTextEnableColor : .text()
        tagView.borderColor = .clear
        tagView.borderWidth = 1
        
        tagTextColor = isEnable ? tagTextEnableColor : .text()
        tagBGTextColor = isEnable ? tagBgEnableColor : .text(0.1)
    }
    
    private func getCatagoryName(_ detail: FLDetailResult) -> String? {
        var categoryText: String?
        
        if let selectedCategory = self.selectedCategory {
            categoryText = selectedCategory.name
            
        } else if let category = detail.category {
            categoryText = category.name
            
        }
        return categoryText
    }
    
    private func isRequireField() -> Bool {
        
        if !self.viewModel.isCanEditPost()  {
            return false
        }
        
        var isRequire = false
        if let text = self.titleTextField.text,
           !text.trimmingCharacters(in: .whitespaces).isEmpty,
            text.count >= 1 {
            self.titleRequireLabel.text = ""
        } else {
            let title = "title_name_material".localized()
            let placeholder = String(format: "input_xx".localized(), title.lowercased())
            self.titleRequireLabel.text = placeholder
            isRequire = true
        }
        
        if tagMaterialTypeIsRequired ,tagMaterialTypeIsDisplay {
            
            if let latestTags = self.latestTags, latestTags.count >= 1 {
                self.tagRequireLabel.isHidden = true
                
            } else {//latestTags == nil , or count 0
                self.tagRequireLabel.isHidden = false
                isRequire = true
            }
        }
        return isRequire
    }
    
    private func timeMinText(time: Int) -> String {
        let minStr = time.textNumber(many: "minutes")
        let minUnit = minStr.replace("\(time) ", withString: "")
        return minUnit
    }
    
    private func manageTagContentViewWith(tags:[UGCTagResult]) {
        self.latestTags = tags
        if tags.isEmpty {
            self.tagView.isHidden = true
            self.tagPlaceholderLabel.text = FlashStyle.post.tagPlaceHolder
        } else {
            self.tagPlaceholderLabel.text = ""
            self.tagView.removeAllTags()
            var tagList = [String]()
            for tag in tags {
                tagList.append(tag.name)
            }
            self.tagView?.textFont = .font(13, .text)
            self.tagView?.addTags(tagList)
            
            DispatchQueue.main.async {
                self.tagView.isHidden = false
                let marginY: CGFloat = self.tagView.marginY / 2
                let paddingY: CGFloat = CGFloat(self.tagView.rows - 1) * self.tagView.paddingY
                let height: CGFloat = self.tagView.tagViewHeight
                let tagViewContentHeight:CGFloat = (CGFloat(self.tagView.rows) * height) + marginY + paddingY // 168
                ConsoleLog.show("tagViewContentHeight: \(tagViewContentHeight)")
                self.tagHeight.constant = tagViewContentHeight + 2
                
                for i in 0..<self.tagView.tagViews.count {
                    self.tagView?.tagViews[i].tag = tags[i].id
                    self.tagView?.tagViews[i].cornerRadius = CGFloat(self.tagView.tagViewHeight / 2)
                    self.tagView?.tagViews[i].clipsToBounds = true
                    self.tagView?.tagViews[i].textColor = self.tagTextColor
                    self.tagView?.tagViews[i].tagBackgroundColor = self.tagBGTextColor
                }
            }
        }
    }
    
}

extension FLPostViewController: TagListViewDelegate, TagListSelectViewControllerDelegate, UGCCatagoryListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        ConsoleLog.show("Tag : \(title), \(sender), \(tagView.tag)")
        self.tagViewPressed()
    }
    
    func tagListSelectViewController(_ tags: [UGCTagResult]) {
        print("select: \(tags.count) tag")
        self.isNeedUpdate = true
        self.tagRequireLabel.isHidden = !tags.isEmpty
        self.latestTags = tags
        self.manageTagContentViewWith(tags: tags)
    }
    
    func didSelectCategory(_ category: CategoryResult) {
        print("category: \(category.id) \(category.name)")
        self.isNeedUpdate = true
        self.selectedCategory = category
    }
}



extension FLPostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let originalImage = info[.originalImage] as? UIImage {
            let size = originalImage.size
            var newWidth: CGFloat = 1024
            if size.height > size.width {
                let ratio = size.width / size.height
                newWidth = 1024 * ratio
            }
            let img = originalImage.resizeImage(newWidth: newWidth).cropRatio(16 / 9)
            let imgData = img.jpeg ?? img.png
            guard let data = imgData else { return }
            guard let uiimage = UIImage(data: data) else { return }
            self.imageCoverData = data
            self.coverImageView.image = uiimage
            let imageBase64 = uiimage.jpegData(compressionQuality: 1)?.base64EncodedString()
            self.imageBase64 = imageBase64
            self.isNeedUpdate = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

extension FLPostViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = self.inputToolbar
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let title = text.trimmingCharacters(in: .whitespaces)
        if !title.isEmpty {
            self.viewModel.detail?.nameContent = text
            self.isNeedUpdate = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, textField == self.titleTextField {
            let currentText = text + string
            let maxCha = FlashStyle.post.maxChaTitle
            self.isNeedUpdate = true
            return currentText.count <= maxCha
         }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension FLPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.inputAccessoryView = self.inputToolbar
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        let maxLength = FlashStyle.post.maxChaDesc
        let newDesc = String(text.prefix(maxLength))
        self.descTextView.text = newDesc
        
        self.viewModel.detail?.desc = newDesc
        self.updateDescLimit(newDesc.count)
        self.isNeedUpdate = true
    }
}

