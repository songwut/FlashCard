//
//  FLPostViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 8/9/2564 BE.
//

import UIKit
import SwiftUI
import GrowingTextView

final class FLPostViewController: UIViewController, NibBased, ViewModelBased {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var imageButton: UIButton!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var titleLimitLabel: UILabel!
    
    @IBOutlet private weak var idView: UIView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var idValueLabel: UILabel!
    
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var descTextView: GrowingTextView!
    
    @IBOutlet private weak var ownerLabel: UILabel!
    @IBOutlet private weak var ownerValueLabel: UILabel!
    @IBOutlet private weak var updateLabel: UILabel!
    @IBOutlet private weak var updateValueLabel: UILabel!
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var timeValueLabel: UILabel!
    @IBOutlet private weak var timeMinLabel: UILabel!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var plusButton: UIButton!
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var categoryView: UIView!
    @IBOutlet private weak var categoryValueLabel: UILabel!
    @IBOutlet private weak var categoryButton: UIButton!
    
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var tagPlaceholderLabel: UILabel!
    @IBOutlet private weak var tagContentView: UIView!
    @IBOutlet private weak var tagButton: UIButton!
    @IBOutlet private weak var tagView: TagListView!
    @IBOutlet private weak var tagHeight: NSLayoutConstraint!
    
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
    @IBOutlet private weak var myLibraryButton: UIButton!
    
    var createStatus:FLCreateStatus = .new
    
    var viewModel: FLFlashCardViewModel! {
        didSet {
            let detail = self.viewModel.detail
            //detail.status = .waitForApprove //mock
        }
    }
    
    var latestTags: [UGCTagResult]?
    private var imageBase64:String?
    private var time = 1
    private var imageCoverData: Data?
    private let formatText = "d MMM yyyy HH:mm"
    
    deinit {
        ConsoleLog.show("complete removed : FLPostViewController")
    }
    
    @objc func titleTextFieldChange(_ textField: UITextField) {
        if let text = textField.text {
            let maxCha = FlashStyle.post.maxChaTitle
            textField.text = String(text.prefix(maxCha))
        }
    }
    
    var selectedCategory: CategoryResult? {
        didSet {
            guard let category = self.selectedCategory else { return  }
            self.categoryValueLabel.text = category.name
            self.categoryValueLabel.textColor = .text()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.footerView.setShadow(radius: 16, opacity: 0.09, color: .black, offset: CGSize(width: 0, height: -2))
        let fontTitle = UIFont.font(16, .text)
        let fontValue = UIFont.font(16, .text)
        let maxChaTitle = FlashStyle.post.maxChaTitle
        self.titleTextField.delegate = self
        //self.titleTextField.addTarget(self, action: #selector(self.titleTextFieldChange(_:)), for: .editingChanged)
        self.coverImageView.cornerRadius = 8
        self.titleLimitLabel.text = "0/\(maxChaTitle) Characters Limit"
        self.titleLimitLabel.font = FontHelper.getFontSystem(12, font: .text)
        self.titleTextField.font = fontValue
        self.titleTextField.textColor = .text()
        self.idView.borderWidth = 1
        self.idView.cornerRadius = 9
        self.idLabel.font = fontTitle
        self.idValueLabel.font = UIFont.font(14, .text)
        self.descLabel.font = fontTitle
        self.descTextView.borderWidth = 1
        self.descTextView.borderColor = UIColor("A9A9A9")
        self.descTextView.backgroundColor = .white
        self.descTextView.placeholder = FlashStyle.post.descPlaceHolder
        self.descTextView.placeholderColor = .text25()
        self.descTextView.textColor = .text()
        self.descTextView.font = fontValue
        self.ownerLabel.font = fontTitle
        self.ownerValueLabel.font = fontValue
        self.ownerValueLabel.textColor = .text()
        self.updateLabel.font = fontTitle
        self.updateValueLabel.font = fontValue
        self.updateValueLabel.textColor = .text()
        self.timeLabel.font = fontTitle
        self.timeMinLabel.font = fontTitle
        self.timeMinLabel.text = "minutes".localized()
        self.timeValueLabel.font = fontValue
        self.categoryLabel.font = fontTitle
        self.categoryValueLabel.text = FlashStyle.post.categoryPlaceHolder
        self.categoryValueLabel.textColor = .text25()
        self.categoryValueLabel.font = fontValue
        self.tagLabel.font = fontTitle
        self.tagPlaceholderLabel.font = fontValue
        self.tagPlaceholderLabel.text = FlashStyle.post.tagPlaceHolder
        self.tagPlaceholderLabel.textColor = .text25()
        self.statusLabel.font = fontTitle
        self.statusValueLabel.font = fontValue
        self.idView.backgroundColor = .clear
        self.requesDesc.font = .font(10, .medium)
        self.requesDesc.textColor = .text75()
        self.categoryView.isUserInteractionEnabled = true
        self.tagContentView.isUserInteractionEnabled = true
        
        let tapCategory = UITapGestureRecognizer(target: self, action: #selector(self.categoryPressed))
        self.categoryView.addGestureRecognizer(tapCategory)
        
        let tapTag = UITapGestureRecognizer(target: self, action: #selector(self.tagViewPressed))
        self.tagContentView.addGestureRecognizer(tapTag)
        self.tagContentView.updateLayout()
        self.tagContentView.backgroundColor = .white
        self.tagView.updateLayout()
        self.tagView.delegate = self
        self.tagView.tagLineBreakMode = .byTruncatingTail
        
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.isHidden = false
        self.cancelButton.isHidden = true
        self.coverImageView.image = UIImage(named: "flash-cover")
        self.imageButton.backgroundColor = UIColor.elementBackground()
        
        self.serDefaultUI()
        
        if self.createStatus == .new {
            guard let profile = UserManager.shared.profile else { return }
            self.showLoading(nil)
            self.viewModel.callAPINewFlashCard(profile: profile) { [weak self] (detail) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    guard let detail = detail else { return }
                    self.viewModel.flashId = detail.id
                    self.loadDetail(detail)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let editBtn = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(self.editPressed))
        let previewBtn = UIBarButtonItem(image: UIImage(named: "ic_v2_preview"), style: .plain, target: self, action: #selector(self.previewPressed))
        editBtn.tintColor = .white
        previewBtn.tintColor = .white
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [previewBtn, editBtn]
        
        if self.createStatus == .edit {
            if let detail = self.viewModel.detail {
                self.loadDetail(detail)
            } else {
                self.showLoading(nil)
                self.viewModel.callAPIFlashDetail(.get) { [weak self] (detail) in
                    DispatchQueue.main.async {
                        self?.loadDetail(detail)
                    }
                }
            }
        }
    }
    
    func serDefaultUI() {
        self.titleTextField.text = ""
        self.descTextView.text = ""
        self.updateValueLabel.text = ""
        self.categoryValueLabel.text = ""
        self.updateValueLabel.text = ""//TODO: show
        self.idView.isHidden = true
    }
    
    func loadDetail(_ detail: FLDetailResult?) {
        self.createStatus = .edit//reset to edit
        self.hideLoading()
        guard let detail = detail else { return }
        self.time = detail.estimateTime ?? 5 //TODO: get real time
        self.titleTextField.text = detail.name
        self.descTextView.text = detail.desc
        if let owner = detail.owner {
            self.ownerValueLabel.text = owner.name
        }
        let dateTime = formatter.with(dateFormat: formatText, dateString: detail.datetimeUpdate)
        self.updateValueLabel.text = dateTime
        self.timeValueLabel.text = "\(self.time)"
        self.idView.isHidden = detail.code == ""
        self.idValueLabel.text = detail.code
        self.idValueLabel.textColor = detail.contentCode.getColor()
        self.idView.borderColor = detail.contentCode.getColor()
        self.statusValueLabel.text = detail.status.title()
        self.minusButton.isEnabled = !(self.time == 1)
        
        if detail.requestStatus == .completed  {
            self.submitButton.backgroundColor = .disable()
            self.submitButton.isUserInteractionEnabled = false
            self.submitButton.isHidden = true
            self.cancelButton.isHidden = false
        } else if detail.requestStatus == .waitForApprove  {
            self.submitButton.backgroundColor = .config_primary()
            self.submitButton.isUserInteractionEnabled = true
            self.submitButton.isHidden = true
            self.cancelButton.isHidden = false
        } else {
            self.submitButton.isHidden = false
            self.cancelButton.isHidden = true
        }
        
        
        let isEnable = detail.status == .unpublish
        let disableColor = UIColor.disable()
        let textColor = UIColor.text()
        titleTextField.isEnabled = isEnable
        titleTextField.textColor = isEnable ? textColor : disableColor
        descTextView.isEditable = isEnable
        descTextView.textColor = isEnable ? textColor : disableColor
        timeValueLabel.textColor = isEnable ? textColor : disableColor
        plusButton.isEnabled = isEnable
        minusButton.isEnabled = isEnable
        plusButton.tintColor = isEnable ? UIColor.config_primary() : disableColor
        minusButton.tintColor = isEnable ? UIColor.config_primary() : disableColor
        categoryView.isUserInteractionEnabled = isEnable
        categoryValueLabel.textColor = isEnable ? .text25() : disableColor
        categoryButton.isEnabled = isEnable
        tagButton.isEnabled = isEnable
        tagContentView.isUserInteractionEnabled = isEnable
        tagView.isUserInteractionEnabled = isEnable
        statusPin.backgroundColor = detail.status.color()
        
    }
    
    @IBAction func timePlusPressed(_ sender: UIButton) {
        self.time = self.time + 1
        self.minusButton.isEnabled = !(self.time == 1)
        self.timeValueLabel.text = "\(self.time)"
        ConsoleLog.show("timeNumber: \(self.time)")
    }
    
    @IBAction func timeMinusPressed(_ sender: UIButton) {
        
        self.time = self.time - 1
        self.minusButton.isEnabled = !(self.time == 1)
        self.timeValueLabel.text = "\(self.time)"
        ConsoleLog.show("timeNumber: \(self.time)")
    }
    
    @objc func editPressed() {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLEditorViewController") as! FLEditorViewController
        vc.createStatus = .edit
        vc.viewModel =  self.viewModel
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func previewPressed() {
        let s = UIStoryboard(name: "FlashUserDisplay", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLPlayerViewController") as! FLPlayerViewController
        vc.playerState = .user
        vc.viewModel =  self.viewModel
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true) {
            
        }
        
//        if let nav = self.navigationController {
//            nav.pushViewController(vc, animated: true)
//        } else {
//            self.present(vc, animated: true, completion: nil)
//        }
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
    
    @objc func categoryPressed() {
        JSON.read("ugc-flash-card-category") { (object) in
            if let dictList = object as? [[String : Any]],
               let detail = UGCCategoryPageResult(JSON: ["results": dictList]) {
                let mockList = detail.list
                var categoryView = UGCCatagoryListView(items: mockList) { category in
                    print("UGCCatagoryListView: select: \(category.name)")
                }
                categoryView.delegate = self
                let host = UIHostingController(rootView: categoryView)
                if let nav = self.navigationController {
                    nav.pushViewController(host, animated: true)
                } else {
                    self.present(host, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func tagViewPressed() {
        if let tagList = self.latestTags {
            self.openTagListVC(tags: tagList)
        } else {
            //TODO: use real api
            self.latestTags = nil
            JSON.read("ugc-flash-card-tag-list") { (object) in
                if let dict = object as? [String : Any],
                   let detail = UGCTagPageResult(JSON: dict) {
                    let mockList = detail.list
                    self.latestTags = mockList
                    self.openTagListVC(tags: mockList)
                }
            }
        }
    }
    
    func openTagListVC(tags:[UGCTagResult]) {
        let tagListVC = TagListSelectViewController()
        tagListVC.tagList = tags
        tagListVC.delegate = self
        if let nav = self.navigationController {
            nav.pushViewController(tagListVC, animated: true)
        } else {
            self.present(tagListVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        let detail = self.viewModel.detail!
        self.openPopupWith(detail: detail)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        let detail = self.viewModel.detail!
        self.openPopupWith(detail: detail)
    }
    
    func openPopupWith(detail: FLDetailResult) {
        let detail = self.viewModel.detail
        var desc = "Do you confirm to submit this material?"
        if detail?.requestStatus == .waitForApprove {
            desc = "Do you confirm to cancel the request?"
        }
        
        let confirm = ActionButton(
            title: "confirm".localized(),
            action: Action(handler: { [weak self] (sender) in
                self?.callApiPost(requestStatus: .waitForApprove)
            })
        )
        PopupManager.showWarning(desc, confirm: confirm, at: self)
    }
    
    func callApiPost(requestStatus: RequestStatus) {
        //TODO: patch + send approve
        
        self.callAPIFlashDetailUpdate()
        
        //mock
        self.viewModel.detail?.status = .unpublish
        self.viewModel.detail?.requestStatus = requestStatus
        self.loadDetail(self.viewModel.detail)
        
    }
    
    func callAPIFlashDetailUpdate() {
        let json = self.createJSON()
        self.viewModel.callAPIFlashDetailUpdate(parameter: json) { (newDetail) in
            
        }
    }
    
    func createJSON() -> [String: Any]? {
        let detail = self.viewModel.detail!
        var dict = [String: Any]()
        
        var tags = [String]()
        if let latestTags = latestTags {
            for tag in latestTags {
                tags.append(tag.name)
            }
        }
        
        dict["name"] = self.titleTextField.text
        dict["desc"] = self.descTextView.text
        dict["code"] = detail.code
        dict["created_by"] = detail.owner?.id ?? UserManager.shared.profile.id
        
        if let imageBase64 = self.imageBase64 {
            dict["image"] = imageBase64
        }
        if let category = self.selectedCategory {
            dict["category"] = category.id
        }
        
        dict["tag_list"] = tags
        dict["is_display"] = true
        
        //may next phase
        //dict["provider"] =
        //dict["instructor_list"] =
        return dict
    }
    
    @IBAction func myMaterialPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func manageTagContentViewWith(tags:[UGCTagResult]) {
        
        if tags.isEmpty {
            self.tagView.isHidden = true
        } else {
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
                    let isSelected = tags[i].isSelected
                    self.tagView?.tagViews[i].tag = tags[i].id
                    self.tagView?.tagViews[i].cornerRadius = 15
                    self.tagView?.tagViews[i].borderWidth = 1
                    self.tagView?.tagViews[i].clipsToBounds = true
                    self.tagView?.tagViews[i].tagBackgroundColor = isSelected ? tagBgEnableColor : .white
                    self.tagView?.tagViews[i].textColor = tagTextEnableColor
                    self.tagView?.tagViews[i].borderColor = isSelected ? .clear : tagTextEnableColor
                }
            }
        }
    }
    
}

extension FLPostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text, textField == self.titleTextField {
            let currentText = text + string
            let maxCha = FlashStyle.post.maxChaTitle
            return currentText.count <= maxCha
         }
        return true
    }
}

extension FLPostViewController: TagListViewDelegate, TagListSelectViewControllerDelegate, UGCCatagoryListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        ConsoleLog.show("Tag : \(title), \(sender), \(tagView.tag)")
        self.tagViewPressed()
    }
    
    func tagListSelectViewController(_ tags: [UGCTagResult]) {
        print("select: \(tags.count) tag")
        self.manageTagContentViewWith(tags: tags)
    }
    
    func didSelectCategory(_ category: CategoryResult) {
        print("category: \(category.id) \(category.name)")
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
            let img = originalImage.resizeImage(newWidth: newWidth)
            let imgData = img.jpeg ?? img.png
            guard let data = imgData else { return }
            guard let uiimage = UIImage(data: data) else { return }
            self.imageCoverData = data
            self.coverImageView.image = uiimage
            let imageBase64 = uiimage.jpegData(compressionQuality: 1)?.base64EncodedString()
            self.imageBase64 = imageBase64
            let imageSize: Int = data.count
            print("actual size of image in KB: %f ", Double(imageSize) / 1024.0)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
