//
//  FLEditorViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 1/7/2564 BE.
//

import UIKit
import AVKit
import SwiftUI
import Photos
import IQKeyboardManagerSwift

enum FLCreateStatus {
    case new
    case edit
}

final class FLEditorViewController: FLBaseViewController {
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var contentPageView: UIView!
    @IBOutlet private weak var toolStackView: UIStackView!
    @IBOutlet private weak var contentToolHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var menuView: UIView!
    @IBOutlet private weak var pageCountLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var previewButton: UIButton!
    @IBOutlet private weak var listButton: UIButton!
    
    private var stageView: FLStageView?
    private var sliderView: FLSliderView?
    private var stageViewList: [FLStageView]?
    private var flCreator: FLCreator?
    private var didScrollCollectionViewToMiddle = false
    private var isEditorPageReady = false
    private var controlView: FLControlView?
    private var titleLabel: UILabel!
    private var isManageScrolling = false
    private var selectedView: UIView?
    private var widthChange:CGFloat = 0.0
    
    var createStatus:FLCreateStatus = .new
    var isTurnBack = false
    var toolVC: FLToolViewController?
    var viewModel = FLFlashCardViewModel()
    
    private var isReadyToSwipeStage = false {
        didSet {
            self.sliderView?.scrollView.isScrollEnabled = self.isReadyToSwipeStage
        }
    }
    
    lazy var deletePageButton: UIButton? = {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(named: "ic_v2_delete"), for: .normal)
        let w = FlashStyle.deletePageWidth
        b.bounds = CGRect(x: 0, y: 0, width: w, height: w)
        b.backgroundColor = .elementBackground()
        b.tintColor = .light()
        b.cornerRadius = w / 2
        return b
    }()
    
    var postBtn = UIBarButtonItem()
    
    lazy var addLeftPageButton: UIButton? = {
        let b = self.createAddButton()
        return b
    }()
    
    lazy var addRightPageButton: UIButton? = {
        let b = self.createAddButton()
        return b
    }()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.isIpad() ? .all : .portrait
    }
    
    deinit {
        print("stage removed")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.manageVideoStop(row: self.viewModel.pageIndex)
        self.saveCurrentCardPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = ""
        self.postBtn = UIBarButtonItem(title: "post".localized(), style: .plain, target: self, action: #selector(postPressed))
        self.postBtn.tintColor = headerTextColor
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [self.postBtn]
        self.manageVideoPlay(row: self.viewModel.pageIndex)
    }
    
    @objc func postPressed() {
        self.manageVideoStop(row: self.viewModel.pageIndex)
        self.saveCurrentCardPage()
        
        if self.isTurnBack {//case edit
            self.navigationController?.popViewController(animated: true)
        } else {
            //case create new flashcard
            
            let model = FLFlashCardViewModel()
            model.contentCode = .flashcard
            model.materialId = viewModel.materialId
            let vc = FLPostViewController.instantiate(viewModel: model)
            vc.createStatus = .edit
            vc.title = viewModel.detail?.nameContent ?? ""
            
            if let nav = self.navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
            //TODO: next feature 4.12 will bee .video, .audio .article and more
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.unregisterAllNotifications()
        
        self.view.updateLayout()
        self.view.backgroundColor = .background()
        self.topView.backgroundColor = .background()
        self.contentPageView.backgroundColor = .background()
        self.menuView.backgroundColor = .background()
        self.topViewHeight.constant = UIDevice.isIpad() ? 58 : 40
        self.stageViewList = [FLStageView]()
        
        self.titleLabel = UILabel()
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: 40)
        self.titleLabel.font = .font(16, .text)
        self.titleLabel.textColor = headerTextColor
        self.pageCountLabel.text = ""
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.titleLabel)
        self.navigationItem.leftItemsSupplementBackButton = true
        
        self.view.backgroundColor = FlashStyle.screenColor
        self.contentToolHeight.constant = FlashStyle.contentToolHeight
        
        self.addButton.updateLayout()
        self.addButton.cornerRadius = self.addButton.bounds.width / 2
        self.addButton.backgroundColor = UIColor.config_primary()
        self.addButton.tintColor = .light()
        let edge = self.addButton.bounds.height * FlashStyle.iconEedge
        let iconPading = UIEdgeInsets(top: edge, left: edge, bottom: edge, right: edge)
        self.addButton.imageEdgeInsets = iconPading
        self.previewButton.imageEdgeInsets = iconPading
        self.listButton.imageEdgeInsets = iconPading
        
        self.pageCountLabel.textColor = .text50()
        self.previewButton.tintColor = .text50()
        self.listButton.tintColor = .text50()
        
        self.stageView = FLStageView()
        self.stageView?.isEditor = true
        self.stageView?.cornerRadius = 16
        self.stageView?.backgroundColor = .white
        self.contentPageView.addSubview(self.stageView!)
        
        self.sliderView = FLSliderView.instanciateFromNib()
        self.sliderView?.backgroundColor = .clear
        self.sliderView?.contentStackView.spacing = FlashStyle.stage.cellSpacing
        self.contentPageView.addSubview(self.sliderView!)
        
        self.contentPageView.addSubview(self.deletePageButton!)
        //self.contentPageView.addSubview(self.addLeftPageButton!)
        self.contentPageView.addSubview(self.addRightPageButton!)
        self.deletePageButton?.addTarget(self, action: #selector(self.deletePressed(_:)), for: .touchUpInside)
        self.deletePageButton?.isHidden = true
        
        self.flCreator = FLCreator(isEditor: true)
        
        self.listButton.addTarget(self, action: #selector(self.listButtonPressed(_:)), for: .touchUpInside)
        
        self.addButton.addTarget(self, action: #selector(self.addButtonPressed(_:)), for: .touchUpInside)
        self.addLeftPageButton?.addTarget(self, action: #selector(self.appLeftPressed(_:)), for: .touchUpInside)
        self.addRightPageButton?.addTarget(self, action: #selector(self.addRightPressed(_:)), for: .touchUpInside)
        self.previewButton.addTarget(self, action: #selector(self.previewPressed(_:)) , for: .touchUpInside)
        self.prepareToolVC()
        self.contentPageView.alpha = 0.0
        
        if self.createStatus == .new {
            
            guard let profile = UserManager.shared.profile else { return }
            //self.showLoading(nil)//bug
            self.viewModel.callAPINewFlashCard(profile: profile) { [weak self] (detail) in
                self?.hideLoading()
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.callAPIFlashCardDetail()
                }
            }
        } else {
            self.callAPIFlashCardDetail()
        }
    }
    
    func callAPIFlashCardDetail() {
        self.viewModel.callAPIFlashDetail(.get) { (flashDetail) in
            guard let detail = flashDetail else { return }
            self.titleLabel.text = detail.name
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.titleLabel)
        }
        
        self.viewModel.callAPIFlashCard { [weak self]  (cardResult: FLFlashDetailResult?) in
            guard let self = self else { return }
            self.titleLabel.text = self.viewModel.detail?.name ?? ""
            if let object = cardResult {
                ConsoleLog.show("total:\(object.total)")
                ConsoleLog.show("list:\(object.list)")
                if object.total >= 1 {
                    self.manageStageFrame(pageList: self.viewModel.pageList)
                } else {
                    //no card page need create new
                    self.callAPIAddNewCard {  (cardPage:FLCardPageResult?) in
                        self.manageStageFrame(pageList: self.viewModel.pageList)
                    }
                }
            }
        }
    }
    
    func reloadCardPage(method: APIMethod, param:[String: Any]? = nil, index: Int) {
        ConsoleLog.show("reloadCardPage \(method.rawValue) : at index:\(index)")
        let stage = self.getStageView(at: index)
        let card = self.viewModel.pageList[index]
        self.viewModel.callAPICardDetail(card, method: method, param: param) { (cardDetail) in
            stage.cardDetail = cardDetail
            if method == .get {
                self.checkQuizIn(cardDetail: cardDetail)
            }
        }
    }
    
    func updatePageNumber() {
        let max = self.viewModel.pageList.count
        let index = self.viewModel.pageIndex
        self.pageCountLabel.text = "\(index + 1)/\(max)"
    }
    
    func checkQuizIn(cardDetail: FLCardPageDetailResult?) {
        let quiz = cardDetail?.componentList.first {$0.type == .quiz}
        if let _ = quiz {
            self.toolVC?.quizMenu?.setQuizButtonEnable(false)
        } else {
            self.toolVC?.quizMenu?.setQuizButtonEnable(true)
        }
    }
    
    func checkQuizIn(_ stage: FLStageView?) {
        guard let s = stage else { return }
        let isQuizView = self.isQuizViewInStageView(stage: s)
        self.toolVC?.quizMenu?.setQuizButtonEnable(!isQuizView)
    }
    
    private func isQuizViewInStageView(stage: FLStageView) -> Bool {
        let quizUI = stage.subviews.first { (view) in
            return view.className == FLQuizView.className
        }
        if let _ = quizUI {
            return true
        } else {
            return false
        }
    }
    
    @objc func previewPressed(_ sender: UIButton) {
        self.manageVideoStop(row: self.viewModel.pageIndex)
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
    
    @objc func deletePressed(_ sender: UIButton) {
        let index = self.viewModel.pageIndex
        let stage = self.getStageView(at: index)
        if let card = stage.card {
            self.viewModel.callApiDeleteList([card.id], apiMethod: .delete) { [weak self] in
                guard let self = self else { return }
                stage.card = nil
                self.stageViewList?.remove(at: index)
                stage.removeFromSuperview()
                self.deletePageButton?.isHidden = self.viewModel.pageList.count == 1
                if let scrollView = self.sliderView?.scrollView {
                    self.scrollViewDidEndDragging(scrollView, willDecelerate: true)
                }
            }
        }
    }
    
    @objc func appLeftPressed(_ sender: UIButton) {
        self.saveCurrentCardPage()
    }
    
    @objc func addRightPressed(_ sender: UIButton) {
        if self.viewModel.isLimitCard() {
            PopupManager.showWarning("warning_maximum_card".localized(), at: self)
            return
        }
        self.saveCurrentCardPage()
        self.toolVC?.quizMenu?.setQuizButtonEnable(true)
        
        self.showLoading(nil)
        self.callAPIAddNewCard {  [weak self]  (cardPage:FLCardPageResult?) in
            guard let self = self else { return }
            self.hideLoading()
            guard let card = cardPage else { return }
            let lastItemIndex = self.viewModel.pageList.count - 1
            card.index = lastItemIndex
            self.createNewCardView(card)
            self.gotoPage(index: lastItemIndex)
            self.deletePageButton?.isHidden = self.viewModel.pageList.count == 1
        }
    }
    
    func callAPIAddNewCard(_ complete: @escaping (_ result: FLCardPageResult?) -> ()) {
        var newCardData = [String: Any]()
        var data = [String: Any]()
        data["bg_color"] = ["cl_code" : "FFFFFF","code": "color_01"]
        data["component"] = []
        newCardData["data"] = data
        
        self.viewModel.callAPIAddNewCard(param: newCardData) {(cardPage) in
            self.hideLoading()
            complete(cardPage)
        }
    }
    
    func saveCurrentCardPage() {
        let index = self.viewModel.pageIndex
        self.saveCardPage(index: index)
    }
    
    func saveCardPage(index: Int) {
        let currentStage = self.getStageView(at: index)
        if currentStage.isRequireSave {
            self.saveCoverPage()
            guard let cardPageJson = currentStage.createJSON() else { return }
            ConsoleLog.show("addRightPressed index:\(index)")
            self.reloadCardPage(method: .patch, param: cardPageJson, index: index)
            ConsoleLog.show("save currentStage")
            currentStage.isRequireSave = false
        }
    }
    
    func createNewCardView(_ card: FLCardPageResult) {
        let frame = self.stageView?.frame ?? .zero
        let newStage = self.createStageView(frame.size, creator: self.flCreator!)
        newStage.card = card
        self.sliderView?.contentStackView.addArrangedSubview(newStage)
        self.stageViewList?.append(newStage)
    }
    
    func gotoPage(index: Int) {
        self.viewModel.pageIndex = index
        self.manageAddLR()
        let max = self.viewModel.pageList.count
        self.pageCountLabel.text = "\(index + 1)/\(max)"
        
        if let scrollView = self.sliderView?.scrollView {
            self.isManageScrolling = false
            self.manageScrollCenter(index, scrollView: scrollView)
        }
    }
    
    func createAddButton() -> UIButton {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(named: "plus"), for: .normal)
        let w = FlashStyle.addPageWidth
        b.bounds = CGRect(x: 0, y: 0, width: w, height: w)
        b.backgroundColor = .white
        b.tintColor = UIColor("7E858E")
        b.cornerRadius = w / 2
        b.addDash(1, color: UIColor("D7DFE9"))
        return b
    }
    
    @objc func stageTaped(_ sender: TapGesture) {
        self.view.endEditing(true)
        self.toolVC?.closePressed(nil)
    }
    
    func manageStageFrame(pageList: [FLCardPageResult]) {
        self.contentPageView.updateLayout()
        DispatchQueue.main.async {
            print("self.view:\(self.view.frame)")
            print("self.contentPageView:\(self.contentPageView.frame)")
            
            let areaFrame = self.contentPageView.frame
            
            let stageWidth = areaFrame.width * FlashStyle.pageCardWidthRatio
            let stageHidth = stageWidth * FlashStyle.pageCardRatio
            let stageX = (areaFrame.width - stageWidth) / 2
            let stageY = (areaFrame.height - stageHidth) / 2
            var stageFrame = CGRect(x: stageX,
                                    y: stageY,
                                    width: stageWidth,
                                    height: stageHidth)
            
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
                let updateFrame = CGRect(x: newX,
                                         y: newY,
                                         width: newWidth,
                                         height: newHeight)
                stageFrame = updateFrame
            }
            
            self.stageView?.frame = stageFrame
            self.stageView?.stageRatio = stageFrame.width / FlashStyle.baseStageWidth
            let stageView = self.stageView!
            self.deletePageButton?.center = CGPoint(x: stageView.center.x,
                                                    y: stageView.frame.origin.y)
            
            self.addLeftPageButton?.center = CGPoint(x: stageView.frame.origin.x,
                                                     y: stageView.center.y)
            
            self.addRightPageButton?.center = CGPoint(x: stageView.frame.origin.x + stageView.frame.width,
                                                      y: stageView.center.y)
            
            self.manageAddLR()
            
            let edge = stageFrame.origin.x
            self.sectionEdge = UIEdgeInsets(top: 0, left: edge, bottom: 0, right: edge)
            self.cellSize = stageFrame.size
            
            self.sliderView?.frame = CGRect(x: 0, y: 0,
                                            width: areaFrame.width,
                                            height: areaFrame.height)
            self.sliderView?.stackHeight.constant = stageFrame.height
            self.sliderView?.leftWidth.constant = self.sectionEdge.left
            self.sliderView?.rightWidth.constant = self.sectionEdge.right
            self.controlView = FLControlView.instanciateFromNib()
            self.controlView?.leftWidthButton.tag = FLTag.left.rawValue
            self.controlView?.rightWidthButton.tag = FLTag.right.rawValue
            self.controlView?.isHidden = true
            stageView.isHidden = true//use in test case 1 stage
            
            if !self.isEditorPageReady {
                self.manageMultitleStage(pageList: pageList)
                DispatchQueue.main.async {
                    self.viewModel.pageIndex = self.indexOfMajorCell()
                    let stage = self.getStageView(at: self.viewModel.pageIndex)
                    self.updateAfterAllStageReady(stage: stage)
                }
            }
        }
    }
    
    private func updateAfterAllStageReady(stage: FLStageView) {
        self.updatePageNumber()
        self.manageAddLR()
        
        self.deletePageButton?.isHidden = self.viewModel.pageList.count == 1
        
        if self.createStatus == .new {
            //case new Load first card page
            self.createStatus = .edit
            self.reloadCardPage(method: .get, index: self.viewModel.pageIndex)
            self.isEditorPageReady = true
            UIView.animate(withDuration: 0.3) {
                self.contentPageView.alpha = 1.0
            }
            
        } else {
            //case edit need prepare element in first card
            stage.stageRatio = self.stageView?.stageRatio ?? 1.0
            stage.isEditor = true
            stage.isRequireToLoadElement = false
            stage.isVideoAutoPlay = true
            stage.loadElement(viewModel: self.viewModel) { [ weak self] (anyView) in
                guard let self = self else { return }
                // all element in stage ready
                //then custom for editor
                if let iView = anyView as? InteractView {
                    self.manageIView(in: iView, stageView: stage)
                    iView.isHiddenEditingTool = true
                    
                } else if let iView = anyView as? InteractTextView {
                    self.manageTextView(in: iView, stageView: stage)
                    iView.isHiddenEditingTool = true
                    
                } else if let quizView = anyView as? FLQuizView {
                    self.manageQuizView(in: quizView, stageView: stage)
                    //iView.isHiddenEditingTool = true
                }
                
            }
            self.checkQuizIn(stage)
            
            self.isEditorPageReady = true
            UIView.animate(withDuration: 0.3) {
                self.contentPageView.alpha = 1.0
                self.isReadyToSwipeStage = true
            }
            
            //prepare element in other stage
            guard let stageList = self.stageViewList else { return }
            for stage in stageList {
                if stage.isRequireToLoadElement {
                    self.loadElement(in: stage)
                }
            }
        }
    }
    
    private func loadElement(in stage: FLStageView) {
        stage.isEditor = true
        stage.isVideoAutoPlay = false
        stage.loadElement(viewModel: self.viewModel) { [ weak self] (anyView) in
            guard let self = self else { return }
            // all element in stage ready
            //then custom for editor
            if let iView = anyView as? InteractView {
                self.manageIView(in: iView, stageView: stage)
                iView.isHiddenEditingTool = true
                
            } else if let iView = anyView as? InteractTextView {
                self.manageTextView(in: iView, stageView: stage)
                iView.isHiddenEditingTool = true
                
            } else if let quizView = anyView as? FLQuizView {
                self.manageQuizView(in: quizView, stageView: stage)
            }
        }
    }
    
    func updateStageList() {//case from grid/list isChangeCardList
        guard let stageList = self.stageViewList else { return }
        let pageList = self.viewModel.pageList
        if pageList.count < stageList.count {
            //some card deleted need to change pageIndex
            self.viewModel.pageIndex = pageList.count - 1
        }
        self.stageViewList?.removeAll()
        self.manageMultitleStage(pageList: pageList)
        DispatchQueue.main.async {
            let stage = self.getStageView(at: self.viewModel.pageIndex)
            self.updateAfterAllStageReady(stage: stage)
            let index = self.viewModel.pageIndex
            self.gotoPage(index: index)
        }
    }
    
    func createStageView(_ size: CGSize, creator: FLCreator) -> FLStageView {
        let f = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let stage = FLStageView(frame: f)
        stage.flCreator = creator
        stage.backgroundColor = .white
        stage.cornerRadius = 16
        stage.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        stage.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeStage(_:)))
        swipeRight.direction = .right
        stage.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeStage(_:)))
        swipeLeft.direction = .left
        stage.addGestureRecognizer(swipeLeft)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapStage(_:)))
        stage.addGestureRecognizer(tap)
        return stage
    }
    
    func manageMultitleStage(pageList: [FLCardPageResult]) {
        guard let stackView = self.sliderView?.contentStackView else {return}
        stackView.removeAllArranged()
        let frame = self.stageView?.frame ?? CGRect.zero
        var order = 0
        for page in pageList {
            let stage = self.createStageView(frame.size, creator: self.flCreator!)
            page.order = order
            stage.isEditor = true
            stage.card = page
            self.stageViewList?.append(stage)
            stackView.addArrangedSubview(stage)
            order += 1
        }
        stackView.layoutIfNeeded()
        self.sliderView?.scrollView.delegate = self
        self.sliderView?.scrollView.isScrollEnabled = false
    }
    
    func selectedViewIsHiddenTool(_ isHiddenEditingTool: Bool) {
        if let iView = self.selectedView as? InteractView {
            iView.isHiddenEditingTool = isHiddenEditingTool
        } else if let iView = self.selectedView as? InteractTextView {
            iView.isHiddenEditingTool = isHiddenEditingTool
        }
    }
    
    @objc func tapStage(_ gesture: UITapGestureRecognizer) {
        self.selectedViewIsHiddenTool(true)
        self.isReadyToSwipeStage = true
        self.view.endEditing(true)
        self.toolVC?.open(.menu)
    }
    
    @objc func swipeStage(_ gesture: UISwipeGestureRecognizer) {
        if self.isReadyToSwipeStage {
            self.selectedViewIsHiddenTool(true)
            self.saveCoverPage()
            
            switch gesture.direction {
            case .right:
                print("Swiped right")
                break
            case .left:
                print("Swiped left")
                break
            default:
                break
            }
        }
    }
    
    var sectionEdge = UIEdgeInsets.zero
    var cellSize = CGSize.zero
    
    func manageAddLR() {
        self.addLeftPageButton?.isHidden = false
        if self.viewModel.pageIndex == 0, self.viewModel.pageList.count == 1 {//first
            self.addRightPageButton?.isHidden = false
            
        } else if self.viewModel.pageIndex == (self.viewModel.pageList.count - 1) {//last
            self.addRightPageButton?.isHidden = false
            
        } else {
            self.addRightPageButton?.isHidden = true//between
        }
    }
    
    @objc func addButtonPressed(_ sender: UIButton) {
        self.openToolBar(tool: .menu)
        self.toolVC?.open(.menu)
    }
    
    @objc func listButtonPressed(_ sender: UIButton) {
        self.selectedViewIsHiddenTool(true)
        let index = self.viewModel.pageIndex
        let currentStage = self.getStageView(at: index)
        if currentStage.isRequireSave {
            currentStage.isRequireSave = false
            
            self.saveCoverPage()
            guard let cardPageJson = currentStage.createJSON() else { return }
            let stage = self.getStageView(at: index)
            let card = self.viewModel.pageList[index]
            self.viewModel.callAPICardDetail(card, method: .patch, param: cardPageJson) { [weak self] (cardDetail) in
                stage.cardDetail = cardDetail
                self?.openListVC()
            }
        } else {
            self.openListVC()
        }
    }
    
    private func openListVC() {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        if let vc = s.instantiateViewController(withIdentifier: "FLListViewController") as? FLListViewController {
            vc.viewModel = self.viewModel
            vc.didChangeCardList = Action(handler: { [weak self] (sender) in
                self?.updateStageList()
            })
            if let nav = self.navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    private func indexOfMajorCell() -> Int {
        //FlashStyle.stage.cellSpacing * 2
        let itemWidth = self.cellSize.width + FlashStyle.stage.cellSpacing
        guard let sliderView = self.sliderView else { return 0 }
        
        let proportionalOffset = sliderView.scrollView.contentOffset.x / itemWidth
        ConsoleLog.show("proportionalOffset: \(proportionalOffset)")
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(self.viewModel.pageList.count - 1, index))
        return safeIndex
    }
    
    func prepareToolVC() {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        if let vc = s.instantiateViewController(withIdentifier: "FLToolViewController") as? FLToolViewController {
            self.toolVC = vc
            self.toolVC?.didChangeTextAlignment = Action(handler: { [weak self] (sender) in
                guard let a = sender as? FLTextAlignment else { return }
                self?.updateTextAlignment(a)
            })
            
            self.toolVC?.didChangeTextStyle = Action(handler: { [weak self] (sender) in
                guard let s = sender as? FLTextStyle else { return }
                self?.updateTextStyle(s)
            })
            
            self.toolVC?.didSelectedColor = Action(handler: { [weak self] (sender) in
                guard let self = self else { return }
                guard let flColor = sender as? FLColorResult else { return }
                let stageView = self.getStageView(at: self.viewModel.pageIndex)
                stageView.flColor = flColor
                stageView.isRequireSave = true
            })
            self.toolVC?.didChangeTextColor = Action(handler: { [weak self] (sender) in
                guard let self = self else { return }
                guard let flColor = sender as? FLColorResult else { return }
                if let iViewText = self.selectedView as? InteractTextView {
                    iViewText.flColorText = flColor
                }
                
            })
            
            self.toolVC?.didMediaPressed = Action(handler: { [weak self] (sender) in
                self?.openImagePicker()
            })
            
            self.toolVC?.didCreateText = Action(handler: { [weak self] (sender) in
                self?.createNewText()
            })
            
            self.toolVC?.didSelectedGraphic = Action(handler: { [weak self] (sender) in
                guard let self = self else { return }
                guard let graphic = sender as? FLGraphicResult else { return }
                let type = self.toolVC?.viewModel.graphicMenu
                self.createNewGraphic(type!, graphic: graphic)
            })
            
            self.toolVC?.didCreateQuiz = Action(handler: { [weak self] (sender) in
                guard let self = self else { return }
                self.viewModel.createNewQuiz { [weak self] (question) in
                    guard let q = question else { return }
                    self?.createNewQuiz(element: q)
                }
            })
            self.toolVC?.didClose = Action(handler: { [weak self] (sender) in
                guard let self = self else { return }
                if let tool = sender as? FLTool, tool == .text {
                    if let iViewText = self.selectedView as? InteractView,
                       let textView = iViewText.textView {
                        textView.resignFirstResponder()
                        
                    } else if let iViewText = self.selectedView as? InteractTextView,
                       let textView = iViewText.textView {
                        textView.resignFirstResponder()
                    }
                }
            })
            
            self.toolVC?.view.isHidden = true
            self.toolStackView.addArrangedSubview(self.toolVC!.view)
            self.addChild(self.toolVC!)
            self.toolVC?.didMove(toParent: self)
            
            self.toolVC?.setup(FLToolViewSetup(tool: .menu))
            if let page = self.viewModel.currentPageDetail {
                self.toolVC?.updatePageDetail(page)
            }
        }
    }
    
    func openToolBar(tool: FLTool, view: UIView? = nil) {
        if let toolVC = self.toolVC {
            toolVC.setup(FLToolViewSetup(tool: tool, view: view))
            toolVC.view.isHidden = false
        }
        if let page = self.viewModel.currentPageDetail {
            self.toolVC?.updatePageDetail(page)
        }
    }
    
    func createNewQuiz(element: FlashElement) {
        let row = self.indexOfMajorCell()
        
        self.selectedViewIsHiddenTool(true)
        
        let stageView = self.getStageView(at: row)
        stageView.isRequireSave = true
        if let quizView = stageView.createElement(element) as? FLQuizView {
            element.sort = stageView.subviews.count + 1
            self.manageQuizView(in: quizView, stageView: stageView)
        }
    }
    
    func createNewText() {
        let element = FlashElement.with(["type": FLType.text.rawValue])!
        element.isCreating = true
        element.width = 0
        element.x = 50
        element.y = 50
        element.text = FlashStyle.text.placeholder
        let row = self.indexOfMajorCell()
        
        self.selectedViewIsHiddenTool(true)
        
        let stageView = self.getStageView(at: row)
        stageView.isRequireSave = true
        if let iView = stageView.createElement(element) as? InteractTextView {
            element.sort = stageView.subviews.count + 1
            self.manageTextView(in: iView, stageView: stageView)
            
            DispatchQueue.main.async {
                //Auto select all test
                iView.textView?.selectAll(self)
                iView.isSelectAll = true
                iView.textView?.becomeFirstResponder()
                
                //Auto open text tool
                //self.openToolBar(tool: .text, view: iView)
                self.toolVC?.setup(FLToolViewSetup(tool: .text, view: iView))
                self.toolVC?.view.isHidden = false
                if let page = self.viewModel.currentPageDetail {
                    self.toolVC?.updatePageDetail(page)
                }
                self.toolVC?.open(.text, isCreating: true)
                self.selectedView = iView
                let size = iView.frame
                print("controlView width: \(size.width) ,controlView height: \(size.height)")
                
                iView.isHiddenEditingTool = false
            }
        }
    }
    
    func createNewGraphic(_ graphicType: FLGraphicMenu, graphic: FLGraphicResult) {
        let element = FlashElement.with(["type": graphicType.rawValue])!
        element.isCreating = true
        element.graphic = graphic
        element.x = 50
        element.y = 50
        element.graphicType = graphicType
        //element.image = graphic.uiimage//bug
        element.src = graphic.image
        let row = self.indexOfMajorCell()
        
        self.selectedViewIsHiddenTool(true)
        
        let stageView = self.getStageView(at: row)
        stageView.isRequireSave = true
        if let iView = stageView.createElement(element) as? InteractView {
            element.sort = stageView.subviews.count + 1
            self.manageIView(in: iView, stageView: stageView)
            iView.isHiddenEditingTool = false
        }
    }
    
    func createNewImage(_ image: UIImage, media: FLMediaResult?) {
        let type = FLType.image
        let element = FlashElement.with(["type": type.rawValue])!
        element.isCreating = true
        element.x = 50
        element.y = 50
        element.uiimage = image
        element.rawSize = image.size
        let row = self.indexOfMajorCell()
        element.media = media
        
        self.selectedViewIsHiddenTool(true)
        
        let stageView = self.getStageView(at: row)
        stageView.isRequireSave = true
        if let iView = stageView.createElement(element) as? InteractView {
            element.sort = stageView.subviews.count + 1
            self.manageIView(in: iView, stageView: stageView)
            iView.isHiddenEditingTool = false
        }
    }
    
    func createNewVideo(_ url: URL, size: CGSize, media: FLMediaResult?) {
        let type = FLType.video
        let element = FlashElement.with(["type": type.rawValue])!
        element.isCreating = true
        element.x = 50
        element.y = 50
        element.deviceVideoUrl = url
        element.rawSize = size
        let row = self.indexOfMajorCell()
        media?.deviceVideoUrl = url
        element.media = media
        element.type = type
        
        self.selectedViewIsHiddenTool(true)
        
        let stageView = self.getStageView(at: row)
        stageView.isRequireSave = true
        stageView.isVideoAutoPlay = true
        if let iView = stageView.createElement(element) as? InteractView {
            element.sort = stageView.subviews.count + 1
            iView.element = element
            self.manageIView(in: iView, stageView: stageView)
            iView.isHiddenEditingTool = false
            //fix for case createNewVideo playerView nil
            self.getStageView(at: row).playerView = iView.playerView
        }
    }
    
    func updateTextAlignment(_ alignment: FLTextAlignment) {
        guard let iView = self.selectedView as? InteractTextView else { return}
        iView.element?.flAlignment = alignment
        self.manageTextAtb()
    }
    
    func updateTextStyle(_ style: FLTextStyle = .regular) {
        guard let iView = self.selectedView as? InteractTextView else { return}
        guard let element = iView.element else { return }
        //update style in iView
        if let index = element.flTextStyle.firstIndex(of: style) {
            element.flTextStyle.remove(at: index)
        } else {
            if style != .regular {
                element.flTextStyle.append(style)
            }
        }
        //update flTextStyle to element
        let styleList = element.flTextStyle
        element.flTextStyle = styleList
        self.manageTextAtb()
    }
    
    func manageTextAtb() {
        guard let iView = self.selectedView as? InteractTextView else { return}
        guard let textView = iView.textView else { return }
        guard let element = iView.element else { return }
        let textColor = textView.textColor ?? .black
        let text = textView.text ?? ""
        
        let font = element.manageFontScale()
        let alignment = element.flAlignment.alignment()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = FlashStyle.text.lineHeight
        paragraph.alignment = alignment
        
        var atb: [NSAttributedString.Key:Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        if element.flTextStyle.contains(.underline) {
            atb[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        if text.count >= 1 {
            let atbString =  NSMutableAttributedString(string: text , attributes: atb)
            atbString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: atbString.length))
            textView.attributedText = atbString
            //textView.textAlignment = element.flAlignment.alignment()
        }
        
        let row = self.indexOfMajorCell()
        let stageView = self.getStageView(at: row)
        stageView.isRequireSave = true
    }
    
    func getStageView(at row: Int) -> FLStageView {
        guard let stageViewList = self.stageViewList,
                row < (stageViewList.count) else { return FLStageView() }
        let stageView = stageViewList[row]
        return stageView
    }
    
    func manageQuizView(in quizView:FLQuizView, stageView: FLStageView) {
        quizView.cardView.isUserInteractionEnabled = true
        quizView.cardView.addGestureRecognizer(PanGesture(target: self, action: #selector(self.moveVertical(_:))))
        quizView.didDelete = Action(handler: { (sender) in
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options:[]) {
                quizView.alpha = 0.0
            } completion: { (done) in
                quizView.removeFromSuperview()
            }
            stageView.isRequireSave = true
            self.toolVC?.quizMenu?.setQuizButtonEnable(true)
        })
        quizView.updateChoice = Action(handler: { (sender) in
            stageView.isRequireSave = true
        })
        self.checkQuizIn(stageView)
        stageView.quizManageSizeAnimate(quizView)
    }
    
    func manageIView(in iView:InteractView, stageView: FLStageView) {
        
        //TODO: add gesture pinch
        
        //iView.gesture = SnapGesture(view: iView)//need test some action
        iView.isCreateNew = true
        iView.isSelected = true
        
        iView.textView?.delegate = self
        iView.delegate = self
        
        let type = iView.element?.type ?? .unknow
        if iView.element!.isCreating {
            if type == .image {
                let page = self.viewModel.currentPageDetail
                self.viewModel.callAPIDropboxUpload(page, media: iView.element?.media, iView: iView) {
                    ConsoleLog.show("callAPIDropboxUpload")
                }
            } else if type == .video {
                iView.playerView?.playPressed()
                let page = self.viewModel.currentPageDetail
                self.viewModel.callAPIDropboxUpload(page, media: iView.element?.media, iView: iView) {
                        ConsoleLog.show("callAPIDropboxUpload")
                    }
            }
        }
        
        if let tool = iView.element?.tool {
            self.openToolBar(tool: tool, view: iView)
            self.toolVC?.open(tool, isCreating: true)
        }
        self.selectedView = iView
        let size = iView.frame
        print("controlView width: \(size.width) ,controlView height: \(size.height)")
    }
    
    func manageTextView(in iView:InteractTextView, stageView: FLStageView) {
        iView.textView?.isEditable = true
        iView.textView?.delegate = self
        iView.delegate = self
    }
    
    func mp4Convert(deviceVideoUrl: URL,  complete: @escaping (URL) -> Void) {
        if deviceVideoUrl.absoluteString.contains(find: ".mp4") {
            complete(deviceVideoUrl)
        } else {
            let videoCletertor = VideoConvertor(videoURL: deviceVideoUrl)
            videoCletertor.encodeVideo { (progress) in
                DispatchQueue.main.async {
                    print("progress: \(progress)")
                    if progress == 1.0 {
                        self.hideLoading()
                    } else {
                        let percent = progress * 100
                        self.showLoading("Video Progressing: \(percent)%")
                    }
                }
            } completion: { (url, error) in
                if let e = error {
                    print("error: \(e)")
                } else if let urlMP4 = url {
                    print("encodeVideo:\(urlMP4.absoluteString)")
                    complete(urlMP4)
                }
            }
        }
    }
    
    func updateTextViewHeight(_ iView:InteractView) {
        guard let textView = iView.textView else { return }
        let iViewFrame = iView.frame
        
        let textViewFrame = textView.frameFromContent(fixWidth: iView.contentFixWidth)
        textView.bounds = textViewFrame
        textView.setNeedsDisplay()
        
        iView.bounds = CGRect(x: 0, y: 0, width: iView.bounds.width, height: textViewFrame.height + FlashStyle.text.marginIView)
        iView.frame = CGRect(x: iViewFrame.origin.x, y: iViewFrame.origin.y, width: iView.bounds.width, height: textViewFrame.height + FlashStyle.text.marginIView)
        iView.setNeedsDisplay()
        iView.setPosition(.topRight, for: .close)
        iView.setPosition(.topLeft, for: .none)
        iView.setPosition(.bottomLeft, for: .flip)
        iView.setPosition(.bottomRight, for: .rotate)
        iView.updateEditUI()
    }
    
    func updateTextViewHeight(_ iView:InteractTextView) {
        guard let textView = iView.textView else { return }
        let iViewCenter = iView.center
        
        let textViewFrame = textView.frameFromContent(fixWidth: iView.contentFixWidth)
        textView.bounds = textViewFrame
        let iViewWidth = textViewFrame.width + FlashStyle.text.marginIView
        let iViewHeight = textViewFrame.height + FlashStyle.text.marginIView
        iView.bounds = CGRect(x: 0, y: 0, width: iViewWidth, height: iViewHeight)
        iView.center = iViewCenter
        iView.updateLayout()
        
        iView.setPosition(.topRight, handler: .close)
        iView.setPosition(.topLeft, handler: .none)
        iView.setPosition(.bottomLeft, handler: .flip)
        iView.setPosition(.bottomRight, handler: .rotate)
        
        iView.setImage(UIImage(named: "fl_delete"), handler: .close)
        iView.setImage(UIImage(named: "ic-fl-frame"), handler: .none)
        iView.setImage(UIImage(named: "ic-fl-frame"), handler: .flip)
        iView.setImage(UIImage(named: "ic-fl-frame"), handler: .rotate)
        UIView.animate(withDuration: 0.1) {
            
        } completion: { (done) in
            
        }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            
        } completion: { (done) in
            
            
        }
    }
    
    @objc func moveVertical(_ gesture: UIPanGestureRecognizer) {
        
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: self.stageView)
        print("movevertical")
        print("x : \(translation.x)")
        print("y : \(translation.y)")
        view.transform = view.transform.translatedBy(x: 0, y: translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.stageView)
        
        let stage = self.getStageView(at: self.viewModel.pageIndex)
        stage.isRequireSave = true
    }
    
    //Screen Rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.manageStageFrame(pageList: self.viewModel.pageList)
        
        if UIDevice.current.orientation.isLandscape {
            print("horizontal")
            //stackView.axis = .horizontal
            
        } else {
            print("vertical")
            //stackView.axis = .vertical
            
        }
    }
    
    @objc @IBAction func openImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPresetPassthrough
        //picker.allowsEditing = true //image can crop, video can cut
        
        //iOS 15 will usefull Hlaf and full screen
        //https://developer.apple.com/videos/play/wwdc2021/10063/
        //        if let sheet = picker.presentationController as? UISheetPresentationController {
        //            sheet.detents = [.medium(), .large()]
        //            sheet.smallestUndimmedDetentIdentifier = .medium
        //            sheet.prefersGrabberVisible = true
        //        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func saveCoverPage() {
        let stageView = self.getStageView(at: self.viewModel.pageIndex)
        self.selectedViewIsHiddenTool(true)
        
        stageView.prepareBeforeSaveView()
        
        guard let screenshot = self.createScreenshot(of: stageView) else { return }
        let coverImageBase64 = screenshot.jpegData(compressionQuality: 1)?.base64EncodedString()
        stageView.coverImageBase64 = coverImageBase64
        self.viewModel.currentPageDetail?.coverImageBase64 = coverImageBase64
    }
    
    func createScreenshot(of view: FLStageView) -> UIImage? {
        let size = CGSize(width: view.bounds.width, height: view.bounds.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    func countImageElement() -> Int {
        let index = self.indexOfMajorCell()
        let stage = self.getStageView(at: index)
        let iViewImageList = stage.subviews.filter { (view) -> Bool in
            if let iView = view as? InteractView {
                return iView.type == .image
            } else {
                return false
            }
        }
        return iViewImageList.count
    }
    
    private func isUnsupportedType(_ fileNname: String) -> Bool {
        let name = fileNname.lowercased()
        //case only ios mov converted to mp4
        if name.contains("mov")
            || name.contains("mp4")
            || name.contains("jpg")
            || name.contains("jpeg")
            || name.contains("png") {
            return false
        } else {
            return true
        }
    }
    
    var isManagingVideo = false
}

extension FLEditorViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let originalImage = info[.originalImage] as? UIImage {
            let imgUrl = info[.imageURL] as? URL
            let filename = imgUrl?.lastPathComponent ?? ""
            if self.isUnsupportedType(filename) {
                let and = "and".localized()
                let unsupportedtext = "\(filename) " + "upload_invalid_file_type".localized() + " .mp4, jpg, jpeg \(and) png"
                PopupManager.showWarning(unsupportedtext, at: self)
                return
            }
            
            let size = originalImage.size
            var newWidth: CGFloat = 1024
            if size.height > size.width {
                let ratio = size.width / size.height
                newWidth = 1024 * ratio
            }
            let img = originalImage.resizeImage(newWidth: newWidth)
            let imgData = img.jpeg ?? img.png
            guard let data = imgData else { return }
            var imageSize: Int = data.count
            print("actual size of image in KB: %f ", Double(imageSize) / 1024.0)
            
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            let string = bcf.string(fromByteCount: Int64(data.count))
            let mb = Units(bytes:Int64(data.count)).megabytes
            print("formatted result: \(string)\n \(mb)")
            let countImageElement = self.countImageElement()
            if countImageElement >= 20 {
                PopupManager.showWarning("warning_upload_card".localized(), at: self)
            } else if mb >= 10.0 {
                PopupManager.showWarning("warning_upload_size".localized(), at: self)
            } else {
                let uuid = UUID().uuidString
                let JSON:[String : Any] = ["filename" : filename, "size" : imageSize, "uuid" : uuid]
                let media = FLMediaResult(JSON: JSON)
                media?.imageData = data
                self.createNewImage(img, media: media)
            }
            
        } else if let movieUrl = info[.mediaURL] as? URL {
            print("movieUrl: \(movieUrl)")
            let filename = movieUrl.lastPathComponent
            if self.isUnsupportedType(filename) {
                let and = "and".localized()
                let unsupportedtext = "\(filename) " + "upload_invalid_file_type".localized() + " .mp4, jpg, jpeg \(and) png"
                PopupManager.showWarning(unsupportedtext, at: self)
                return
            }
            //TODO: check only 1 video per page
            let deviceAsset = AVURLAsset(url: movieUrl)
            let deviceSeconds = deviceAsset.duration.seconds
            print(deviceSeconds)
            if deviceSeconds > 60 {
                PopupManager.showWarning("warning_upload_length".localized(), at: self)
            } else {
                self.mp4Convert(deviceVideoUrl: movieUrl) { [weak self] (mp4Url) in
                    DispatchQueue.main.async {
                        let asset = AVURLAsset(url: mp4Url)
                        let mb = Units(bytes:Int64(asset.fileSize ?? 0)).megabytes
                        if mb > 50 {
                            PopupManager.showWarning("warning_upload_length".localized(), at: self)
                            return
                        } else {
                            self?.prepareNewVideo(asset: asset, movieUrl: movieUrl)
                        }
                    }
                }
            }
        }
    }
    
    func prepareNewVideo(asset: AVURLAsset, movieUrl: URL) {
        guard let track = asset.tracks(withMediaType: .video).first else { return }
        let sizeTransform = track.naturalSize.applying(track.preferredTransform)
        let size = CGSize(width: abs(sizeTransform.width), height: abs(sizeTransform.height))
        
        do {
            let fileAttributes = try asset.url.resourceValues(forKeys:[.nameKey, .fileSizeKey])
            let fileSize = fileAttributes.fileSize ?? 0
            let filename = movieUrl.lastPathComponent
            let JSON:[String : Any] = ["filename" : filename]
            let media = FLMediaResult(JSON: JSON)
            media?.size = fileSize
            media?.mp4VideoUrl = asset.url
            if let fileName = fileAttributes.name {
                media?.filename = fileName
            }
            print("video mp4 size: width \(size.width) height: \(size.height)")
            self.createNewVideo(movieUrl, size: size, media: media)
        } catch {
            print(error, movieUrl)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func manageVideoStop(row: Int) {
        let stageView = self.getStageView(at: row)
        stageView.playerView?.stop()
    }
    
    func manageVideoPlay(row: Int) {
        if !self.isManagingVideo,
            let stageViewList = self.stageViewList,
            row <= (stageViewList.count - 1) {
            self.isManagingVideo = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let stageView = self.getStageView(at: row)
                stageView.playerView?.stop()
                stageView.playerView?.playPressed()
                self.isManagingVideo = false
            }
        }
    }
    
    func manageScrollCenter(_ index:Int, scrollView: UIScrollView) {
        if !self.isManageScrolling {
            self.isManageScrolling = true
            print("manageScrollCenter: \(index)")
            let stageWidth = self.cellSize.width
            guard let sliderView = self.sliderView else { return }
            
            let allSpace = CGFloat(FlashStyle.stage.cellSpacing * CGFloat(index))
            let allWidth = stageWidth  * CGFloat(index)
            let removeWidth = allWidth + allSpace
            let w = (removeWidth) - (scrollView.contentSize.width)
            let centerOffsetX = (scrollView.contentSize.width + w)
            let centerOffsetY = scrollView.contentOffset.y
            let newX = centerOffsetX
            let offSet = CGPoint(x: newX, y: centerOffsetY)
            scrollView.setContentOffset(offSet, animated: true)
            self.manageVideoPlay(row: index)
            self.isManageScrolling = false
            
        }
    }
}

extension FLEditorViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let index = self.indexOfMajorCell()
        self.viewModel.pageIndex = index
        print("scrollViewWillBeginDragging: \(index)")
        self.saveCardPage(index: index)
        self.manageVideoStop(row: index)
    }
    
    func scrollViewDidScroll(_ scrollViewDidScroll: UIScrollView) {
        let index = self.indexOfMajorCell()
        print("scrollViewDidScroll:\(index)")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        
        //TODO: need improve
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = self.viewModel.pageIndex + 1 < self.viewModel.pageList.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = self.viewModel.pageIndex - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == self.viewModel.pageIndex
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let lineSpacing = FlashStyle.stage.cellSpacing
            let snapToIndex = self.viewModel.pageIndex + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = (self.cellSize.width + lineSpacing) * CGFloat(snapToIndex)
            print("snapToIndex:\(snapToIndex)")
            // Damping equal 1 => no oscillations => decay animation:
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
//                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
//                scrollView.layoutIfNeeded()
//            }, completion: nil)
            
            self.manageScrollCenter(indexOfMajorCell, scrollView: scrollView)
            
        } else {
            self.manageScrollCenter(indexOfMajorCell, scrollView: scrollView)
        }
        
        let stage = self.getStageView(at: indexOfMajorCell)
        self.checkQuizIn(stage)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let index = self.indexOfMajorCell()
        
        self.manageScrollCenter(index, scrollView: scrollView)
        
        print("scrollViewDidEndDragging: \(index)")
        let currentPage = self.viewModel.pageList[index]
        self.viewModel.pageIndex = index
        self.viewModel.currentPage = currentPage
        self.updatePageNumber()
        self.manageAddLR()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        //self.isManageScrolling = false
        /*
        var closestCell : UICollectionViewCell = collectionView.visibleCells()[0];
        for cell in collectionView!.visibleCells() as [UICollectionViewCell] {
            let closestCellDelta = abs(closestCell.center.x - collectionView.bounds.size.width/2.0 - collectionView.contentOffset.x)
            let cellDelta = abs(cell.center.x - collectionView.bounds.size.width/2.0 - collectionView.contentOffset.x)
            if (cellDelta < closestCellDelta){
                closestCell = cell
            }
        }
        let indexPath = collectionView.indexPathForCell(closestCell)
        collectionView.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        */
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
}


extension FLEditorViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.selectedViewIsHiddenTool(true)
        
        if let iView = textView.superview as? InteractView {
            iView.element?.text = textView.text
            self.selectedView = iView
            iView.isHiddenEditingTool = false
            self.openToolBar(tool: .text, view: iView)
            self.toolVC?.open(.text)
            
        } else if let iView = textView.superview as? InteractTextView {
            iView.element?.text = textView.text
            self.selectedView = iView
            iView.isHiddenEditingTool = false
            self.openToolBar(tool: .text, view: iView)
            self.toolVC?.element = iView.element
            self.toolVC?.open(.text)
            
            DispatchQueue.main.async {//special fix for textview jumping
                if let element = iView.element, element.isCreating, iView.contentFixWidth == nil {
                    iView.initialBounds = iView.bounds
                    iView.updateFixWidth(scale: 1.01, originalBounds: iView.bounds)
                    
                    //iView.updateLayout()
                    //iView.contentFixWidth = iView.bounds.width
                    //self.updateTextViewHeight(iView)
                    
                }
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let iView = textView.superview as? InteractView {
            iView.isSelected = false
        } else if let iView = textView.superview as? InteractTextView {
            if iView.isSelectAll {//end cycle of create Text if got .allSelect()
                iView.isSelectAll = false
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        ConsoleLog.show("replacementText: \(text)")
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let iView = textView.superview as? InteractView {
            iView.updateLayout()
            textView.updateLayout()
            print("text: \(String(describing: textView.text))")
            iView.element?.text = textView.text
            self.updateTextViewHeight(iView)
        } else if let iView = textView.superview as? InteractTextView {
            iView.element?.text = textView.text
            //TODO: bug text growing text jump up
            DispatchQueue.main.async {
                self.updateTextViewHeight(iView)
            }
        }
    }
    
}

extension FLEditorViewController: InteractViewDelegate {
    func interacViewDidTap(view: InteractView) {
    }
    
    func interacViewDidBeginMoving(view: InteractView) {
        
    }
    
    func interacViewDidClose(view: InteractView) {
        if self.toolVC?.viewModel.tool != .menu {
            self.toolVC?.closePressed(nil)
        }
        self.controlView?.isHidden = true
        
        self.manageVideoStop(row: self.viewModel.pageIndex)
        view.playerView?.player = nil
        view.removeFromSuperview()
        
    }
}

extension FLEditorViewController: InteractTextViewDelegate {
    func interacTextViewDidTap(view: InteractTextView) {
        self.selectedViewIsHiddenTool(true)
        
        self.selectedView = view
        self.selectedViewIsHiddenTool(false)
        if let textView = view.textView {
            textView.isUserInteractionEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                textView.becomeFirstResponder()
            }
        }
    }
    func interacTextViewDidBeginMoving(view: InteractTextView) {
        self.selectedView = view
        view.unSelectTextView()
        
        var stageView = view.superview as? FLStageView
        stageView?.isRequireSave = true
    }
    
    func interacTextViewDidEndMoving(view: InteractTextView) {
        if view.isOutOfSuperView() {
            view.removeFromSuperview()
            ConsoleLog.show("isOutOfSuperView removed")
        }
    }
    
    func interacTextViewDidClose(view: InteractTextView) {
        view.removeFromSuperview()
        if self.toolVC?.viewModel.tool != .menu {
            self.toolVC?.closePressed(nil)
        }
    }
    
    func interacTextViewDidBeginRotating(view: InteractTextView) {
        self.widthChange = view.bounds.width
        var stageView = view.superview as? FLStageView
        stageView?.isRequireSave = true
    }
    
    func interacTextViewDidChangeRotating(view: InteractTextView) {
        guard let element = view.element else { return }
        let degrees = Double(view.angle) * Double((180 / Float.pi))
        view.element?.rotation = NSNumber(value: degrees)
        view.element?.scale = NSNumber(value: Float(view.hardScale))
        print("stickerView angle: \(view.angle) degrees: \(degrees)")
        print("stickerView scale: \(view.hardScale)")
        var stageView = view.superview as? FLStageView
        stageView?.isRequireSave = true
        
        view.unSelectTextView()
        
        if element.type == .text {
            //*Need to scale font size
            //CHTStickerView not scale textview just change bounds
            let widthChange = (view.bounds.width / self.widthChange)
            print("widthChange scale: \(widthChange)")
            
            //let font = element.manageFont(scale: view.hardScale)
            view.textView?.font = element.font
        }
    }
    
    func interacTextViewDidChangeTranform(view: InteractTextView) {
        guard let element = view.element else { return }
        let degrees = Double(view.angle) * Double((180 / Float.pi))
        view.element?.rotation = NSNumber(value: degrees)
        view.element?.scale = NSNumber(value: Float(view.hardScale))
        print("stickerView angle: \(view.angle) degrees: \(degrees)")
        print("stickerView view.hardScale: \(view.hardScale)")
        var stageView = view.superview as? FLStageView
        stageView?.isRequireSave = true
    }
}


extension FLEditorViewController : CHTStickerViewDelegate {
    
    func stickerViewDidTap(_ stickerView: CHTStickerView!) {
        self.selectedViewIsHiddenTool(true)
        
        guard let iView = stickerView as? InteractView else { return }
        self.selectedView = iView
        self.selectedViewIsHiddenTool(false)
        
        //below need to update when CHTStickerView remove
        guard let element = iView.element else { return }
        if let textView = iView.textView {
            textView.isUserInteractionEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                textView.becomeFirstResponder()
            }
        }
    }
    
    func stickerViewDidBeginMoving(_ stickerView: CHTStickerView!) {
        self.selectedViewIsHiddenTool(true)
        
        guard let iView = stickerView as? InteractView else { return }
        self.selectedView = iView
        self.selectedViewIsHiddenTool(false)
        
        var stageView = stickerView.superview as? FLStageView
        stageView?.isRequireSave = true
        
        iView.unSelectTextView()
    }
    
    func stickerViewDidEndMoving(_ stickerView: CHTStickerView!) {
        guard let iView = stickerView as? InteractView else { return }
        if iView.isOutOfSuperView() {
            iView.removeFromSuperview()
        }
    }
    
    func stickerViewDidClose(_ stickerView: CHTStickerView!) {
        if self.toolVC?.viewModel.tool != .menu {
            self.toolVC?.closePressed(nil)
        }
        self.controlView?.isHidden = true
        
        let index = self.viewModel.pageIndex
        self.getStageView(at: index).playerView?.stopAndRemove()
        stickerView.removeFromSuperview()
    }
    
    
    func stickerViewDidBeginRotating(_ stickerView: CHTStickerView!) {
        self.widthChange = stickerView.bounds.width
        var stageView = stickerView.superview as? FLStageView
        stageView?.isRequireSave = true
    }
    
    func stickerViewDidChangeRotating(_ stickerView: CHTStickerView!) {
        guard let iView = stickerView as? InteractView else { return }
        guard let element = iView.element else { return }
        let degrees = Double(stickerView.angle) * Double((180 / Float.pi))
        iView.element?.rotation = NSNumber(value: degrees)
        iView.element?.scale = NSNumber(value: Float(iView.hardScale))
        print("stickerView angle: \(stickerView.angle) degrees: \(degrees)")
        print("stickerView scale: \(iView.hardScale)")
        
        iView.unSelectTextView()
        
        if element.type == .text {
            //*Need to scale font size
            //CHTStickerView not scale textview just change bounds
            let widthChange = (stickerView.bounds.width / self.widthChange)
            print("widthChange scale: \(widthChange)")
            //let font = element.manageFontScale(scale: iView.hardScale)
            iView.textView?.font = element.font
            // update font size
        }
    }
    
    func stickerViewDidEndRotating(_ stickerView: CHTStickerView!) {
        stickerView.updateLayout()
        guard let iView = stickerView as? InteractView else { return }
        self.selectedView = iView
        guard let element = iView.element else { return }
        
        print("element.fontScale: \(element.fontScale)")
        
        if element.type == .text {
            //iView.textView?.updateLayout()
            element.updateNewFontSize()
        }
        
        var stageView = stickerView.superview as? FLStageView
        stageView?.isRequireSave = true
    }
}
