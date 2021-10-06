//
//  FLCardInfoViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 28/9/2564 BE.
//

import UIKit
import SwiftUI

protocol FLCardInfoViewControllerDelegate {
    func cardInfoViewControllerOpenQuizInfo(_ vc: FLCardInfoViewController)
    func cardInfoViewControllerClose(_ vc: FLCardInfoViewController)
}

class FLCardInfoViewController: UIViewController {
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var footerHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var instructorLabel: UILabel!
    @IBOutlet private weak var providerLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var tagView: TagListView!
    @IBOutlet private weak var tagHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var iconCount: UIImageView!
    @IBOutlet private weak var iconLike: UIImageView!
    @IBOutlet weak var iconQuiz: UIImageView!
    
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var quizLabel: UILabel!
    
    @IBOutlet private weak var countView: UIView!
    @IBOutlet private weak var likeView: UIView!
    @IBOutlet private weak var quizView: UIView!
    
    var delegate: FLCardInfoViewControllerDelegate?
    var flashCardDetail: FlFlashDetailResult?
    var isQuiz = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        self.cardView.updateLayout()
        self.cardView.roundCorners([.topLeft, .topRight], radius: 16)
        self.view.updateLayout()
        
        let titleFont = FontHelper.getFontSystem(14, font: .medium)
        self.titleLabel.font = titleFont
        self.nameLabel.font = titleFont
        self.countLabel.font = titleFont
        self.quizLabel.font = titleFont
        self.likeLabel.font = titleFont
        
        let detailFont = FontHelper.getFontSystem(14, font: .medium)
        self.instructorLabel.font = detailFont
        self.providerLabel.font = detailFont
        self.categoryLabel.font = detailFont
        self.descLabel.font = detailFont
            
        self.likeView.isHidden = true// next phace
        
        self.titleLabel.textColor = UIColor("010B19")
        let detailColor = UIColor.text75()
        self.instructorLabel.textColor = detailColor
        self.providerLabel.textColor = detailColor
        self.categoryLabel.textColor = detailColor
        self.descLabel.textColor = detailColor
        
        let textColor = UIColor.text()
        self.iconCount.tintColor = textColor
        self.iconLike.tintColor = textColor
        self.iconQuiz.tintColor = textColor
        
        self.countLabel.textColor = textColor
        self.likeLabel.textColor = textColor
        self.quizLabel.textColor = textColor
        
        let tapQuiz = UITapGestureRecognizer(target: self, action: #selector(self.openQuizInfo))
        self.quizView.addGestureRecognizer(tapQuiz)
        
        self.quizView.isHidden = !self.isQuiz
        
        self.tagView.updateLayout()
        self.tagView.delegate = self
        self.tagView.tagLineBreakMode = .byTruncatingTail
        
        self.footerHeight.constant = self.safeAreaBottomHeight
        
    }
    
    func updateUI() {
        guard let detail = self.flashCardDetail else { return }
        self.nameLabel.text = detail.name
        self.instructorLabel.text = "instructor".localized() + " : " + (detail.instructor?.name ?? "")
        self.providerLabel.text = "content_provider".localized() + " : " + (detail.provider?.name ?? "")
        self.categoryLabel.text = "category".localized() + " : " + (detail.category?.name ?? "")
        self.descLabel.text = detail.desc
        self.manageTagContentViewWith(tags: detail.tagList)
    }
    
    @IBAction func closePressed(_ sender: UIButton?) {
        self.delegate?.cardInfoViewControllerClose(self)
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
    
    @objc func openQuizInfo() {
        self.delegate?.cardInfoViewControllerOpenQuizInfo(self)
    }
    
}

extension FLCardInfoViewController: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        ConsoleLog.show("Tag : \(title), \(sender), \(tagView.tag)")
    }
    
}
