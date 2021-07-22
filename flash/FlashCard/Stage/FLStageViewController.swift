//
//  FLStageViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 1/7/2564 BE.
//

import UIKit
import CollectionViewPagingLayout
import AVKit
import SwiftUI

final class FLStageViewController: UIViewController {
    
    var viewModel = FLStageViewModel()
    
    @IBOutlet private weak var contentPageView: UIView!
    @IBOutlet private weak var toolStackView: UIStackView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var layout: UICollectionViewFlowLayout!
    @IBOutlet private weak var contentToolHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var menuView: UIView!
    @IBOutlet private weak var pageCountLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var previewButton: UIButton!
    @IBOutlet private weak var listButton: UIButton!
    
    private var stageView: UIView!
    private var sliderView: FLSliderView!
    private var stageViewList = [FLStageView]()
    private var stageCell: UICollectionViewCell!
    private var flCreator: FLCreator!
    private var didScrollCollectionViewToMiddle = false
    private var isCreatePage = true
    private var controlView = FLControlView.instanciateFromNib()
    
    
    lazy var deletePageButton: UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(named: "ic_v2_delete"), for: .normal)
        let w = FlashStyle.deletePageWidth
        b.bounds = CGRect(x: 0, y: 0, width: w, height: w)
        b.backgroundColor = ColorHelper.elementBackground()
        b.tintColor = ColorHelper.light()
        b.cornerRadius = w / 2
        return b
    }()
    
    lazy var addLeftPageButton: UIButton = {
        let b = self.createAddButton()
        return b
    }()
    
    lazy var addRightPageButton: UIButton = {
        let b = self.createAddButton()
        return b
    }()
    
    var toolVC: FLToolViewController!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.isIpad() ? .all : .portrait
    }
    
    deinit {
        print("stage removed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.updateLayout()
        self.contentPageView.backgroundColor = UIColor("F5F5F5")
        self.menuView.backgroundColor = UIColor("F5F5F5")
        self.viewModel.prepareModel()
        self.configureCollectionView()
        self.collectionView.updateLayout()
        
        self.view.backgroundColor = FlashStyle.screenColor
        self.contentToolHeight.constant = FlashStyle.contentToolHeight
        
        self.addButton.updateLayout()
        self.addButton.cornerRadius = self.addButton.bounds.width / 2
        self.addButton.backgroundColor = ColorHelper.primary()
        self.addButton.tintColor = ColorHelper.light()
        let edge = self.addButton.bounds.height * FlashStyle.iconEedge
        let iconPading = UIEdgeInsets(top: edge, left: edge, bottom: edge, right: edge)
        self.addButton.imageEdgeInsets = iconPading
        self.previewButton.imageEdgeInsets = iconPading
        self.listButton.imageEdgeInsets = iconPading
        
        self.pageCountLabel.textColor = ColorHelper.text50()
        self.previewButton.tintColor = ColorHelper.text50()
        self.listButton.tintColor = ColorHelper.text50()
        
        self.stageView = UIView()
        self.stageView.cornerRadius = 16
        self.stageView.backgroundColor = .white
        self.contentPageView.addSubview(self.stageView)
        
        self.sliderView = FLSliderView.instanciateFromNib()
        self.sliderView.backgroundColor = .clear
        self.contentPageView.addSubview(self.sliderView)
        
        self.contentPageView.addSubview(self.deletePageButton)
        self.contentPageView.addSubview(self.addLeftPageButton)
        self.contentPageView.addSubview(self.addRightPageButton)
        
        self.flCreator = FLCreator(stage: self.stageView)
        self.manageStageFrame()
        
        self.addButton.addTarget(self, action: #selector(self.addButtonPressed(_:)), for: .touchUpInside)
        self.addLeftPageButton.addTarget(self, action: #selector(self.appLeftPressed(_:)), for: .touchUpInside)
        self.addRightPageButton.addTarget(self, action: #selector(self.addRightPressed(_:)), for: .touchUpInside)
        
        self.prepareToolVC()
        self.collectionView.reloadData()
    }
    
    @objc func appLeftPressed(_ sender: UIButton) {
        let index = self.viewModel.pageIndex
        let newIndex = index - 1
        let page = FlashPage()
        self.viewModel.pageList.insert(page, at: newIndex)
        
        let indexPath = IndexPath(row: newIndex, section: 0)
        self.collectionView.insertItems(at: [indexPath])
        
        guard let stackView = self.sliderView.contentStackView else {return}
        let frame = self.stageView.frame
        let stage = self.createStageView(frame.size)
        stage.page = page
        stackView.insertArrangedSubview(stage, at: newIndex)
        self.stageViewList.insert(stage, at: newIndex)
        
        self.gotoPage(index: newIndex)
    }
    
    @objc func addRightPressed(_ sender: UIButton) {
        let index = self.viewModel.pageIndex
        let newIndex = index + 1
        let page = FlashPage()
        self.viewModel.pageList.insert(page, at: newIndex)
        
        let indexPath = IndexPath(row: newIndex, section: 0)
        self.collectionView.insertItems(at: [indexPath])
        
        guard let stackView = self.sliderView.contentStackView else {return}
        let frame = self.stageView.frame
        let stage = self.createStageView(frame.size)
        stage.page = page
        stackView.insertArrangedSubview(stage, at: newIndex)
        self.stageViewList.insert(stage, at: newIndex)
        
        self.gotoPage(index: newIndex)
    }
    
    func gotoPage(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        self.flCreator.selectedView?.isSelected = false
        self.flCreator.selectedView?.isCreateNew = false
        self.view.endEditing(true)
        self.toolVC.closePressed(nil)
    }
    
    func manageStageFrame() {
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
            self.stageView.frame = stageFrame
            self.flCreator.stageRatio = stageFrame.width / FlashStyle.baseStageWidth
            
            self.deletePageButton.center = CGPoint(x: self.stageView.center.x, y: self.stageView.frame.origin.y)
            
            self.addLeftPageButton.center = CGPoint(x: self.stageView.frame.origin.x, y: self.stageView.center.y)
            
            self.addRightPageButton.center = CGPoint(x: self.stageView.frame.origin.x + self.stageView.frame.width, y: self.stageView.center.y)
            
            self.manageAddLR()
            
            let edge = stageFrame.origin.x
            self.sectionEdge = UIEdgeInsets(top: 0, left: edge, bottom: 0, right: edge)
            self.layout.sectionInset = self.sectionEdge
            self.cellSize = stageFrame.size
            self.layout.itemSize = self.cellSize
            self.layout.minimumInteritemSpacing = 0
            self.layout.minimumLineSpacing = FlashStyle.stage.cellSpacing
            
            self.sliderView.frame = CGRect(x: 0, y: 0, width: areaFrame.width, height: areaFrame.height)
            self.sliderView.stackHeight.constant = stageFrame.height
            self.sliderView.leftWidth.constant = self.sectionEdge.left
            self.sliderView.rightWidth.constant = self.sectionEdge.right
            
            let controlframe = CGRect(x: 0, y: 0, width: 100, height: 100)
            self.controlView.updateFrame(controlframe)
            self.controlView.leftWidthButton.tag = FLTag.left.rawValue
            self.controlView.rightWidthButton.tag = FLTag.right.rawValue
            self.controlView.leftWidthButton.addTarget(self, action: #selector(self.scaleWidthDraging(_:event:)), for: .touchDragInside)
            self.controlView.rightWidthButton.addTarget(self, action: #selector(self.scaleWidthDraging(_:event:)), for: .touchDragInside)
            self.controlView.isHidden = true
            
            self.collectionView.backgroundColor = .black
            self.collectionView.reloadData()
            self.stageView.isHidden = true
            self.collectionView.isHidden = true
            
            if self.isCreatePage {
                self.manageMultitleStage()
            }
            
            
        }
    }
    
    func createStageView(_ size: CGSize) -> FLStageView {
        let f = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let stage = FLStageView(frame: f)
        stage.backgroundColor = .white
        stage.cornerRadius = 16
        stage.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        stage.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        return stage
    }
    
    func manageMultitleStage() {
        guard let stackView = self.sliderView.contentStackView else {return}
        stackView.removeAllArranged()
        let frame = self.stageView.frame
        for page in self.viewModel.pageList {
            let stage = self.createStageView(frame.size)
            stage.page = page
            self.stageViewList.append(stage)
            stackView.addArrangedSubview(stage)
        }
        stackView.layoutIfNeeded()
        self.sliderView.scrollView.delegate = self
        self.sliderView.scrollView.isScrollEnabled = false//TODO: detech active
        self.isCreatePage = false
    }
    
    var sectionEdge = UIEdgeInsets.zero
    var cellSize = CGSize.zero
    
    func manageAddLR() {
        if self.viewModel.pageIndex == 0 {
            self.addLeftPageButton.isHidden = true
            self.addRightPageButton.isHidden = false
            
        } else if self.viewModel.pageIndex == (self.viewModel.pageList.count - 1) {
            self.addLeftPageButton.isHidden = false
            self.addRightPageButton.isHidden = true
            
        } else {
            self.addLeftPageButton.isHidden = false
            self.addRightPageButton.isHidden = false
        }
    }
    
    @objc func addButtonPressed(_ sender: UIButton) {
        self.openToolBar(tool: .menu)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = self.cellSize.width
        let proportionalOffset = self.sliderView.scrollView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(self.viewModel.pageList.count - 1, index))
        return safeIndex
    }
    
    var halfModalDelegate: HalfModalTransitioningDelegate!
    
    func prepareToolVC() {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
//        if let vc = s.instantiateViewController(identifier: "FLToolViewController") as? FLToolViewController {
//            // toolHelper = FLToolHelper(vc: self, toolBar: vc)
//            //tool parameter
//
//            vc.didSelectedColor = DidAction(handler: { (sender) in
//                guard let hex = sender as? String else { return }
//                self.stageView.backgroundColor = UIColor(hex)
//            })
//            vc.didCreateText = DidAction(handler: { (sender) in
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
        if let vc = s.instantiateViewController(identifier: "FLToolViewController") as? FLToolViewController {
            self.toolVC = vc
            self.toolVC.didChangeTextAlignment = DidAction(handler: { [weak self] (sender) in
                guard let self = self else { return }
                guard let a = sender as? FLTextAlignment else { return }
                self.updateTextAlignment(a)
            })
            
            self.toolVC.didChangeTextStyle = DidAction(handler: { [weak self] (sender) in
                guard let self = self else { return }
                guard let s = sender as? FLTextStyle else { return }
                self.updateTextStyle(s)
            })
            
            self.toolVC.didSelectedColor = DidAction(handler: { [weak self] (sender) in
                guard let self = self else { return }
                guard let hex = sender as? String else { return }
                let stageView = self.getStageView(at: self.viewModel.pageIndex)
                stageView.backgroundColor = UIColor(hex)
            })
            self.toolVC.didChangeTextColor = DidAction(handler: { [weak self] (sender) in
                guard let self = self else { return }
                guard let hex = sender as? String else { return }
                self.flCreator.selectedView?.textView?.textColor = UIColor(hex)
            })
            
            self.toolVC.didMediaPressed = DidAction(handler: { [weak self] (sender) in
                guard let self = self else { return }
                self.openImagePicker()
            })
            
            self.toolVC.didCreateText = DidAction(handler: { [weak self] (sender) in
                guard let self = self else { return }
                self.createNewText()
            })
            
            self.toolVC.didClose = DidAction(handler: { (sender) in
                //self.view.endEditing(true)
                if let tool = sender as? FLTool, tool == .text {
                    self.flCreator.selectedView?.textView?.resignFirstResponder()
                }
                
            })
            self.toolVC.view.isHidden = true
            self.toolStackView.addArrangedSubview(self.toolVC.view)
            self.addChild(self.toolVC)
            self.toolVC.didMove(toParent: self)
            
            self.toolVC.setup(FLToolViewSetup(tool: .menu))
        }
    }
    
    func openToolBar(tool: FLTool, iView: InteractView? = nil) {
        if let toolVC = self.toolVC {
            toolVC.setup(FLToolViewSetup(tool: tool, iView: iView))
            toolVC.view.isHidden = false
            
        }
    }
    
    func createNewText() {
        let element = TextElement()
        element.width = 0
        element.x = 50
        element.y = 50
        element.text = FlashStyle.text.placeholder
        let row = self.indexOfMajorCell()
        self.createElement(element, row: row)
    }
    
    func createNewImage(_ image: UIImage) {
        let element = ImageElement()
        element.x = 50
        element.y = 50
        element.image = image
        element.rawSize = image.size
        let row = self.indexOfMajorCell()
        self.createElement(element, row: row)
    }
    
    func createNewVideo(_ url: URL, size: CGSize) {
        let element = VideoElement()
        element.x = 50
        element.y = 50
        element.deviceUrl = url
        element.rawSize = size
        let row = self.indexOfMajorCell()
        self.createElement(element, row: row)
    }
    
    func updateTextAlignment(_ alignment: FLTextAlignment) {
        guard let iView = self.flCreator.selectedView else { return}
        iView.element?.flAlignment = alignment
        
        self.manageTextAtb()
    }
    
    func updateTextStyle(_ style: FLTextStyle = .regular) {
        guard let iView = self.flCreator.selectedView else { return}
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
        guard let iView = self.flCreator.selectedView else { return}
        guard let textView = iView.textView else { return }
        guard let element = iView.element else { return }
        let textColor = textView.textColor ?? .black
        let text = textView.text ?? ""
        
        let font = self.flCreator.manageFont(element: element)
        let alignment = element.flAlignment.alignment()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 0
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
            self.flCreator.selectedView?.textView?.attributedText = atbString
            //textView.textAlignment = element.flAlignment.alignment()
        }
    }
    
    
    
    func getStageView(at row: Int) -> UIView {
        //let stageView = self.sliderView.contentStackView.arrangedSubviews[row]
        let stageView = self.stageViewList[row]
        return stageView
    }
    
    func createElement(_ element: FlashElement, row: Int) {
        if let eText = element as? TextElement {
            self.createTextView(eText, row: row)
            
        } else if let _ = element as? ImageElement {
            self.createIView(element, row: row)
            
        }  else if let _ = element as? VideoElement {
            self.createIView(element, row: row)
        }
        //TODO: add video, shape to stage
    }
    
    func createIView(_ element: FlashElement, row: Int) {
        self.flCreator.selectedView?.isSelected = false
        self.flCreator.selectedView?.isCreateNew = false
        
        self.viewModel.save(element: element, at: row)
        
        let stageView = self.getStageView(at: row)
        guard let iView = self.flCreator.createImage(element, in: stageView) else { return}
        
        self.flCreator.selectedView = iView
        
        iView.prepareGesture()
//        iView.enableZoom()
//        iView.addGestureRecognizer(TapGesture(target: self, action: #selector(self.taped(_:))))
//
//        iView.addGestureRecognizer(PanGesture(target: self, action: #selector(self.move(_:))))
//        iView.addGestureRecognizer(RotationGesture(target: self, action: #selector(self.rotated(_:))))
        iView.isCreateNew = true
        //Auto select all test
        //textElement.textView?.selectAll(self)
        iView.textView?.becomeFirstResponder()
        iView.isSelected = true
        iView.textView?.delegate = self
        
        if let tool = element.tool {
            self.openToolBar(tool: tool, iView: iView)
            self.toolVC.open(tool, isCreating: true)
        }
        
        let size = iView.frame
        print("controlView width: \(size.width) ,controlView height: \(size.height)")
        self.controlView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        iView.update(controlView: self.controlView)
    }
    
    func createTextView(_ element: TextElement, row: Int) {
        self.flCreator.selectedView?.isSelected = false
        self.flCreator.selectedView?.isCreateNew = false
        
        let stageView = self.getStageView(at: row)
        self.viewModel.save(element: element, at: row)
        
        let textElement = self.flCreator.createText(element, in: stageView)
        
        self.flCreator.selectedView = textElement
        
        textElement.enableZoom()
        textElement.addGestureRecognizer(TapGesture(target: self, action: #selector(self.taped(_:))))
        
        textElement.addGestureRecognizer(PanGesture(target: self, action: #selector(self.move(_:))))
        textElement.addGestureRecognizer(RotationGesture(target: self, action: #selector(self.rotated(_:))))
        textElement.isCreateNew = true
        //Auto select all test
        //textElement.textView?.selectAll(self)
        textElement.textView?.becomeFirstResponder()
        textElement.isSelected = true
        textElement.textView?.delegate = self
        
        self.openToolBar(tool: .text, iView: textElement)
        self.toolVC.open(.text, isCreating: true)
        
        let size = textElement.frame
        print("controlView width: \(size.width) ,controlView height: \(size.height)")
        self.controlView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        textElement.update(controlView: self.controlView)
        
    }
    
    private var startPosition: CGPoint!
    private var originalWidth: CGFloat = 0
    @objc func moveControl(_ gesture: UIPanGestureRecognizer) {
        
        //let translation = gesture.translation(in: self.stageView)
        //iView.center = CGPoint(x: iView.center.x + translation.x, y: iView.center.y + translation.y)
        //gesture.setTranslation(CGPoint.zero, in: self.stageView)
        guard let view = gesture.view as? FLControlView else { return }
        let location = gesture.location(in: view)
        
        let index = self.indexOfMajorCell()
        let stage = self.getStageView(at: index)
        
        
        if gesture.state == .began  {
            startPosition = gesture.location(in: stage)
            originalWidth = view.frame.width
        } else if gesture.state == .changed {
            let endPosition = gesture.location(in: stage)
            let difference = endPosition.y - startPosition.y
            var newWidth = originalWidth + difference
            
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                
            }, completion: { (ended) in
                
            })
        }
        
    }
    private var isScaleWidth = false
    @objc func scaleWidthDraging(_ button:UIButton, event: UIEvent) {
        
        guard let touch = event.touches(for: button)?.first else { return }
        let location = touch.location(in: button)
        let previous = touch.previousLocation(in: button)
        //scale X
        //textViewDidChange
        var deltaX:CGFloat
        var deltaY:CGFloat
        if button.tag == FLTag.left.rawValue {
            deltaX = location.x - previous.x
            deltaY = location.y - previous.y
        } else {
            deltaX = location.x + previous.x
            deltaY = location.y + previous.y
        }
        print("******")
        print("previous X: \(previous.x) Y:\(previous.y)")
        print("location X: \(location.x) Y:\(location.y)")
        print("deltaX: \(deltaX) Y:\(deltaY)")
        //use only text
        if let iView = self.flCreator.selectedView, let textView = iView.textView {
            //let textViewFrame = textView.frame
            let iViewFrame = iView.frame
            let deltaXConvert = deltaX * -1
            //scale left+right
            let newWidth = iViewFrame.width + (deltaXConvert * 2)
                
            let newX:CGFloat = iViewFrame.origin.x + deltaX
            let iViewFrameUpdate = CGRect(x: newX, y: iViewFrame.origin.y, width: newWidth, height: iViewFrame.height)
            
            iView.frame = iViewFrameUpdate
            //self.controlView.updateFrame(iViewFrameUpdate, center: iView.center)
            self.controlView.updateFrame(iView.frame)
            print("out iView:\(iView.frame)")
            if !self.isScaleWidth {//for textview fix layout
                self.isScaleWidth = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UIView.animate(withDuration: 0.05, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        textView.frame = CGRect(x: 0, y: 0, width: iViewFrameUpdate.width, height: iViewFrameUpdate.height)
                        //textView.frame = CGRect(x: 0, y: 0, width: iViewFrameUpdate.width, height: iViewFrameUpdate.width)
                        //textView.contentSize.width
                        
                        self.updateTextviewHeight(iView)
                    }, completion: { (ended) in
                        self.isScaleWidth = false
                        let factH = iView.frame.height - textView.frame.height
                        print("factH:\(factH)")
                        print("iView:\(iView.frame)")
                        print("textView:\(textView.frame)")
                        print("contentsize:\(textView.contentSize)")
                    })
                }
                
            }
            //TODO: Do when touches end
            //iView.textView?.contentSize = iViewFrameUpdate.size
            //iView.textView?.frame.size = iViewFrameUpdate.size
            //iView.textView?.textContainer
            //button.center = CGPointMake(button.center.x + delta_x, button.center.y + delta_y);
        }
    }
    
    func updateTextviewHeight(_ iView:InteractView) {
        guard let textView = iView.textView else { return }
        let f = iView.frame
        //height growing
        let viewH = textView.systemLayoutSizeFitting(CGSize(width: f.width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        textView.frame = CGRect(x: 0, y: 0, width: f.width, height: viewH)
        print("viewH:\(viewH)")
        let selfFrame = iView.frame
        iView.frame = CGRect(x: selfFrame.origin.x, y: selfFrame.origin.y, width: selfFrame.width, height: viewH * self.flCreator.stageRatio)
        self.controlView.updateFrame(iView.frame)
        
        //let newSize = textView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        //textView.frame = CGRect(origin: textView.frame.origin, size: newSize)
    }
    
    /*
    func create() {
        self.flCreator = FLCreator(stage: self.stageView)
        
        let textElement = self.flCreator.createText(TextElement(), in: self.stageView)
        
        let vectorElement = self.flCreator.createVector(VectorElement(), in: self.stageView)
        
        let imageElement = self.flCreator.createImage(ImageElement(), in: self.stageView)
        
        let videoElement = self.flCreator.createVideo(VideoElement(), in: self.stageView)
        
        //zoom
        textElement.enableZoom()
        vectorElement.enableZoom()
        imageElement.enableZoom()
        videoElement.enableZoom()
        
        //tap
        textElement.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.taped(_:))))
        vectorElement.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.taped(_:))))
        imageElement.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.taped(_:))))
        
        //move
        textElement.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.move(_:))))
        vectorElement.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.move(_:))))
        imageElement.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.move(_:))))
        videoElement.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.move(_:))))
        
        //rotation
        textElement.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(self.rotated(_:))))
        vectorElement.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(self.rotated(_:))))
        imageElement.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(self.rotated(_:))))
        videoElement.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(self.rotated(_:))))
    }
    */
    
    @objc func taped(_ gesture: UITapGestureRecognizer) {
        self.flCreator.selectedView?.isSelected = false
        
        guard let iView = gesture.view as? InteractView else { return }
        //let isSelected = !view.isSelected
        iView.isSelected = true
        self.flCreator.selectedView = iView
        
        self.controlView.updateFrame(iView.frame)
    }
    
    @objc func move(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.stageView)
        guard let iView = gesture.view as? InteractView else { return }
        if let textView = iView.textView {
            textView.selectedTextRange = nil
        }
        iView.isSelected = true
        
        let translation = gesture.translation(in: self.stageView)
        //for center
        //iView.center = location
        //iView.center = CGPoint(x: iView.center.x + translation.x, y: iView.center.y + translation.y)
        print("move")
        print("x : \(translation.x)")
        print("y : \(translation.y)")
        iView.transform = iView.transform.translatedBy(x: translation.x, y: translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.stageView)
        self.controlView.updateFrame(iView.frame)
        
        if gesture.state == .began {
            
        } else if gesture.state == .ended {
            
        }
        
    }
    
    @objc func rotated(_ gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view as? InteractView else { return }
        view.isSelected = true
        var originalRotation = CGFloat()
        if gesture.state == .began {
            print("sender.rotation: \(gesture.rotation)")
            //gesture.rotation is radians
            //view.rotation is degrees
            let radians = self.getRadians(degrees: Double(view.rotation))
            gesture.rotation = CGFloat(radians)
            originalRotation = gesture.rotation
            
        } else if gesture.state == .changed {
            let scale = CGAffineTransform(scaleX: view.currentScale.x, y: view.currentScale.y)
            let newRotation = gesture.rotation + originalRotation
            view.transform = scale.rotated(by: newRotation)
            
            
            //let newRotation = gesture.rotation + originalRotation
            //view.transform = CGAffineTransform(rotationAngle: newRotation)
            
            let degrees = self.getDegreesRotation(view)
            print("changed degrees: \(degrees)")
            
        } else if gesture.state == .ended {
            // Save the last rotation
            let degrees = self.getDegreesRotation(view)
            print("ended degrees: \(degrees)")
            view.rotation = Float(degrees)
            gesture.rotation = 0
        }
    }
    
    func getRadians(degrees: Double) -> Double {
        let radians = degrees * .pi / 180
        return radians
    }
    
    func getDegreesRotation(_ view: UIView) -> Double {
        let radians:Double = atan2( Double(view.transform.b), Double(view.transform.a))
        let degrees = radians * Double((180 / Float.pi))
        print("degrees: \(degrees)")
        return degrees
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "FLPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FLPageCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = false
        
        //let layout = CollectionViewPagingLayout()
        //collectionView.collectionViewLayout = layout
        //layout.delegate = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
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
    
    func stageScreenShot(_ stage: UIView) -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContext(stage.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @objc func actionButtonTapped() {
        //TODO: save cover
        self.takeScreenshot(of: self.stageView)
    }
    
    func takeScreenshot(of view: UIView) {
        let size = CGSize(width: view.bounds.width, height: view.bounds.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        //send image(screenshot) to api save
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(self.imageWasSaved), nil)
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

extension FLStageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage {
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
                //TODO 20 image perpage
                PopupManager.showWarning("You can upload 20 images per page !", at: self)
            } else if mb >= 9.0 {
                PopupManager.showWarning("Your image is too powerful\n(Maximum size is 4 MB)\nPlease upload again", at: self)
            } else {
                self.createNewImage(img)
            }
            
        } else if let movieUrl = info[.mediaURL] as? URL {
            print("movieUrl: \(movieUrl)")
            //TODO: check only 1 video per page
            let asset = AVURLAsset(url: movieUrl)
            let seconds = asset.duration.seconds
            print(seconds)
            if seconds > 60 {
                PopupManager.showWarning("Your video is too powerful\n(Maximum length is 60 seconds)\nPlease upload again", at: self)
            } else {
                guard let track = asset.tracks(withMediaType: .video).first else { return }
                let size = track.naturalSize.applying(track.preferredTransform)
                self.createNewVideo(movieUrl, size: size)
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

extension FLStageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let iView = textView.superview as? InteractView {
            iView.isSelected = true
            self.flCreator.selectedView = iView
            self.controlView.updateFrame(iView.frame)
            
            self.openToolBar(tool: .text, iView: iView)
            self.toolVC.open(.text)
            
//            if iView.isCreateNew {
//                self.openToolBar(tool: .text, iView: iView)
//                self.toolVC.open(.text)
//            } else {
//                //select old textview
//            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let iView = textView.superview as? InteractView {
            iView.isSelected = false
            self.flCreator.selectedView = iView
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let iView = textView.superview as? InteractView {
            self.updateTextviewHeight(iView)
            self.controlView.updateFrame(iView.frame)
        }
    }
    
}

extension FLStageViewController: CollectionViewPagingLayoutDelegate {
    func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int) {
        //pageControlView.currentPage = currentPage
    }
}

extension FLStageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.pageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLPageCollectionViewCell", for: indexPath) as! FLPageCollectionViewCell
        let page = self.viewModel.pageList[indexPath.row]
        for v in cell.stageView.subviews {
            v.removeFromSuperview()
        }
        for e in page.componentList {
            self.createElement(e, row: indexPath.row)
        }
        print("cell.frame index: \(indexPath.row)")
        print("cell.frame: \(cell.frame)")
        return cell
    }
    
}


extension FLStageViewController: UICollectionViewDelegate {
    
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
            let lineSpacing = self.layout.minimumLineSpacing
            let snapToIndex = self.viewModel.pageIndex + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = (self.layout.itemSize.width + lineSpacing) * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
