//
//  FLPostViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 8/9/2564 BE.
//

import UIKit
import SwiftUI

final class FLPostViewController: UIViewController, NibBased, ViewModelBased {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var imageButton: UIButton!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var titleLimitLabel: UILabel!
    
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var idValueLabel: UILabel!
    
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var descTextView: UITextView!
    
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
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var myLibraryButton: UIButton!
    
    var viewModel: FLPostViewModel! {
        didSet {
            let detail = self.viewModel.detail
            detail.status = .waitForApprove
        }
    }
    
    var latestTags: [UGCTagResult]?
    
    deinit {
        ConsoleLog.show("complete removed : FLPostViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryView.isUserInteractionEnabled = true
        self.tagContentView.isUserInteractionEnabled = true
        
        let tapCategory = UITapGestureRecognizer(target: self, action: #selector(self.categoryPressed))
        self.categoryView.addGestureRecognizer(tapCategory)
        
        let tapTag = UITapGestureRecognizer(target: self, action: #selector(self.tagViewPressed))
        self.tagContentView.addGestureRecognizer(tapTag)
        self.tagContentView.updateLayout()
        self.tagView.updateLayout()
        self.tagView.delegate = self
        self.tagView.tagLineBreakMode = .byTruncatingTail
        
        self.submitButton.isHidden = false
        self.cancelButton.isHidden = true
        self.coverImageView.image = UIImage(named: "flash-cover")
        self.imageButton.backgroundColor = ColorHelper.elementBackground()
        self.loadDetail(self.viewModel.detail)
    }
    
    func loadDetail(_ detail: FLDetailResult) {
        if detail.status == .unpublish {
            self.submitButton.isHidden = false
            self.cancelButton.isHidden = true
        } else if detail.status == .waitForApprove  {
            self.submitButton.isHidden = true
            self.cancelButton.isHidden = false
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
        let detail = self.viewModel.detail
        self.openPopupWith(status: detail.status)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        let detail = self.viewModel.detail
        self.openPopupWith(status: detail.status)
    }
    
    func openPopupWith(status: FLStatus) {
        let detail = self.viewModel.detail
        var desc = "Do you confirm to submit this material?"
        if status == .waitForApprove {
            desc = "Do you confirm to cancel the request?"
        }
        
        let confirm = ActionButton(
            title: "confirm".localized(),
            action: Action(handler: { (sender) in
                self.callApiPost(status)
            })
        )
        PopupManager.showWarning(desc, confirm: confirm, at: self)
    }
    
    func callApiPost(_ status: FLStatus) {
        self.viewModel.callAPIDetail(.post, status: status) {
            
        }
        print("submit confirm")
    }
    
    @IBAction func myLibraryPressed(_ sender: UIButton) {
        //TODO: dismiss and back to my library
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func manageTagContentViewWith(tags:[UGCTagResult]) {
        
        if tags.isEmpty {
            self.tagView.isHidden = true
        } else {
            self.tagView.removeAllTags()
            var tagList = [String]()
            for tag in tags {
                tagList.append(tag.name)
            }
            self.tagView?.textFont = FontHelper.getFontSystem(13, font: .text)
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

extension FLPostViewController: TagListViewDelegate, TagListSelectViewControllerDelegate {
    
    //TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        ConsoleLog.show("Tag : \(title), \(sender), \(tagView.tag)")
        self.tagViewPressed()
    }
    
    func tagListSelectViewController(_ tags: [UGCTagResult]) {
        print("select: \(tags.count) tag")
        self.manageTagContentViewWith(tags: tags)
    }
}


extension FLPostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let originalImage = info[.originalImage] as? UIImage {
            let size = originalImage.size
            var newWidth: CGFloat = 1024
            if size.height > size.width {// 3000, 2000
                let ratio = size.width / size.height
                newWidth = 1024 * ratio
            }
            let img = originalImage.resizeImage(newWidth: newWidth)
            let imgData = img.jpeg ?? img.png
            guard let data = imgData else { return }
            var imageSize: Int = data.count
            print("actual size of image in KB: %f ", Double(imageSize) / 1024.0)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
