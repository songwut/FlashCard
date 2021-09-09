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
    
    var delegate: TagListSelectViewControllerDelegate?
    var tagList = [UGCTagResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reset = UIBarButtonItem(title: "reset".localized(), style: .plain, target: self, action: #selector(self.resetPressed))

        self.navigationItem.rightBarButtonItems = [reset]
        self.totalLabel.font = FontHelper.getFontSystem(14, font: .text)
        self.totalLabel.textColor = ColorHelper.text75()
        self.tagView.delegate = self
        self.tagView.tagLineBreakMode = .byTruncatingTail
        self.manageTagContentViewWith(tags: self.tagList)
    }
    
    private func loadMore() {
        self.manageTagContentViewWith(tags: self.tagList)
    }
    
    @objc private func resetPressed() {
        for tag in self.tagList {
            tag.isSelected = false
        }
        self.manageTagContentViewWith(tags: self.tagList)
    }
    
    @IBAction private func donePressed() {
        let selectList = self.tagList.filter { (tag) -> Bool in
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
        
        if tags.isEmpty {
            self.tagView.isHidden = true
            
        } else {
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
                let tagViewContentHeight:CGFloat = (CGFloat(self.tagView.rows) * self.tagView.tagViewHeight) + marginY + paddingY // 168
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
        let tagList = self.tagList.filter { (tag) -> Bool in
            return tag.id == id
        }
        guard let selectTag = tagList.first else { return }
        let isSelected = !selectTag.isSelected
        selectTag.isSelected = isSelected
        tagView.tagBackgroundColor = isSelected ? tagBgEnableColor : .white
        tagView.textColor = tagTextEnableColor
        tagView.borderColor = isSelected ? .clear : tagTextEnableColor
        
        self.countSelectedList(self.tagList)
    }
}


