//
//  TagListSelectViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 7/9/2564 BE.
//

import UIKit

protocol TagListSelectViewControllerDelegate: AnyObject {
    func tagListSelectViewController(_ tags: [UGCTagResult])
}

class TagListSelectViewController: UIViewController {

    @IBOutlet private weak var tagView: TagListView!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var tagHeight: NSLayoutConstraint!
    @IBOutlet private weak var doneButton: UIButton!
    
    var viewModel = TagListViewModel()
    
    var delegate: TagListSelectViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reset = UIBarButtonItem(title: "reset".localized(), style: .plain, target: self, action: #selector(self.resetPressed))

        self.navigationItem.rightBarButtonItems = [reset]
        self.totalLabel.font = UIFont.font(14, .text)
        self.totalLabel.textColor = .text75()
        self.tagView.delegate = self
        let margin:CGFloat = UIDevice.isIpad() ? 24 : 8
        self.tagView.paddingX = margin
        self.tagView.paddingY = margin
        self.tagView.tagLineBreakMode = .byTruncatingTail
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showLoading(nil)
        self.viewModel.callAPITagList { (list) in
            self.manageTagContentViewWith(tags: list)
        }
    }
    
    private func loadMore() {
        self.manageTagContentViewWith(tags: self.viewModel.tagList)
    }
    
    @objc private func resetPressed() {
        for tag in self.viewModel.tagList {
            tag.isSelected = false
        }
        self.manageTagContentViewWith(tags: self.viewModel.tagList)
    }
    
    @IBAction private func donePressed() {
        let selectList = self.viewModel.tagList.filter { (tag) -> Bool in
            return tag.isSelected
        }
        print("selectList: \(selectList.count)")
        self.delegate?.tagListSelectViewController(selectList)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func countSelectedList(_ tags:[UGCTagResult]) {
        let selectList = tags.filter { (tag) -> Bool in
            return tag.isSelected
        }
        let value = selectList.count.textNumber(many: "selected")
        let totalText =  "\("total".localized()) \(value)"
        self.totalLabel.text =  totalText
    }
    
    private func manageTagContentViewWith(tags:[UGCTagResult]) {
        self.countSelectedList(tags)
        //may improve pagination with collectionView
        if tags.isEmpty {
            self.tagView.isHidden = true
            
        } else {
            self.tagView?.removeAllTags()
            var tagList = [String]()
            for tag in tags {
                let select = self.viewModel.selectTagId.first {$0 == tag.id}
                let isSelected = select != nil
                tag.isSelected = isSelected
                
                tagList.append(tag.name)
            }
            
            self.tagView?.textFont = UIFont.font(13, .text)
            self.tagView?.addTags(tagList)
            DispatchQueue.main.async {
                self.tagView.isHidden = false
                let marginY: CGFloat = self.tagView.marginY / 2
                let paddingY: CGFloat = CGFloat(self.tagView.rows - 1) * self.tagView.paddingY
                let tagViewContentHeight:CGFloat = (CGFloat(self.tagView.rows) * self.tagView.tagViewHeight) + marginY + paddingY // 168
                ConsoleLog.show("tagViewContentHeight: \(tagViewContentHeight)")
                self.tagHeight.constant = tagViewContentHeight + 2
                
                for i in 0..<self.tagView.tagViews.count {
                    let tagId = tags[i].id
                    let isSelected = tags[i].isSelected
                    self.tagView?.tagViews[i].tag = tagId
                    self.tagView?.tagViews[i].cornerRadius = CGFloat(self.tagView.tagViewHeight / 2)
                    self.tagView?.tagViews[i].borderWidth = 1
                    self.tagView?.tagViews[i].clipsToBounds = true
                    self.tagView?.tagViews[i].tagBackgroundColor = isSelected ? tagBgEnableColor : .white
                    self.tagView?.tagViews[i].textColor = tagTextEnableColor
                    self.tagView?.tagViews[i].borderColor = isSelected ? .clear : tagTextEnableColor
                }
            }
        }
        self.viewModel.selectTagId.removeAll()
        self.hideLoading()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TagListSelectViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        ConsoleLog.show("Tag : \(title), \(sender), \(tagView.tag)")
        let id = tagView.tag
        let tagList = self.viewModel.tagList.filter { (tag) -> Bool in
            return tag.id == id
        }
        guard let selectTag = tagList.first else { return }
        let isSelected = !selectTag.isSelected
        selectTag.isSelected = isSelected
        tagView.tagBackgroundColor = isSelected ? tagBgEnableColor : .white
        tagView.textColor = tagTextEnableColor
        tagView.borderColor = isSelected ? .clear : tagTextEnableColor
        
        self.countSelectedList(self.viewModel.tagList)
    }
}


