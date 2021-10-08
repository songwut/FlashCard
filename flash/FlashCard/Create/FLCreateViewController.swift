//
//  FLCreateViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 1/7/2564 BE.
//

import UIKit
import AVKit
import SwiftUI
import Photos

struct FLStageSetUp {
   
    var eventId: Int
}


final class FLCreateViewController: UIViewController {
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
    private var isCreatePage = true
    private var controlView: FLControlView?
    var selectedView: UIView?
    var widthChange:CGFloat = 0.0
    
    var toolVC: FLToolViewController?
    var viewModelDelegate: FLStageViewModelProtocol!
    var viewModel = FLStageViewModel()
    
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
    
    func setUp(input: FLStageSetUp) {
        viewModel = FLStageViewModel()
        viewModel.stageVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.updateLayout()
        self.view.backgroundColor = .background()
        self.topView.backgroundColor = .background()
        self.contentPageView.backgroundColor = .background()
        self.menuView.backgroundColor = .background()
        self.topViewHeight.constant = UIDevice.isIpad() ? 58 : 40
        self.stageViewList = [FLStageView]()
        
        self.view.backgroundColor = FlashStyle.screenColor
        self.contentToolHeight.constant = FlashStyle.contentToolHeight
        
        self.addButton.updateLayout()
        self.addButton.cornerRadius = self.addButton.bounds.width / 2
        self.addButton.backgroundColor = UIColor.config.primary()
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
        self.contentPageView.addSubview(self.sliderView!)
        
        self.contentPageView.addSubview(self.deletePageButton!)
        self.contentPageView.addSubview(self.addLeftPageButton!)
        self.contentPageView.addSubview(self.addRightPageButton!)
        self.deletePageButton?.addTarget(self, action: #selector(self.deletePressed(_:)), for: .touchUpInside)
        
        self.flCreator = FLCreator(stage: self.stageView!)
        
        self.listButton.addTarget(self, action: #selector(self.listButtonPressed(_:)), for: .touchUpInside)
        
        self.addButton.addTarget(self, action: #selector(self.addButtonPressed(_:)), for: .touchUpInside)
        self.addLeftPageButton?.addTarget(self, action: #selector(self.appLeftPressed(_:)), for: .touchUpInside)
        self.addRightPageButton?.addTarget(self, action: #selector(self.addRightPressed(_:)), for: .touchUpInside)
        
        self.prepareToolVC()
        self.view.alpha = 0.0
        self.viewModel.callAPIFlashCard { [weak self] (cardResult: FlFlashDetailResult?) in
            if let object = cardResult {
                ConsoleLog.show("total:\(object.total)")
                ConsoleLog.show("list:\(object.list)")
                UIView.animate(withDuration: 0.3) {
                    self?.view.alpha = 1.0
                }
                self?.manageStageFrame()
            }
            
            self?.viewModel.callAPICurrentPageDetail(complete: {
                ConsoleLog.show("callAPIPageDetail")
            })
        }
    }
    
    @objc func deletePressed(_ sender: UIButton) {
        self.saveCoverPage()
    }
    
    @objc func appLeftPressed(_ sender: UIButton) {
        
        self.saveCoverPage()
        
        let index = self.viewModel.pageIndex
        let newIndex = index - 1
        let page = FLCardPageResult(JSON: ["index" : newIndex])!
        self.viewModel.pageList.insert(page, at: newIndex)
        
        guard let stackView = self.sliderView?.contentStackView else {return}
        let frame = self.stageView?.frame ?? .zero
        let stage = self.createStageView(frame.size, creator: self.flCreator!)
        stage.page = page
        stackView.insertArrangedSubview(stage, at: newIndex)
        self.stageViewList?.insert(stage, at: newIndex)
        
        self.gotoPage(index: newIndex)
    }
    
    @objc func addRightPressed(_ sender: UIButton) {
        
        self.saveCoverPage()
        
        let index = self.viewModel.pageIndex
        let newIndex = index + 1
        let page = FLCardPageResult(JSON: ["index" : newIndex])!
        self.viewModel.pageList.insert(page, at: newIndex)
        
        guard let stackView = self.sliderView?.contentStackView else {return}
        let frame = self.stageView?.frame ?? .zero
        let stage = self.createStageView(frame.size, creator: self.flCreator!)
        stage.page = page
        stackView.insertArrangedSubview(stage, at: newIndex)
        self.stageViewList?.insert(stage, at: newIndex)
        
        self.gotoPage(index: newIndex)
    }
    
    func gotoPage(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.viewModel.pageIndex = index
        self.manageAddLR()
        let max = self.viewModel.pageList.count
        self.pageCountLabel.text = "\(index + 1)/\(max)"
    }
    
    func createAddButton() -> UIButton {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(named: "plus"), for: .normal)
        let w = FlashStyle.addPageWidth
        b.bounds = CGRect(x: 0, y: 0, width: w, height: w)
        b.backgroundColor = .white
        b.tintColor = UIColor("7E858E")
        b.cornerRadius = w / 2
        //b.borderWidth = 1
        //b.borderColor = UIColor("D7DFE9")
        b.addDash(1, color: UIColor("D7DFE9"))
        return b
    }
    
    @objc func stageTaped(_ sender: TapGesture) {
        self.view.endEditing(true)
        self.toolVC?.closePressed(nil)
    }
    
    func manageStageFrame() {
        self.contentPageView.updateLayout()
        DispatchQueue.main.async {
            print("self.view:\(self.view.frame)")
            print("self.contentPageView:\(self.contentPageView.frame)")
            
            let areaFrame = self.contentPageView.frame
            
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
            self.stageView?.frame = stageFrame
            self.stageView?.stageRatio = stageFrame.width / FlashStyle.baseStageWidth
            let stageView = self.stageView!
            self.deletePageButton?.center = CGPoint(x: stageView.center.x, y: stageView.frame.origin.y)
            
            self.addLeftPageButton?.center = CGPoint(x: stageView.frame.origin.x, y: stageView.center.y)
            
            self.addRightPageButton?.center = CGPoint(x: stageView.frame.origin.x + stageView.frame.width, y: stageView.center.y)
            
            self.manageAddLR()
            
            let edge = stageFrame.origin.x
            self.sectionEdge = UIEdgeInsets(top: 0, left: edge, bottom: 0, right: edge)
            self.cellSize = stageFrame.size
            
            self.sliderView?.frame = CGRect(x: 0, y: 0, width: areaFrame.width, height: areaFrame.height)
            self.sliderView?.stackHeight.constant = stageFrame.height
            self.sliderView?.leftWidth.constant = self.sectionEdge.left
            self.sliderView?.rightWidth.constant = self.sectionEdge.right
            
            self.controlView = FLControlView.instanciateFromNib()
            self.controlView?.leftWidthButton.tag = FLTag.left.rawValue
            self.controlView?.rightWidthButton.tag = FLTag.right.rawValue
            
            self.controlView?.isHidden = true
            
            
            stageView.isHidden = true
            
            if self.isCreatePage {
                self.manageMultitleStage()
            }
            
            
        }
    }
    
    func createStageView(_ size: CGSize, creator: FLCreator) -> FLStageView {
        let f = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let stage = FLStageView(frame: f)
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
        
        return stage
    }
    
    
    
    func manageMultitleStage() {
        guard let stackView = self.sliderView?.contentStackView else {return}
        stackView.removeAllArranged()
        let frame = self.stageView?.frame ?? CGRect.zero
        for page in self.viewModel.pageList {
            let stage = self.createStageView(frame.size, creator: self.flCreator!)
            stage.page = page
            self.stageViewList?.append(stage)
            stackView.addArrangedSubview(stage)
        }
        stackView.layoutIfNeeded()
        self.sliderView?.scrollView.delegate = self
        self.sliderView?.scrollView.isScrollEnabled = false//TODO: detech active
        self.isCreatePage = false
    }
    
    func selectedViewIsHiddenTool(_ isHiddenEditingTool: Bool) {
        if let iView = self.selectedView as? InteractView {
            iView.isHiddenEditingTool = true
        } else if let iView = self.selectedView as? InteractTextView {
            iView.isHiddenEditingTool = true
        }
    }
    
    @objc func swipeStage(_ gesture: UISwipeGestureRecognizer) {
        self.selectedViewIsHiddenTool(true)
        self.saveCoverPage()
        
        switch gesture.direction {
        case .right:
            print("Swiped right")
            
            //TODO: go next page
            break
        case .left:
            print("Swiped left")
            break
        default:
            break
        }
    }
    
    var sectionEdge = UIEdgeInsets.zero
    var cellSize = CGSize.zero
    
    func manageAddLR() {
        if self.viewModel.pageIndex == 0 {
            self.addLeftPageButton?.isHidden = true
            self.addRightPageButton?.isHidden = false
            
        } else if self.viewModel.pageIndex == (self.viewModel.pageList.count - 1) {
            self.addLeftPageButton?.isHidden = false
            self.addRightPageButton?.isHidden = true
            
        } else {
            self.addLeftPageButton?.isHidden = false
            self.addRightPageButton?.isHidden = false
        }
    }
    
    @objc func addButtonPressed(_ sender: UIButton) {
        self.openToolBar(tool: .menu)
    }
    
    @objc func listButtonPressed(_ sender: UIButton) {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        if let vc = s.instantiateViewController(withIdentifier: "FLListViewController") as? FLListViewController {
            
            if let nav = self.navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = self.cellSize.width
        guard let sliderView = self.sliderView else { return 0 }
        let proportionalOffset = sliderView.scrollView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(self.viewModel.pageList.count - 1, index))
        return safeIndex
    }
    
    var halfModalDelegate: HalfModalTransitioningDelegate!
    
    func openQuizStatVC() {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        if #available(iOS 13.0, *) {
            if let vc = s.instantiateViewController(identifier: "FLQuizInfoViewController") as? FLQuizInfoViewController {
                // toolHelper = FLToolHelper(vc: self, toolBar: vc)
                //tool parameter
                
                self.halfModalDelegate.startHeight = 150 + vc.safeAreaTopHeight
                self.halfModalDelegate.backgroundColor = .clear
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self.halfModalDelegate
                self.present(vc, animated: true, completion: nil)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func prepareToolVC() {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        //        if let vc = s.instantiateViewController(identifier: "FLToolViewController") as? FLToolViewController {
        //            // toolHelper = FLToolHelper(vc: self, toolBar: vc)
        //            //tool parameter
        //
        //            vc.didSelectedColor = Action(handler: { (sender) in
        //                guard let hex = sender as? String else { return }
        //                self.stageView.backgroundColor = UIColor(hex)
        //            })
        //            vc.didCreateText = Action(handler: { (sender) in
        //                let element = TextElement()
        //                self.createTextView(element)
        //            })
        //            self.halfModalDelegate = HalfModalTransitioningDelegate(viewController: vc, presentingViewController: vc)
        //            vc.setup(FLToolViewSetup(tool: .none))
        //
        //            self.halfModalDelegate.startHeight = 150 + vc.safeAreaTopHeight
        //            self.halfModalDelegate.backgroundColor = .clear
        //            vc.modalPresentationStyle = .custom
        //            vc.transitioningDelegate = self.halfModalDelegate
        //            self.present(vc, animated: true, completion: nil)
        //        }
        
        //add child
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
                    self?.createNewQuiz(question: q)
                }
            })
            self.toolVC?.didClose = Action(handler: { [weak self] (sender) in
                guard let self = self else { return }
                //self.view.endEditing(true)
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
    
    func createNewQuiz(question: FLQuestionResult) {
        let element = FlashElement.with(["type": FLType.quiz.rawValue])!
        element.question = question
        let row = self.indexOfMajorCell()
        self.createElement(element, row: row)
    }
    
    func createNewText() {
        let element = FlashElement.with(["type": FLType.text.rawValue])!
        element.width = 0
        element.x = 50
        element.y = 50
        element.text = FlashStyle.text.placeholder
        let row = self.indexOfMajorCell()
        self.createElement(element, row: row)
    }
    
    func createNewGraphic(_ graphicType: FLGraphicMenu, graphic: FLGraphicResult) {
        let element = FlashElement.with(["type": graphicType.rawValue])!
        element.x = 50
        element.y = 50
        element.graphicType = graphicType
        //element.image = graphic.uiimage//bug
        element.src = graphic.image
        let row = self.indexOfMajorCell()
        self.createElement(element, row: row)
    }
    
    func createNewImage(_ image: UIImage, media: FLMediaResult?) {
        let type = FLType.image
        let element = FlashElement.with(["type": type.rawValue])!
        element.x = 50
        element.y = 50
        element.uiimage = image
        element.rawSize = image.size
        let row = self.indexOfMajorCell()
        self.createElement(element, row: row, media: media)
    }
    
    func createNewVideo(_ url: URL, size: CGSize, media: FLMediaResult?) {
        let type = FLType.video
        let element = FlashElement.with(["type": type.rawValue])!
        element.x = 50
        element.y = 50
        element.deviceVideoUrl = url
        element.rawSize = size
        let row = self.indexOfMajorCell()
        media?.deviceVideoUrl = url
        self.createElement(element, row: row, media: media)
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
        
        let font = element.manageFont()
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
    }
    
    func getStageView(at row: Int) -> FLStageView {
        //let stageView = self.sliderView?.contentStackView.arrangedSubviews[row]
        let stageView = self.stageViewList?[row]
        return stageView ?? FLStageView()
    }
    
    func createElement(_ element: FlashElement, row: Int , media: FLMediaResult? = nil) {
        self.selectedViewIsHiddenTool(true)
        
        if element.type == .text {
            self.createTextView(element, row: row)
            
        } else if element.type == .image {
            self.createIView(element, row: row, media: media)
            
        } else if element.type == .sticker {
            self.createIView(element, row: row)
            
        } else if element.type == .shape {
            self.createIView(element, row: row)
            
        }  else if element.type == .video {
            self.createIView(element, row: row,  media: media)
            
        }  else if element.type == .quiz {
            self.createQuizView(element, row: row)
        }
        self.viewModel.save(element: element, at: row)
    }
    
    func createQuizView(_ element: FlashElement, row: Int) {
        
        let stageView = self.getStageView(at: row)
        if let quizView = stageView.createElement(element) as? FLQuizView {
            quizView.createNewUI(question: element.question)
            quizView.isUserInteractionEnabled = true
            quizView.addGestureRecognizer(PanGesture(target: self, action: #selector(self.moveVertical(_:))))
            quizView.alpha = 0.0
            //quizView.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
            quizView.didDelete = Action(handler: { (sender) in
                UIView.animateKeyframes(withDuration: 0.2, delay: 0, options:[]) {
                    quizView.alpha = 0.0
                } completion: { (done) in
                    quizView.removeFromSuperview()
                }
                self.toolVC?.quizMenu?.setQuizButtonEnable(true)
            })
            self.toolVC?.quizMenu?.setQuizButtonEnable(false)
        }
        
    }
    
    func createIView(_ element: FlashElement, row: Int, media: FLMediaResult? = nil) {
        
        let stageView = self.getStageView(at: row)
        if let iView = stageView.createElement(element) as? InteractView {
            iView.outlineBorderColor = .black
            iView.setImage(UIImage(named: "fl_delete"), for: .close)
            iView.setImage(UIImage(named: "ic-fl-frame"), for: .none)
            iView.setImage(UIImage(named: "ic-fl-frame"), for: .flip)
            iView.setImage(UIImage(named: "ic-fl-frame"), for: .rotate)
            iView.setHandlerSize(Int(FlashStyle.text.marginIView))
//            iView.enableClose = true
//            iView.enableFlip = false
//            iView.enableRotate = false
//            iView.enableNone = false
            
            //iView.gesture = SnapGesture(view: iView)
            
            iView.isCreateNew = true
            //Auto select all test
            iView.textView?.selectAll(self)
            iView.textView?.becomeFirstResponder()
            iView.isSelected = true
            iView.textView?.delegate = self
            iView.delegate = self
            
            if element.type == .image {
                
            } else if element.type == .video {
                if let deviceVideoUrl = element.deviceVideoUrl {
                    
                }

            }
            
            if let tool = element.tool {
                self.openToolBar(tool: tool, view: iView)
                self.toolVC?.open(tool, isCreating: true)
            }
            self.selectedView = iView
            let size = iView.frame
            print("controlView width: \(size.width) ,controlView height: \(size.height)")
            
        }
    }
    
    func createTextView(_ element: FlashElement, row: Int) {
        
        let stageView = self.getStageView(at: row)
        if let iView = stageView.createElement(element) as? InteractTextView {
//            iView.enableClose = true
//            iView.enableFlip = false
//            iView.enableRotate = false
//            iView.enableNone = false
            
            //iView.gesture = SnapGesture(view: iView)
            
            //iView.isCreateNew = true
            iView.textView?.isEditable = true
            iView.textView?.selectAll(self)//Auto select all test
            iView.textView?.delegate = self
            iView.textView?.becomeFirstResponder()
            iView.delegate = self
            
            self.openToolBar(tool: .text, view: iView)
            self.toolVC?.open(.text, isCreating: true)
            self.selectedView = iView
            let size = iView.frame
            print("controlView width: \(size.width) ,controlView height: \(size.height)")
//            if let controlView = self.controlView {
//                textElement.update(controlView: controlView)
//                stageView.addSubview(controlView)
//                //stageView.addSubview(controlView.deleteButton)
//                controlView.updateRelateView(textElement)
//            }
            
        }
    }
    
    func mp4Convert(deviceVideoUrl: URL,  complete: @escaping (URL) -> Void) {
        var videoCletertor = VideoConvertor(videoURL: deviceVideoUrl)
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
//                            self.viewModel.callAPIDropboxUpload(type: element.type, row: row, media: media, iView: iView) {
//
//                            }
            }
        }
    }
    
    
    func updateTextviewHeight(_ iView:InteractView) {
        guard let textView = iView.textView else { return }
        let iViewFrame = iView.frame
        let textViewPoint = textView.frame.origin
        
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
        
        //update icon tool after bounds change
        iView.setImage(UIImage(named: "fl_delete"), for: .close)
        iView.setImage(UIImage(named: "ic-fl-frame"), for: .none)
        iView.setImage(UIImage(named: "ic-fl-frame"), for: .flip)
        iView.setImage(UIImage(named: "ic-fl-frame"), for: .rotate)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            
        } completion: { (done) in
            
        }
        
        //let newSize = textView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        //textView.frame = CGRect(origin: textView.frame.origin, size: newSize)
    }
    
    func updateTextviewHeight(_ iView:InteractTextView) {
        guard let textView = iView.textView else { return }
        let iViewCenter = iView.center
        let iViewFrame = iView.frame
        let textViewPoint = textView.frame.origin
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            let textViewFrame = textView.frameFromContent(fixWidth: iView.contentFixWidth)
            textView.bounds = textViewFrame
            //textView.setNeedsDisplay()
            let iViewWidth = textViewFrame.width + FlashStyle.text.marginIView
            let iViewHeight = textViewFrame.height + FlashStyle.text.marginIView
            iView.bounds = CGRect(x: 0, y: 0, width: iViewWidth, height: iViewHeight)
            iView.center = iViewCenter//if use set frame will get bug
            //iView.frame = CGRect(x: iViewFrame.origin.x, y: iViewFrame.origin.y, width: iViewWidth, height: iViewHeight)
            //iView.setNeedsDisplay()
            iView.updateLayout()
            
            //Step 2 for update current frame
        } completion: { (done) in
            
            UIView.animate(withDuration: 0.1) {
                iView.setPosition(.topRight, handler: .close)
                iView.setPosition(.topLeft, handler: .none)
                iView.setPosition(.bottomLeft, handler: .flip)
                iView.setPosition(.bottomRight, handler: .rotate)
                
                //update icon tool after bounds change
                iView.setImage(UIImage(named: "fl_delete"), handler: .close)
                iView.setImage(UIImage(named: "ic-fl-frame"), handler: .none)
                iView.setImage(UIImage(named: "ic-fl-frame"), handler: .flip)
                iView.setImage(UIImage(named: "ic-fl-frame"), handler: .rotate)
            } completion: { (done) in
                
            }

            
        }
        
        //let newSize = textView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        //textView.frame = CGRect(origin: textView.frame.origin, size: newSize)
    }
    
    @objc func moveVertical(_ gesture: UIPanGestureRecognizer) {
        
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: self.stageView)
        print("movevertical")
        print("x : \(translation.x)")
        print("y : \(translation.y)")
        view.transform = view.transform.translatedBy(x: 0, y: translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.stageView)
        
        if gesture.state == .began {
            
        } else if gesture.state == .ended {
            print("quiz view frame : \(view.frame)")//matgintop 16
        }
        
    }
    
    //Screen Rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.manageStageFrame()
        
        if UIDevice.current.orientation.isLandscape {
            print("horizontal")
            //stackView.axis = .horizontal
            
        } else {
            print("vertical")
            //stackView.axis = .vertical
            
        }
    }
    
    @objc @IBAction func openImagePicker() {
        //TODO: show alert popup
        //image > 20
        //image > 4 MB
        //size, check image
        //video > 60s
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPresetHEVC1920x1080
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
        
        guard let screenshot = self.createScreenshot(of: stageView) else { return }
        let coverImageBase64 = screenshot.jpegData(compressionQuality: 1)?.base64EncodedString()
        self.viewModel.currentPageDetail?.coverImageBase64 = coverImageBase64
        //UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(self.imageWasSaved), nil)//TODO: remove when done
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
        
    
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print("Image was saved in the photo gallery")
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
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
    
}

extension UIImage {
    // QUALITY min = 0 / max = 1
    var jpeg: Data? { jpegData(compressionQuality: 1) }
    var png: Data? { pngData() }
}

extension FLCreateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let originalImage = info[.originalImage] as? UIImage {
            let size = originalImage.size
            var newWidth: CGFloat = 1024
            if size.height > size.width {// 3000, 2000
                let ratio = size.width / size.height
                newWidth = 1024 * ratio
            }
            //TODO: retest
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
                PopupManager.showWarning("You can upload 20 images per page !", at: self)
            } else if mb >= 10.0 {
                PopupManager.showWarning("Your image is too powerful\n(Maximum size is 4 MB)\nPlease upload again", at: self)
            } else {
                let imgUrl = info[.imageURL] as? URL
                let filename = imgUrl?.lastPathComponent ?? ""
                let imageBase64 = data.base64EncodedData()
                let uuid = UUID().uuidString
                let JSON:[String : Any] = ["filename" : filename, "size" : imageSize, "uuid" : uuid]
                let media = FLMediaResult(JSON: JSON)
                media?.imageData = data//imageBase64
                self.createNewImage(img, media: media)
            }
            
        } else if let movieUrl = info[.mediaURL] as? URL {
            print("movieUrl: \(movieUrl)")
            //TODO: check only 1 video per page
            let deviceAsset = AVURLAsset(url: movieUrl)
            let deviceSeconds = deviceAsset.duration.seconds
            print(deviceSeconds)
            if deviceSeconds > 60 {
                PopupManager.showWarning("Your video is too powerful\n(Maximum length is 60 seconds)\nPlease upload again", at: self)
            } else {
                self.mp4Convert(deviceVideoUrl: movieUrl) { [weak self] (mp4Url) in
                    DispatchQueue.main.async {
                        let asset = AVURLAsset(url: mp4Url)
                        let seconds = asset.duration.seconds
                        guard let track = asset.tracks(withMediaType: .video).first else { return }
                        let size = track.naturalSize.applying(track.preferredTransform)
                        
                        do {
                            let fileAttributes = try mp4Url.resourceValues(forKeys:[.nameKey, .fileSizeKey])
                            print(fileAttributes.name!) // is String
                            print(fileAttributes.fileSize!) // is Int
                            let fileSize = fileAttributes.fileSize ?? 0
                            let filename = movieUrl.lastPathComponent
                            let JSON:[String : Any] = ["filename" : filename]
                            let media = FLMediaResult(JSON: JSON)
                            print("video mp4 size: width \(size.width) height: \(size.height)")
                            self?.createNewVideo(movieUrl, size: size, media: media)
                        } catch {
                            print(error, movieUrl)
                        }
                        
                    }
                }
                
                
            }
        }
        //        MediaManager.trimVideo(movieUrl) { [weak self] (destinationURL) in
        //            //self?.play(destinationURL)
        //            //TODO: create element image, video
        //        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension FLCreateViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.viewModel.pageIndex = self.indexOfMajorCell()
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
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
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            //self.layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        let max = self.viewModel.pageList.count
        let index = self.indexOfMajorCell()
        self.viewModel.pageIndex = index
        self.pageCountLabel.text = "\(index + 1)/\(max)"
        
        let stage = self.getStageView(at: index)
        stage.addGestureRecognizer(TapGesture(target: self, action: #selector(self.stageTaped(_:))))
        self.manageAddLR()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
}


extension FLCreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.selectedViewIsHiddenTool(true)
        
        if let iView = textView.superview as? InteractView {
            self.selectedView = iView
            iView.isHiddenEditingTool = false
            self.openToolBar(tool: .text, view: iView)
            self.toolVC?.open(.text)
            
        } else if let iView = textView.superview as? InteractTextView {
            self.selectedView = iView
            iView.isHiddenEditingTool = false
            self.openToolBar(tool: .text, view: iView)
            self.toolVC?.open(.text)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let iView = textView.superview as? InteractView {
            iView.isSelected = false
        } else if let iView = textView.superview as? InteractTextView {
            //iView.isSelected = false
        }
        //self.selectedViewIsHiddenTool(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        ConsoleLog.show("replacementText: \(text)")
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let iView = textView.superview as? InteractView {
            iView.updateLayout()
            textView.updateLayout()
            print("text: \(textView.text)")
            self.updateTextviewHeight(iView)
        } else if let iView = textView.superview as? InteractTextView {
            //iView.updateLayout()
            //textView.updateLayout()
            /* TODO: solution for width from text */
//            print("text: \(textView.text)")
//            let string = textView.text ?? ""
//            let font = textView.font!
//            let width = string.size(font: font).width
//            print("contentFixWidth: \(width)")
//            iView.contentFixWidth = width//TODO: bug text growing
            DispatchQueue.main.async {
                self.updateTextviewHeight(iView)
            }
        }
    }
    
}

extension FLCreateViewController: InteractViewDelegate {
    func interacViewDidTap(view: InteractView) {
    }
    
    func interacViewDidBeginMoving(view: InteractView) {
        
    }
    
    func interacViewDidClose(view: InteractView) {
        view.removeFromSuperview()
        if self.toolVC?.viewModel.tool != .menu {
            self.toolVC?.closePressed(nil)
        }
        self.controlView?.isHidden = true
        //self.controlView?.deleteButton.isHidden = true
        
    }
}

extension FLCreateViewController: InteractTextViewDelegate {
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
    }
    
    func interacTextViewDidClose(view: InteractTextView) {
        view.removeFromSuperview()
        if self.toolVC?.viewModel.tool != .menu {
            self.toolVC?.closePressed(nil)
        }
    }
    
    func interacTextViewDidBeginRotating(view: InteractTextView) {
        self.widthChange = view.bounds.width
    }
    
    func interacTextViewDidChangeRotating(view: InteractTextView) {
        guard let element = view.element else { return }
        let degrees = Double(view.angle) * Double((180 / Float.pi))
        view.element?.rotation = Float(degrees)
        view.element?.scale = Float(view.hardScale)
        print("stickerView angle: \(view.angle) degrees: \(degrees)")
        print("stickerView scale: \(view.hardScale)")
        
        view.unSelectTextView()
        
        if element.type == .text {
            //*Need to scale font size
            //CHTStickerView not scale textview just change bounds
            let widthChange = (view.bounds.width / self.widthChange)
            print("widthChange scale: \(widthChange)")
            let font = element.manageFont(scale: view.hardScale)
            view.textView?.font = font
            // update font size
        }
    }
}


extension FLCreateViewController : CHTStickerViewDelegate {
    
    func stickerViewDidTap(_ stickerView: CHTStickerView!) {
        self.selectedViewIsHiddenTool(true)
        
        guard let iView = stickerView as? InteractView else { return }
        self.selectedView = iView
        self.selectedViewIsHiddenTool(false)
        guard let element = iView.element else { return }
        if let textView = iView.textView {
            textView.isUserInteractionEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                textView.becomeFirstResponder()
            }
        }
        
    }
    
    func stickerViewDidBeginMoving(_ stickerView: CHTStickerView!) {
        guard let iView = stickerView as? InteractView else { return }
        self.selectedView = iView
        
        iView.unSelectTextView()
    }
    
    func stickerViewDidClose(_ stickerView: CHTStickerView!) {
        stickerView.removeFromSuperview()
        if self.toolVC?.viewModel.tool != .menu {
            self.toolVC?.closePressed(nil)
        }
        self.controlView?.isHidden = true
    }
    
    
    func stickerViewDidBeginRotating(_ stickerView: CHTStickerView!) {
        self.widthChange = stickerView.bounds.width
    }
    
    func stickerViewDidChangeRotating(_ stickerView: CHTStickerView!) {
        guard let iView = stickerView as? InteractView else { return }
        guard let element = iView.element else { return }
        let degrees = Double(stickerView.angle) * Double((180 / Float.pi))
        iView.element?.rotation = Float(degrees)
        iView.element?.scale = Float(iView.hardScale)
        print("stickerView angle: \(stickerView.angle) degrees: \(degrees)")
        print("stickerView scale: \(iView.hardScale)")
        
        iView.unSelectTextView()
        
        if element.type == .text {
            //*Need to scale font size
            //CHTStickerView not scale textview just change bounds
            let widthChange = (stickerView.bounds.width / self.widthChange)
            print("widthChange scale: \(widthChange)")
            let font = element.manageFont(scale: iView.hardScale)
            iView.textView?.font = font
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
    }
}
