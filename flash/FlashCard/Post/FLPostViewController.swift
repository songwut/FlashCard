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
            let _ = self.viewModel.detail
        }
    }
    
    private var imageBase64:String?
    private var time = 1
    private var imageCoverData: Data?
    private let formatText = "d MMM yyyy HH:mm"
    private var isNeedUpdate = false
    
    private var editBtn = UIBarButtonItem()
    private var previewBtn = UIBarButtonItem()
    
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
    
    private func updateTitleLimit(_ count: Int) {
        let maxLength = FlashStyle.post.maxChaTitle
        self.titleLimitLabel.text = "\(count)/\(maxLength) Characters Limit"
    }
    
    var selectedCategory: CategoryResult? {
        didSet {
            self.isNeedUpdate = true
            guard let category = self.selectedCategory else { return  }
            self.categoryValueLabel.text = category.name
            self.categoryValueLabel.textColor = .text()
            self.isNeedUpdate = true
        }
    }
    
    var latestTags: [UGCTagResult]? {
        didSet {
            self.isNeedUpdate = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardManager(false)
        self.footerView.setShadow(radius: 16, opacity: 0.09, color: .black, offset: CGSize(width: 0, height: -2))
        let fontTitle = UIFont.font(16, .medium)
        let fontValue = UIFont.font(16, .text)
        self.titleTextField.delegate = self
        self.titleTextField.addTarget(self, action: #selector(self.titleTextFieldChange(_:)), for: .editingChanged)
        self.coverImageView.cornerRadius = 8
        self.titleLimitLabel.font = .font(12, .text)
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
        self.requestLabel.font = fontTitle
        self.requesDesc.font = .font(10, .medium)
        self.requesDesc.textColor = .text75()
        self.requesIcon.image = UIImage(named: "info")
        self.requesIcon.tintColor = .config_secondary_50()
        self.categoryView.isUserInteractionEnabled = true
        self.tagContentView.isUserInteractionEnabled = true
        
        let tapCategory = UITapGestureRecognizer(target: self, action: #selector(self.categoryPressed))
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
        self.submitButton.isHidden = false
        self.cancelButton.isHidden = true
        self.coverImageView.image = nil
        self.imageButton.backgroundColor = UIColor.elementBackground()
        
        self.serDefaultUI()
        
        if self.createStatus == .new {
            guard let profile = UserManager.shared.profile else { return }
            self.showLoading(nil)
            self.viewModel.callAPINewFlashCard(profile: profile) { [weak self] (newDetail) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    guard let detail = newDetail else { return }
                    self.viewModel.flashId = detail.id
                    self.loadDetail(detail)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewModel.detail?.name = self.titleTextField.text ?? ""
        self.viewModel.detail?.desc = self.descTextView.text ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        editBtn = UIBarButtonItem(image: UIImage(named: "ic_v2_edit"), style: .plain, target: self, action: #selector(self.editPressed))
        previewBtn = UIBarButtonItem(image: UIImage(named: "ic_v2_preview"), style: .plain, target: self, action: #selector(self.previewPressed))
        editBtn.tintColor = headerTextColor
        previewBtn.tintColor = headerTextColor
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [previewBtn, editBtn]
        
        if self.createStatus == .edit {
            if let detail = self.viewModel.detail {
                self.loadDetail(detail)
            } else {
                self.showLoading(nil)
                self.callAPIFlashDetail()
            }
        }
    }
    
    func serDefaultUI() {
        self.titleTextField.text = ""
        self.descTextView.text = ""
        self.updateValueLabel.text = ""
        self.categoryValueLabel.text = ""
        self.updateValueLabel.text = ""
        self.idView.isHidden = true
    }
    
    func loadDetail(_ detail: FLDetailResult?) {
        self.hideLoading()
        guard let detail = detail else { return }
        self.time = detail.estimateTime
        
        self.titleTextField.text = detail.nameContent
        self.updateTitleLimit(detail.nameContent.count)
        
        self.descTextView.text = detail.desc
        
        if let imageCoverData = self.imageCoverData,
           let uiimage = UIImage(data: imageCoverData) {
            self.coverImageView.image = uiimage
        } else {
            self.coverImageView.setImage(detail.image, placeholderImage: defaultCoverFlash)
        }
        
        self.ownerValueLabel.text = detail.owner?.name ?? ""
        
        self.categoryValueLabel.text = self.getCatagoryName(detail)
        let dateTime = formatter.with(dateFormat: formatText, dateString: detail.datetimeUpdate)
        self.updateValueLabel.text = dateTime
        self.timeValueLabel.text = "\(self.time)"
        let minStr = self.time.textNumber(many: "minutes")
        let minUnit = minStr.replace("\(self.time) ", withString: "")
        self.timeMinLabel.text = minUnit
        self.idView.isHidden = detail.code == ""
        self.idValueLabel.text = detail.code
        self.idValueLabel.textColor = detail.contentCode.getColor()
        self.idView.borderColor = detail.contentCode.getColor()
        self.statusValueLabel.text = detail.displayStatus.title()
        self.minusButton.isEnabled = !(self.time == 1)
        
        let requestStatus = detail.requestStatus
        self.requesValue.backgroundColor = requestStatus.bgColor()
        self.requesValue.setTitleColor(requestStatus.color(), for: .normal)
        self.requesValue.setTitle(detail.contentRequest?.statusLabel.localized() ?? "", for: .normal)
        self.requesDesc.text = requestStatus.desc()
        self.statusPin.backgroundColor = detail.displayStatus.color()
        self.requestStackView.isHidden = detail.contentRequest == nil
        
        let rightBarButtonItems = (requestStatus == .completed) ? [previewBtn] : [previewBtn, editBtn]
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems = rightBarButtonItems
        
        if requestStatus == .completed  {
            self.submitButton.backgroundColor = .disable()
            self.submitButton.isUserInteractionEnabled = false
            self.submitButton.isHidden = false
            self.cancelButton.isHidden = true
            
        } else if requestStatus == .requestExpired ||  requestStatus == .reject  {
            self.submitButton.backgroundColor = .config_primary()
            self.submitButton.isUserInteractionEnabled = true
            self.submitButton.isHidden = false
            self.cancelButton.isHidden = true
            
        } else if requestStatus == .waitForApprove {
            self.cancelButton.backgroundColor = .config_primary()
            self.cancelButton.isUserInteractionEnabled = true
            self.submitButton.isHidden = true
            self.cancelButton.isHidden = false
            
        } else {
            self.submitButton.isHidden = false
            self.cancelButton.isHidden = true
            self.requestStackView.isHidden = true
        }
        
        
        if detail.requestStatus == .waitForApprove
            || detail.requestStatus == .completed {
            self.enableUI(isEnable: false)
        } else {
            self.enableUI(isEnable: true)
        }
        
        self.manageTagContentViewWith(tags: latestTags ?? detail.tagList)
    }
    
    private func enableUI(isEnable: Bool) {
        let disableColor = UIColor.disable()
        let textColor = UIColor.text()
        imageButton.isUserInteractionEnabled = isEnable
        titleTextField.isEnabled = isEnable
        titleTextField.textColor = isEnable ? textColor : disableColor
        descTextView.isUserInteractionEnabled = isEnable
        descTextView.textColor = isEnable ? textColor : disableColor
        timeValueLabel.textColor = isEnable ? textColor : disableColor
        plusButton.isEnabled = isEnable
        minusButton.isEnabled = isEnable
        plusButton.tintColor = isEnable ? .config_primary() : disableColor
        minusButton.tintColor = isEnable ? .config_primary() : disableColor
        categoryValueLabel.textColor = isEnable ? textColor : disableColor
        categoryButton.isEnabled = isEnable
        categoryView.isUserInteractionEnabled = isEnable
        
        tagButton.isEnabled = isEnable
        tagContentView.isUserInteractionEnabled = isEnable
        tagView.isUserInteractionEnabled = isEnable
        tagView.tagBackgroundColor = isEnable ? tagBgEnableColor : .text(0.1)
        tagView.textColor = isEnable ? tagBgEnableColor : .text()
        tagView.borderColor = .clear
        tagView.borderWidth = 1
    }
    
    private func getCatagoryName(_ detail: FLDetailResult) -> String {
        var categoryText: String?
        
        if let selectedCategory = self.selectedCategory {
            categoryText = selectedCategory.name
            
        } else if let category = detail.category {
            categoryText = category.name
            
        }
        return categoryText ?? FlashStyle.post.categoryPlaceHolder
    }
    
    @IBAction func timePlusPressed(_ sender: UIButton) {
        self.time = self.time + 1
        self.minusButton.isEnabled = !(self.time == 1)
        self.timeValueLabel.text = "\(self.time)"
        self.viewModel.detail?.estimateTime = self.time
        self.isNeedUpdate = true
        ConsoleLog.show("timeNumber: \(self.time)")
    }
    
    @IBAction func timeMinusPressed(_ sender: UIButton) {
        
        self.time = self.time - 1
        self.minusButton.isEnabled = !(self.time == 1)
        self.timeValueLabel.text = "\(self.time)"
        self.viewModel.detail?.estimateTime = self.time
        self.isNeedUpdate = true
        ConsoleLog.show("timeNumber: \(self.time)")
    }
    
    @objc func editPressed() {
        self.callAPIFlashDetailUpdate()
        if let flEditorVC = self.navigationController?.viewControllers.last as? FLEditorViewController {
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
    }
    
    @objc func previewPressed() {
        self.callAPIFlashDetailUpdate()
        
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
        self.view.endEditing(true)
        self.viewModel.callAPICategoryList { (categoryPageResult) in
            guard let categoryPage = categoryPageResult else { return }
            var categoryView = UGCCatagoryListView(items: categoryPage.list) { category in
                print("UGCCatagoryListView: select: \(category.name)")
                self.selectedCategory = category
            }
            //categoryView.delegate = self
            let host = UIHostingController(rootView: categoryView)
            if let nav = self.navigationController {
                nav.pushViewController(host, animated: true)
            } else {
                self.present(host, animated: true, completion: nil)
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
        let detail = self.viewModel.detail!
        self.openPopupWith(detail: detail)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        let detail = self.viewModel.detail!
        self.openPopupWith(detail: detail)
    }
    
    func openPopupWith(detail: FLDetailResult) {
        let detail = self.viewModel.detail!
        var desc = "confirm_submit_material".localized()
        if detail.requestStatus == .completed {
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
        if requestStatus == .completed {
            self.callAPIFlashDetailCancel()
            
        } else if requestStatus == .none {
            self.callAPIFlashDetailUpdate()
        }
    }
    
    func callAPIFlashDetail() {
        self.viewModel.callAPIFlashDetail(.get) { [weak self] (detail) in
            DispatchQueue.main.async {
                self?.loadDetail(detail)
            }
        }
    }
    
    func callAPIFlashDetailUpdate() {
        if self.isNeedUpdate {
            let json = self.createJSON()
            ConsoleLog.show("callAPIFlashDetailUpdate")
            self.viewModel.callAPIFlashDetailUpdate(parameter: json) { [weak self] (updatedDetail) in
                self?.isNeedUpdate = false
                self?.createStatus = .edit//reset to edit
                self?.loadDetail(updatedDetail)
                self?.callAPIFlashDetailSubmit()
            }
        }
    }
    
    func callAPIFlashDetailSubmit() {
        self.viewModel.callAPIFlashDetailSubmit { [weak self] (detail) in
            self?.viewModel.detail?.contentRequest?.status = .completed
            self?.viewModel.detail?.displayStatus = .unpublish//mock
            self?.loadDetail(detail)
            
            self?.callAPIFlashDetail()
        }
    }
    
    func callAPIFlashDetailCancel() {
        self.viewModel.callAPIFlashDetailCancel { [weak self]  (detail) in
            self?.loadDetail(detail)
        }
    }
    
    func createJSON() -> [String: Any]? {
        let detail = self.viewModel.detail!
        
        var dict = [String: Any]()
        
        var tags = [Int]()
        if let latestTags = latestTags {
            for tag in latestTags {
                tags.append(tag.id)
            }
        }
        
        dict["name_content"] = self.titleTextField.text
        dict["desc"] = self.descTextView.text
        dict["duration"] = self.time
        //dict["code"] = detail.code
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
        
        let myMaterialListView = self.navigationController!.viewControllers.first { $0.className.contains(find: "MyMaterialListView") }
        if let targetVC = myMaterialListView {
            //case create new in MyMaterialListView
            self.navigationController?.popToViewController(targetVC, animated: true)
        } else {
            //case create new in MyLibraryViewController
            let myLibraryVC = self.navigationController!.viewControllers.first { $0.className.contains(find: "MyLibraryViewController") }
            if let targetVC = myLibraryVC {
                self.navigationController?.popToViewController(targetVC, animated: true)
            }
        }
    }
    
    private func manageTagContentViewWith(tags:[UGCTagResult]) {
        
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
        self.latestTags = tags
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
            let img = originalImage.resizeImage(newWidth: newWidth).cropRatio(16 / 9)
            let imgData = img.jpeg ?? img.png
            guard let data = imgData else { return }
            guard let uiimage = UIImage(data: data) else { return }
            self.imageCoverData = data
            self.coverImageView.image = uiimage
            let imageBase64 = uiimage.jpegData(compressionQuality: 1)?.base64EncodedString()
            self.imageBase64 = imageBase64
            let imageSize: Int = data.count
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
        self.viewModel.detail?.name = text
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text, textField == self.titleTextField {
            let currentText = text + string
            let maxCha = FlashStyle.post.maxChaTitle
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        self.viewModel.detail?.desc = text
    }
}

