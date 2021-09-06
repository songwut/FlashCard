//
//  FLPlayerViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 1/9/2564 BE.
//

import UIKit
import SwiftUI

class FLPlayerViewController: UIViewController {

    var viewModel = FLStageViewModel()
    
    private var swipeView: FLSwipeView<FlashPageResult>!{
        didSet{
            self.swipeView.delegate = self
        }
    }
    @IBOutlet weak var footerMargin: NSLayoutConstraint!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var navCardView: UIView! {
        didSet{
            self.navCardView.alpha = 0.0
        }
    }
    
    //use SwiftUI
    private let sgProgress = UIHostingController(rootView: FLUserProgressView())
    private let infoView = UIHostingController(rootView: FLInfoView())
    
    private var cardSize = CGSize.zero
    private var cardFrame = CGRect.zero
    private var stageRatio: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.footerMargin.constant = UIDevice.isIpad() ? 60.0 : 16.0
        self.leftButton.tintColor = ColorHelper.secondary()
        self.rightButton.tintColor = ColorHelper.secondary()
        self.leftButton.addTarget(self, action: #selector(self.prvAction(_:)), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(self.nextAction(_:)), for: .touchUpInside)
        self.viewContainer.updateLayout()
        self.infoStackView.updateLayout()
        self.progressStackView.updateLayout()
        self.viewContainer.alpha = 0.0
        
        let width = self.progressStackView.frame.width
        self.sgProgress.view.frame = CGRect(x: 0, y: 0, width: width, height: self.progressStackView.frame.height)
        self.sgProgress.view.backgroundColor = .clear
        self.progressStackView.addArrangedSubview(self.sgProgress.view)
        self.sgProgress.rootView.delegate = self
        
        self.infoView.view.frame = CGRect(x: 0, y: 0, width: self.infoStackView.frame.width, height: 60)
        self.infoView.view.backgroundColor = .clear
        self.infoStackView.addArrangedSubview(self.infoView.view)
        self.showLoading(nil)
        self.viewModel.callAPIFlashCard { [weak self] (cardResult: FlCardResult?) in
            self?.hideLoading()
            guard let viewContainer = self?.viewContainer else { return }
            self?.manageStageFrame(viewContainer)
        }
    }
    
    func manageStageFrame(_ contentView: UIView) {
        DispatchQueue.main.async {
            print("self.view:\(self.view.frame)")
            print("contentView:\(contentView.frame)")
            
            let areaFrame = contentView.frame
            
            let stageWidth = areaFrame.width * FlashStyle.pageCardWidthRatio
            let stageHidth = stageWidth * FlashStyle.pageCardRatio
            let stageX = (areaFrame.width - stageWidth) / 2
            let stageY = (areaFrame.height - stageHidth) / 2
            var stageFrame = CGRect(x: stageX, y: stageY, width: stageWidth, height: stageHidth)
            //stageHidth allway less than area
            
            //case rotate , iphone less height 3:4, 16:9
            if stageFrame.height > areaFrame.height {
                //need scale down height
                //ratioDown 0.x - 1.0
                let margin: CGFloat = 0.05
                let ratioDown = (areaFrame.height / stageFrame.height) - margin
                let newHeight = stageFrame.height * ratioDown
                let newWidth = stageFrame.width * ratioDown
                let newX = (areaFrame.width - newWidth) / 2
                let newY = (areaFrame.height - newHeight) / 2
                let updateFrame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
                stageFrame = updateFrame
            }
            
            
            //FL#TEXT_SIZE
            self.stageRatio = stageFrame.width / FlashStyle.baseStageWidth
            let edge = stageFrame.origin.x
            //self.sectionEdge = UIEdgeInsets(top: 0, left: edge, bottom: 0, right: edge)
            self.cardSize = stageFrame.size
            self.cardFrame = stageFrame
            print("edge left:\(edge)")
            print("cardSize:\(self.cardSize)")
            print("stageRatio:\(self.stageRatio)")
            
            
            self.createStageAnimate(cardFrame: self.cardFrame)
        }
    }
    
    private func updatePageNumber() -> String {
        let pageNum = self.viewModel.pageIndex + 1
        return"\(pageNum) / \(self.viewModel.pageList.count)"
    }
    
    func createStageAnimate(cardFrame: CGRect) {
        // Dynamically create view for each card
        let contentView: (Int, CGRect, FlashPageResult) -> (UIView) = { (index: Int ,frame: CGRect , pageResult: FlashPageResult) -> (UIView) in
            
            let stageView = FLStageView(frame: frame)
            stageView.viewModel = self.viewModel
            stageView.page = pageResult
            return stageView
        }
        
        self.sgProgress.rootView.maximum = self.viewModel.pageList.count
        self.pageLabel.text = self.updatePageNumber()
                
        self.swipeView = FLSwipeView<FlashPageResult>(frame: self.viewContainer.bounds, contentView: contentView)
        self.swipeView.cardFrame = cardFrame
        self.viewContainer.addSubview(self.swipeView)
        self.swipeView.showTinderCards(with: self.viewModel.pageList ,isDummyShow: true)
        if let firstCard = self.swipeView.loadedCards.first?.overlay as? FLStageView {
            firstCard.loadElement()
        }
        
        self.viewContainer.alpha = 1.0
    }
    
    @objc func stageViewButtonSelected(button:UIButton) {
        
        if let customView = button.superview(of: FLStageView.self) , let userModel = customView.page {
            print("button selected for \(userModel.name)")
        }
        
    }
    

    @IBAction func prvAction(_ sender: Any) {
        if let swipeView = swipeView {
            swipeView.undoCurrentTinderCard()
            print("prvAction")
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if let swipeView = swipeView {
            swipeView.makeLeftSwipeAction()
            print("nextAction")
        }
    }
    
    @IBAction func undoButtonPressed(_ sender: Any) {
        if let swipeView = swipeView {
            swipeView.undoCurrentTinderCard()
            print("undoButtonPressed")
        }
    }
}

extension FLPlayerViewController: FLUserProgressViewDelegate {
    func segmentSelected(_ index: Int) {
        print("segmentSelected index:\(index)")
    }
    
}

extension FLPlayerViewController : FLSwipeViewDelegate {
    
    func dummyAnimationDone() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
            self.navCardView.alpha = 1.0
        }, completion: nil)
        print("Watch out shake action")
    }
    
    func didSelectCard(model: Any) {
        print("Selected card")
    }
    
    func fallbackCard(model: Any) {
        //emojiView.rateValue =  2.5
        let page = model as! FlashPageResult
        print("Cancelling \(page.name)")
    }
    
    func cardGoesLeft(model: Any) {
        //emojiView.rateValue =  2.5
        let page = model as! FlashPageResult
        print("Watchout Left \(page.id)")
        let nextIndex = self.swipeView.index + 1
        print("nextIndex \(nextIndex)")
        if let firstCard = self.swipeView.loadedCards.first?.overlay as? FLStageView {
            firstCard.loadElement()
        }
        
    }
    
    func cardGoesRight(model : Any) {
        //emojiView.rateValue =  2.5
        let page = model as! FlashPageResult
        print("Watchout Right \(page.id)")
    }
    
    func undoCardsDone(model: Any) {
        //emojiView.rateValue =  2.5
        let page = model as! FlashPageResult
        print("Reverting done \(page.name)")
    }
    
    func endOfCardsReached() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.navCardView.alpha = 0.0
        }, completion: nil)
         print("End of all cards")
    }
    
    func currentCardStatus(card object: Any, distance: CGFloat) {
        if distance == 0 {
            //emojiView.rateValue =  2.5
        }else{
            let value = Float(min(abs(distance/100), 1.0) * 5)
            let sorted = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
            //emojiView.rateValue =  sorted
        }
        print(distance)
    }
}

extension UIView {
    
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.map { $0.superview(of: type)! }
    }
    
    func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }
}
