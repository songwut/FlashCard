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
    
    @IBOutlet private weak var scrollAreaView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollWidth: NSLayoutConstraint!
    @IBOutlet private weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var coverImage: UIImageView!
    @IBOutlet private weak var footerHeight: NSLayoutConstraint!
    @IBOutlet private weak var titleHeight: NSLayoutConstraint!
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
    var didPressTag: DidAction?
    var detail: FLDetailResult?
    var isQuiz = false
    var selfFrame: CGRect = .zero
    let formatter = NumberFormatter()
    
    init(frame: CGRect, detail: FLDetailResult?, isQuiz: Bool) {
        self.selfFrame = frame
        self.detail = detail
        self.isQuiz = isQuiz
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selfFrame = .zero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bounds = self.selfFrame
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        self.view.updateLayout()
        self.scrollAreaView.updateLayout()
        self.scrollWidth.constant = self.scrollAreaView.bounds.width
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.isUserInteractionEnabled = true
        self.scrollAreaView.isHidden = true
        
        formatter.groupingSeparator = ","
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        
        self.titleHeight.constant = UIDevice.isIpad() ? 80 : 60
        self.titleLabel.font = .font(UIDevice.isIpad() ? 24 : 14, .medium)
        
        let titleFont = UIFont.font(14, .medium)
        self.nameLabel.font = titleFont
        self.countLabel.font = titleFont
        self.quizLabel.font = titleFont
        self.likeLabel.font = titleFont
        
        let detailFont = UIFont.font(14, .medium)
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
        self.scrollAreaView.isHidden = true
        self.updateUI()
    }
    
    private func updateUI() {
        guard let detail = self.detail else { return }
        self.coverImage.setImage(detail.image, placeholderImage: UIImage(named: "card-info-cover"))
        self.countLabel.text = formatter.string(from: NSNumber(value: detail.countView))
        self.nameLabel.text = detail.nameContent
        self.instructorLabel.text = "instructor".localized() + " : " + (detail.instructor?.name ?? "-")
        self.providerLabel.text = "content_provider".localized() + " : " + (detail.provider?.name ?? "-")
        self.categoryLabel.text = "category".localized() + " : " + (detail.category?.name ?? "-")
        self.descLabel.text = detail.desc
        
        self.manageTagContentViewWith(tags: detail.tagList)
    }
    
    @IBAction func closePressed(_ sender: UIButton?) {
        self.delegate?.cardInfoViewControllerClose(self)
    }
    
    private func manageTagContentViewWith(tags:[UGCTagResult]) {
        self.scrollAreaView.isHidden = false
        if tags.isEmpty {
            self.tagView.isHidden = true
            self.manageScrollHeight()
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
                    self.tagView?.tagViews[i].tag = tags[i].id
                    self.tagView?.tagViews[i].cornerRadius = 15
                    self.tagView?.tagViews[i].borderWidth = 1
                    self.tagView?.tagViews[i].clipsToBounds = true
                    self.tagView?.tagViews[i].tagBackgroundColor = tagBgEnableColor
                    self.tagView?.tagViews[i].textColor = tagTextEnableColor
                    self.tagView?.tagViews[i].borderColor = .clear
                }
                
                self.manageScrollHeight()
            }
        }
    }
    
    func manageScrollHeight() {
        let maxScrollHeight: CGFloat = self.selfFrame.height * 0.9
        self.scrollAreaView.isHidden = false
        if self.scrollView.contentSize.height < maxScrollHeight {
            self.scrollView.isScrollEnabled = false
            self.scrollHeight.constant = self.scrollView.contentSize.height
        } else {
            self.scrollView.isScrollEnabled = true
            self.scrollHeight.constant = maxScrollHeight
        }
        self.scrollView.updateLayout()
        let scrollFrame = self.scrollView.frame
        self.scrollView.frame = CGRect(x: scrollFrame.origin.x,
                                       y: scrollFrame.origin.y,
                                       width: scrollFrame.width,
                                       height: self.scrollHeight.constant)
    }
    
    @objc func openQuizInfo() {
        self.delegate?.cardInfoViewControllerOpenQuizInfo(self)
    }
    
}

extension FLCardInfoViewController: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        guard let detail = self.detail else { return }
        let selectTag = detail.tagList.filter{ $0.id == tagView.tag }
        self.didPressTag?.handler(selectTag)
    }
    
}
