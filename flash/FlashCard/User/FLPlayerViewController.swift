//
//  FLPlayerViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 1/9/2564 BE.
//

import UIKit
import SwiftUI

enum FLPlayerState {
    case preview
    case user
    
    func backgeoundColor() -> UIColor {
        if self == .preview {
            return .background()
        } else {
            return .white
        }
    }
}

class FLPlayerViewController: FLBaseViewController {

    var playerState: FLPlayerState = .user
    var viewModel = FLFlashCardViewModel()
    
    private var swipeView: FLSwipeView<FLCardPageResult>!{
        didSet{
            self.swipeView.delegate = self
        }
    }
    @IBOutlet weak var footerMargin: NSLayoutConstraint!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var footerStackView: UIStackView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var navCardView: UIView! {
        didSet{
            self.navCardView.alpha = 0.0
        }
    }
    private let sgProgressModel = FLProgressViewModel()
    private var infoView: UIHostingController<FLInfoView>!
    private var cardSize = CGSize.zero
    private var cardFrame = CGRect.zero
    private var stageRatio: CGFloat = 1.0
    private let creator = FLCreator(isEditor: false)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = self.playerState.backgeoundColor()
        self.topView.isHidden = self.playerState == .preview
        self.closeButton.addTarget(self, action: #selector(self.didPressedClose(_:)), for: .touchUpInside)
        self.footerMargin.constant = UIDevice.isIpad() ? 60.0 : 16.0
        self.leftButton.tintColor = UIColor.config_secondary()
        self.rightButton.tintColor = UIColor.config_secondary()
        self.leftButton.addTarget(self, action: #selector(self.prvAction(_:)), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(self.nextAction(_:)), for: .touchUpInside)
        self.viewContainer.updateLayout()
        self.infoStackView.updateLayout()
        self.progressStackView.updateLayout()
        self.viewContainer.alpha = 0.0
        self.pageLabel.textColor = .black
        self.pageLabel.font = .font(16, .text)
        
        
        self.viewModel.callAPIFlashDetail(.get) { [weak self] (flashDetail) in
            guard let self = self else { return }
            guard let detail = flashDetail else { return }
            self.title = detail.name
            self.titleLabel.text = detail.name
            
            self.infoView = UIHostingController(rootView: FLInfoView(detail: detail))
            self.infoView.view.frame = CGRect(x: 0, y: 0, width: self.infoStackView.frame.width, height: 60)
            self.infoView.view.backgroundColor = UIColor.clear
            self.infoView.view.cornerRadius = 8
            self.infoView.view.borderWidth = 1
            self.infoView.view.borderColor = UIColor("D0D3D6")
            self.infoView.rootView.delegate = self
            self.infoStackView.addArrangedSubview(self.infoView.view)
            
        }
        
        self.viewModel.callAPIFlashCard { [weak self] (cardResult: FLFlashDetailResult?) in
            guard let self = self else { return }
            
            let count = cardResult?.list.count ?? 0
            let width = self.progressStackView.frame.width
            let sgProgress = UIHostingController(rootView: FLProgressView(maximum:count).environmentObject(self.sgProgressModel))
            sgProgress.view.frame = CGRect(x: 0, y: 0, width: width, height: self.progressStackView.frame.height)
            sgProgress.view.backgroundColor = .clear
            self.progressStackView.addArrangedSubview(sgProgress.view)
            
            guard let viewContainer = self.viewContainer else { return }
            self.manageStageFrame(viewContainer)
        }
    }
    
    @objc func didPressedClose(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func loadCardPage() {//may remove
        guard let card = self.viewModel.currentPage else { return }
        self.viewModel.callAPICardDetail(card) { (cardDetail) in
            ConsoleLog.show("callAPICardDetail")
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
    
    private func updatePageNumber() {
        let pageNum = self.swipeView.index + 1
        self.pageLabel.text = "\(pageNum) / \(self.viewModel.pageList.count)"
        self.sgProgressModel.value = pageNum
        self.updateButton()
    }
    
    private func updateButton() {
        let activeColor:UIColor = UIColor("525252")
        
        let pageNum = self.swipeView.index + 1
        let count = self.viewModel.pageList.count
        if count == 1 {
            self.leftButton.tintColor = .disable()
            self.rightButton.tintColor = .disable()
            self.leftButton.borderColor = .disable()
            self.rightButton.borderColor = .disable()
            self.leftButton.isUserInteractionEnabled = false
            self.rightButton.isUserInteractionEnabled = false
            
        } else if pageNum == 1 {
            self.leftButton.tintColor = .disable()
            self.rightButton.tintColor = activeColor
            self.leftButton.borderColor = .disable()
            self.rightButton.borderColor = activeColor
            self.leftButton.isUserInteractionEnabled = false
            self.rightButton.isUserInteractionEnabled = true
            
        } else if pageNum < count {
            self.leftButton.tintColor = activeColor
            self.rightButton.tintColor = activeColor
            self.leftButton.borderColor = activeColor
            self.rightButton.borderColor = activeColor
            self.leftButton.isUserInteractionEnabled = true
            self.rightButton.isUserInteractionEnabled = true
            
        } else if pageNum == count {
            self.leftButton.tintColor = activeColor
            self.rightButton.tintColor = .disable()
            self.leftButton.borderColor = activeColor
            self.rightButton.borderColor = .disable()
            self.leftButton.isUserInteractionEnabled = true
            self.rightButton.isUserInteractionEnabled = false
        }
    }
    
    func createStageAnimate1(cardFrame: CGRect) {
//        let vc = UIHostingController(rootView: CardSwipeLoopView(cardSize: cardFrame.size))
//        vc.view.frame = cardFrame
//        self.viewContainer.addSubview(vc.view)
//        self.viewContainer.alpha = 1.0
    }
    
    func createStageAnimate(cardFrame: CGRect) {
        //Can change lib CardView here
        //Dynamically create view for each card
        let contentView: (Int, CGRect, FLCardPageResult) -> (UIView) = { (index: Int ,frame: CGRect , pageResult: FLCardPageResult) -> (UIView) in
            
            let stageView = FLStageView(frame: frame)
            stageView.flCreator = self.creator
            stageView.card = pageResult
            return stageView
        }
        
        self.swipeView = FLSwipeView<FLCardPageResult>(frame: self.viewContainer.bounds, contentView: contentView)
        self.swipeView.cardFrame = cardFrame
        self.viewContainer.addSubview(self.swipeView)
        let list = self.viewModel.pageList
        self.swipeView.showTinderCards(with: list ,isDummyShow: true)
        if let firstCard = self.swipeView.loadedCards.first?.overlay as? FLStageView {
            firstCard.loadElement(viewModel: self.viewModel) { (anyView) in
                // if need to custom more anyView
            }
        }
        self.updatePageNumber()
        self.viewContainer.alpha = 1.0
    }
    
    func loadNextPage(page: FLCardPageResult) {
        print("Watchout Left \(page.id)")
        let nextIndex = self.swipeView.index + 1
        print("nextIndex \(nextIndex)")
        self.updatePageNumber()
        if let firstCard = self.swipeView.loadedCards.first?.overlay as? FLStageView {
            firstCard.loadElement(viewModel: self.viewModel) { (anyView) in
                // if need to custom more anyView
            }
        }
    }
    
    @objc func stageViewButtonSelected(button:UIButton) {
        
        if let customView = button.superview(of: FLStageView.self) , let userModel = customView.card {
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
    var pageInfoVC: FLInfoPageViewController?
}

extension FLPlayerViewController: FLInfoViewDelegate {
    func didOpenInfo() {
        self.footerStackView.updateLayout()
        self.footerStackView.removeAllArranged()
        let pageInfoVC = self.pageInfoVC ?? FLInfoPageViewController(frame: self.view.bounds, viewModel: self.viewModel)
        //pageInfoVC.delegate = self
        pageInfoVC.quiz = self.viewModel.getQuizContent()
        pageInfoVC.view.frame = self.view.bounds
        pageInfoVC.modalPresentationStyle = .overCurrentContext
        pageInfoVC.modalTransitionStyle = .crossDissolve
        self.present(pageInfoVC, animated: true, completion: nil)
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
        let page = model as! FLCardPageResult
        print("Cancelling \(page.name)")
    }
    
    func cardGoesLeft(model: Any) {
        let page = model as! FLCardPageResult
        self.loadNextPage(page: page)
    }
    
    func cardGoesRight(model : Any) {
        let page = model as! FLCardPageResult
        self.loadNextPage(page: page)
    }
    
    func undoCardsDone(model: Any) {
        let page = model as! FLCardPageResult
        print("Reverting done \(page.name)")
        self.updatePageNumber()
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
