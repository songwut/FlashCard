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
    //case iPad need display popup for pagination (api limit 100 item per page)
    @IBOutlet private weak var navBar: UINavigationBar!
    @IBOutlet private weak var resetBarButton: UIBarButtonItem!
    @IBOutlet private weak var widthContent: NSLayoutConstraint!
    @IBOutlet private weak var heightContent: NSLayoutConstraint!
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tagView: TagListView!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var tagHeight: NSLayoutConstraint!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var loadingStackView: UIStackView!
    
    var loadingPageView: LoadingPageView!
    var isLoading:Bool = false
    
    var viewModel = TagListViewModel()
    
    var delegate: TagListSelectViewControllerDelegate?
    
    func createResetButton() -> UIBarButtonItem {
        UIBarButtonItem(title: "reset".localized(), style: .plain, target: self, action: #selector(self.resetPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.isIpad() {
            definesPresentationContext = true
            self.cardView.popIn()
            self.cardView.setShadow(radius: 10, opacity: 0.2)
            self.cardView.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "tag".localized()
        self.scrollView.delegate = self
        self.view.updateLayout()
        
        if UIDevice.isIpad() {//fource Constraint for ipad
            view.isOpaque = false
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.cardView.backgroundColor = .white
            self.cardView.clipsToBounds = true
            self.cardView.cornerRadius = 8
            self.cardView.setShadow(radius: 10, opacity: 0.2)
            self.widthContent.priority = UILayoutPriority(rawValue: 900)
            self.heightContent.priority = UILayoutPriority(rawValue: 900)
            self.navBar.isHidden = false
            self.navBar.topItem?.title = "tag".localized()
            self.navBar.topItem?.rightBarButtonItems = [self.createResetButton()]
        } else {
            self.navBar.isHidden = true
            self.navigationItem.rightBarButtonItems = [self.createResetButton()]
        }
        
        self.tagView.updateLayout()
        self.loadingPageView = LoadingPageView(frame: CGRect(x: 0, y: 0, width: self.tagView.bounds.width, height: 60))
        self.loadingPageView.backgroundColor = .clear
        self.loadingStackView.addArrangedSubview(self.loadingPageView)
        
        self.totalLabel.font = UIFont.font(14, .text)
        self.totalLabel.textColor = .text75()
        self.tagView.delegate = self
        let margin:CGFloat = UIDevice.isIpad() ? 8 : 8
        self.tagView.paddingX = margin
        self.tagView.paddingY = margin
        self.tagView.tagLineBreakMode = .byTruncatingTail
        self.tagView.selectedBorderColor = .clear
        self.tagView.borderColor = tagTextEnableColor
        self.tagView.tagSelectedBackgroundColor = tagBgEnableColor
        self.tagView.tagBackgroundColor = .white
        self.tagView.textColor = tagTextEnableColor
        //self.tagView.cornerRadius = 39
        self.tagView.isHidden = true
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
        self.countSelectedList(self.viewModel.tagList)
        self.manageTagReload(tags: self.viewModel.tagList)
    }
    
    private func dismiss() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func donePressed() {
        let selectList = self.viewModel.tagList.filter { (tag) -> Bool in
            return tag.isSelected
        }
        print("selectList: \(selectList.count)")
        self.delegate?.tagListSelectViewController(selectList)
        
        self.dismiss()
    }
    
    private func countSelectedList(_ tags:[UGCTagResult]) {
        let selectList = tags.filter { (tag) -> Bool in
            return tag.isSelected
        }
        let value = selectList.count.textNumber(many: "selected")
        let totalText =  "\("total".localized()) \(value)"
        self.totalLabel.text =  totalText
    }
    
    private func manageTagReload(tags:[UGCTagResult]) {
        
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
        self.viewModel.selectTagId.removeAll()
    }
    
    private func manageTagContentViewWith(tags:[UGCTagResult]) {
        self.countSelectedList(tags)
        //may improve pagination with collectionView
        if tags.isEmpty {
            self.tagView.isHidden = true
            
        } else {
            self.tagView.isHidden = false
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
                self.updateTagHeight()
                
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
    
    func scrollViewDidEndDeceleratingAnimatingFinal() {
        self.showLoading(nil)
        self.viewModel.callAPITagList { (list) in
            let newList = self.viewModel.newTagList
            //self.manageTagContentViewWith(tags: list)
            
            var tagList = [String]()
            for tag in newList {
                tagList.append(tag.name)
            }
            
            let lastIndex = self.tagView.tagViews.count
            
            self.tagView?.addTags(tagList)
            
            for i in lastIndex..<self.tagView.tagViews.count {
                let tagObject = self.viewModel.tagList[i]
                let tagId = tagObject.id
                let isSelected = tagObject.isSelected
                self.tagView?.tagViews[i].tag = tagId
                self.tagView?.tagViews[i].cornerRadius = CGFloat(self.tagView.tagViewHeight / 2)
                self.tagView?.tagViews[i].borderWidth = 1
                self.tagView?.tagViews[i].clipsToBounds = true
                self.tagView?.tagViews[i].tagBackgroundColor = isSelected ? tagBgEnableColor : .white
                self.tagView?.tagViews[i].textColor = tagTextEnableColor
                self.tagView?.tagViews[i].borderColor = isSelected ? .clear : tagTextEnableColor
                self.tagView?.layoutSubviews()
            }
            
            DispatchQueue.main.async {
                self.updateTagHeight()
            }
            
            self.hideLoading()
        }
        
    }
    
    func updateTagHeight() {
        self.tagView.isHidden = false
        let marginY: CGFloat = self.tagView.marginY / 2
        let paddingY: CGFloat = CGFloat(self.tagView.rows - 1) * self.tagView.paddingY
        let tagViewContentHeight:CGFloat = (CGFloat(self.tagView.rows) * self.tagView.tagViewHeight) + marginY + paddingY // 168
        ConsoleLog.show("tagViewContentHeight: \(tagViewContentHeight)")
        self.tagHeight.constant = tagViewContentHeight + 2
    }

}

extension TagListSelectViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let _ = self.viewModel.nextPage {
            if (scrollView.contentSize.height < scrollView.bounds.height) {
                //self.loadingFooterView?.prepareInitialAnimation()
                self.isLoading = true
            }
            let threshold = 100.0
            let contentOffset = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let diffHeight = contentHeight - contentOffset
            let frameHeight = scrollView.bounds.size.height
            var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold)
            triggerThreshold   =  min(triggerThreshold, 0.0)
            let pullRatio  = min(abs(triggerThreshold),1.0)
            //self.loadingFooterView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
            self.loadingPageView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
            if pullRatio >= 0.3 {
                self.loadingPageView?.startAnimate()
                //self.loadingFooterView?.animateFinal()
                
            } else {
                self.loadingPageView?.animateFinal()
                //self.loadingFooterView?.startAnimate()
            }
            ConsoleLog.show("pullRatio: \(pullRatio)")
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        let pullHeight  = abs(diffHeight - frameHeight)
        print("pullHeight:\(pullHeight)")
        if pullHeight <= 100 {
            if let loadingPageView = self.loadingPageView {
                if loadingPageView.isAnimatingFinal {
                    print("load more trigger")
                    self.loadingPageView?.stopAnimate()
                    self.scrollViewDidEndDeceleratingAnimatingFinal()
                }
            }
        }
    }
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


