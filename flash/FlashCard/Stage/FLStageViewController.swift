//
//  FLStageViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 1/7/2564 BE.
//

import UIKit
import CollectionViewPagingLayout

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
    private var stageViewList = [FLStageView]()
    private var stageCell: UICollectionViewCell!
    private var stageScrollView: UIScrollView!
    private var stageStackView: UIStackView!
    private var flCreator: FLCreator!
    private var didScrollCollectionViewToMiddle = false
    private var isCreatePage = true
    
    lazy var deletePageButton: UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(named: "ic_v2_delete"), for: .normal)
        let w = FlashStyle.deletePageWidth
        b.bounds = CGRect(x: 0, y: 0, width: w, height: w)
        b.backgroundColor = .elementBackground()
        b.tintColor = .light()
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
        self.addButton.backgroundColor = .primary()
        self.addButton.tintColor = .light()
        let edge = self.addButton.bounds.height * FlashStyle.iconEedge
        let iconPading = UIEdgeInsets(top: edge, left: edge, bottom: edge, right: edge)
        self.addButton.imageEdgeInsets = iconPading
        self.previewButton.imageEdgeInsets = iconPading
        self.listButton.imageEdgeInsets = iconPading
        
        self.pageCountLabel.textColor = .text50()
        self.previewButton.tintColor = .text50()
        self.listButton.tintColor = .text50()
        
        self.stageView = UIView()
        self.stageView.cornerRadius = 16
        self.stageView.backgroundColor = .white
        self.contentPageView.addSubview(self.stageView)
        
        self.stageScrollView = UIScrollView()
        self.stageView.backgroundColor = .white
        self.contentPageView.addSubview(self.stageScrollView)
        
        self.stageStackView = UIStackView()
        self.stageStackView.alignment = .fill
        self.stageStackView.axis = .horizontal
        self.stageStackView.distribution = .equalSpacing
        self.stageStackView.spacing =  FlashStyle.stage.cellSpacing
        self.stageScrollView.addSubview(self.stageStackView)
        
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
        
        self.gotoPage(index: newIndex)
    }
    
    @objc func addRightPressed(_ sender: UIButton) {
        let index = self.viewModel.pageIndex
        let newIndex = index + 1
        let page = FlashPage()
        self.viewModel.pageList.insert(page, at: newIndex)
        
        let indexPath = IndexPath(row: newIndex, section: 0)
        self.collectionView.insertItems(at: [indexPath])
        
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
            
            
            self.stageScrollView.frame = CGRect(x: 0, y: 0, width: areaFrame.width, height: areaFrame.height)
            
            let stY = (areaFrame.height - stageFrame.height) / 2
            self.stageStackView.frame = CGRect(x: self.sectionEdge.left, y: stY, width: areaFrame.width, height: stageFrame.height)
            
            
            self.collectionView.backgroundColor = .black
            self.collectionView.reloadData()
            self.stageView.isHidden = true
            self.collectionView.isHidden = true
            
            if self.isCreatePage {
                self.manageMultitleStage()
            }
            
            
        }
    }
    
    func manageMultitleStage() {
        let size = self.stageView.frame
        for page in self.viewModel.pageList {
            let f = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let stage = FLStageView(frame: f)
            stage.page = page
            stage.backgroundColor = .orange
            stage.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            stage.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            self.stageViewList.append(stage)
            self.stageStackView.addArrangedSubview(stage)
        }
        //let pageCount = self.viewModel.pageList
        //let stWidth =
        //let scrollWidth = self.sectionEdge.left + (size.width * pageCount) + self.sectionEdge.right
        //
        self.stageStackView.translatesAutoresizingMaskIntoConstraints = false
        self.stageStackView.layoutIfNeeded()
        print("width: ", self.stageStackView.bounds.width)
        let allEdge = self.sectionEdge.left + self.sectionEdge.right
        let scrollWidth = self.stageStackView.bounds.width + allEdge
        self.stageScrollView.contentSize = CGSize(width: scrollWidth, height: self.stageScrollView.frame.height)
        
        let stY = self.stageStackView.frame.origin.y
        self.stageStackView.frame = CGRect(x: self.sectionEdge.left, y: stY, width: scrollWidth, height: size.height)
        
        self.stageScrollView.delegate = self
        self.stageStackView.backgroundColor = .gray
        self.stageScrollView.backgroundColor = .black
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
        let proportionalOffset = self.stageScrollView.contentOffset.x / itemWidth
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
            
            
            self.toolVC.didCreateText = DidAction(handler: { [weak self] (sender) in
                guard let self = self else { return }
                self.createNewText()
            })
            
            self.toolVC.didClose = DidAction(handler: { (sender) in
                self.view.endEditing(true)
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
    
    func getStageView(at row: Int) -> UIView {
        let stageView = self.stageViewList[row]
        return stageView
    }
    
    func createElement(_ element: FlashElement, row: Int) {
        if let eText = element as? TextElement {
            self.createTextView(eText, row: row)
            
        } else if let eImage = element as? ImageElement {
            //TODO: add image to stage
        }
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
        
        guard let view = gesture.view as? InteractView else { return }
        let isSelected = !view.isSelected
        view.isSelected = isSelected
        
        self.flCreator.selectedView = view
    }
    
    @objc func move(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.stageView)
        guard let draggedView = gesture.view as? InteractView else { return }
        if let textView = draggedView.textView {
            textView.selectedTextRange = nil
        }
        draggedView.isSelected = true
        draggedView.center = location
        
        let translation = gesture.translation(in: self.stageView)
        draggedView.center = CGPoint(x: draggedView.center.x + translation.x, y: draggedView.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.stageView)
        /*
        if gesture.state == .ended {
            if draggedView.frame.midX >= self.stageView.layer.frame.width / 2 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    draggedView.center.x = self.stageView.layer.frame.width - 40
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    draggedView.center.x = 40
                }, completion: nil)
            }
        }
        */
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
            
            let newRotation = gesture.rotation + originalRotation
            view.transform = CGAffineTransform(rotationAngle: newRotation)
            
            let degrees = self.getDegreesRotation(view)
            print("changed degrees: \(degrees)")
            
        } else if gesture.state == .ended {
            
            // Save the last rotation
            let degrees = self.getDegreesRotation(view)
            print("ended degrees: \(degrees)")
            view.rotation = Float(degrees)
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
    
    func screenShotMethod() -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
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

}

extension FLStageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let iView = textView.superview as? InteractView {
            iView.isSelected = true
            self.flCreator.selectedView = iView
            if iView.isCreateNew {
                self.openToolBar(tool: .text, iView: iView)
                self.toolVC.open(.text)
            }
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
            let f = textView.frame
            let viewH = textView.systemLayoutSizeFitting(CGSize(width: f.width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
            textView.frame = CGRect(x: 0, y: 0, width: f.width, height: viewH)
            print("viewH:\(viewH)")
            let selfFrame = iView.frame
            iView.frame = CGRect(x: selfFrame.origin.x, y: selfFrame.origin.y, width: selfFrame.width, height: viewH * self.flCreator.stageRatio)
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
