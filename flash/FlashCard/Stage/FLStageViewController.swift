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
    @IBOutlet private weak var contentToolHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var menuView: UIView!
    @IBOutlet private weak var pageCountLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var previewButton: UIButton!
    @IBOutlet private weak var listButton: UIButton!
    
    private var stageView: UIView!
    private var stageLeftView: UIView!
    private var stageRightView: UIView!
    private var scrollView: UIScrollView!
    private var flCreator: FLCreator!
    private var didScrollCollectionViewToMiddle = false
    
    var pageList = [String]()
    var pageIndex = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.updateLayout()
        self.contentPageView.backgroundColor = UIColor("F5F5F5")
        self.menuView.backgroundColor = UIColor("F5F5F5")
        self.viewModel.prepareModel()
        
        configureViews()
        
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
        
        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = .clear
        self.contentPageView.addSubview(self.scrollView)
        
        self.stageView = UIView()
        self.stageView.cornerRadius = 16
        self.stageView.backgroundColor = .white
        self.contentPageView.addSubview(self.stageView)
        
        self.stageLeftView = UIView()
        self.stageLeftView.cornerRadius = 16
        self.stageLeftView.backgroundColor = .white
        self.contentPageView.addSubview(self.stageLeftView)
        
        self.stageRightView = UIView()
        self.stageRightView.cornerRadius = 16
        self.stageRightView.backgroundColor = .white
        self.contentPageView.addSubview(self.stageRightView)
        
        self.contentPageView.addSubview(self.deletePageButton)
        self.contentPageView.addSubview(self.addLeftPageButton)
        self.contentPageView.addSubview(self.addRightPageButton)
        
        
        self.flCreator = FLCreator(stage: self.stageView)
        
        self.stageView.addGestureRecognizer(TapGesture(target: self, action: #selector(self.stageTaped(_:))))
        
        self.manageStageFrame()
        
        self.addButton.addTarget(self, action: #selector(self.addButtonPressed(_:)), for: .touchUpInside)
        
        if self.pageList.count == 0 {
            self.pageList.append("page1")
            self.pageIndex = 0
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
        //b.borderWidth = 1
        //b.borderColor = UIColor("D7DFE9")
        b.addDash(1, color: UIColor("D7DFE9"))
        return b
    }
    
    @objc func stageTaped(_ sender: TapGesture) {
        self.flCreator.selectedView?.isSelected = false
        self.view.endEditing(true)
    }
    
    func manageStageFrame() {
        DispatchQueue.main.async {
            print("self.view:\(self.view.frame)")
            print("self.contentPageView:\(self.contentPageView.frame)")
            
            let areaFrame = self.contentPageView.frame
            
            let scrollFrame = CGRect(x: 0, y: 0, width: areaFrame.width, height: areaFrame.height)
            self.scrollView.frame = scrollFrame
            
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
            
            self.stageView.frame = stageFrame
            
            self.deletePageButton.center = CGPoint(x: self.stageView.center.x, y: self.stageView.frame.origin.y)
            
            self.addLeftPageButton.center = CGPoint(x: self.stageView.frame.origin.x, y: self.stageView.center.y)
            
            self.addRightPageButton.center = CGPoint(x: self.stageView.frame.origin.x + self.stageView.frame.width, y: self.stageView.center.y)
            
            
            if self.pageIndex == 0 {
                let subW = stageFrame.width * 0.8
                let subH = subW * FlashStyle.pageCardRatio
                let rightViewX = self.stageView.center.x + (stageFrame.width / 2)  + 16
                let rightViewY = (stageFrame.height - subH) / 2
                self.stageRightView.frame = CGRect(x: rightViewX, y: rightViewY, width: subW, height: subH)
                self.stageRightView.backgroundColor = .black
                
            } else {
                let subW = stageFrame.width * 0.8
                let subH = subW * FlashStyle.pageCardRatio
                let leftViewX = stageFrame.origin.x - (subW + 16)
                let leftViewY = (stageFrame.height - subH) / 2
                self.stageLeftView.frame = CGRect(x: leftViewX, y: leftViewY, width: subW, height: subH)
                self.stageLeftView.backgroundColor = .black
            }
            
        }
        
    }
    
    @objc func addButtonPressed(_ sender: UIButton) {
        self.openToolBar(tool: .menu)
    }
    
    var halfModalDelegate: HalfModalTransitioningDelegate!
    var toolBarVC: FLToolViewController!
    
    func openToolBar(tool: FLTool) {
        
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
            
            self.toolVC.didSelectedColor = DidAction(handler: { (sender) in
                guard let hex = sender as? String else { return }
                self.stageView.backgroundColor = UIColor(hex)
            })
            self.toolVC.didCreateText = DidAction(handler: { (sender) in
                let element = TextElement()
                self.createTextView(element)
            })
            
            self.toolStackView.addArrangedSubview(self.toolVC.view)
            self.addChild(self.toolVC)
            self.toolVC.didMove(toParent: self)
            
            
            self.toolVC.setup(FLToolViewSetup(tool: .menu))
        }
    }
    
    func createTextView(_ element: TextElement) {
        self.flCreator.selectedView?.isSelected = false
        
        element.width = 80
        element.x = 50
        element.y = 50
        element.fill = nil
        element.text = "Please Input Text Here"
        let textElement = self.flCreator.createText(element, in: self.stageView)
        self.flCreator.selectedView = textElement
        
        textElement.enableZoom()
        textElement.addGestureRecognizer(TapGesture(target: self, action: #selector(self.taped(_:))))
        
        textElement.addGestureRecognizer(PanGesture(target: self, action: #selector(self.move(_:))))
        textElement.addGestureRecognizer(RotationGesture(target: self, action: #selector(self.rotated(_:))))
        
        //Auto select all test
        textElement.textView?.delegate = self
        textElement.textView?.selectAll(self)
        textElement.textView?.becomeFirstResponder()
        textElement.isSelected = true
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
        draggedView.textView?.resignFirstResponder()
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
            //print("changed degrees: \(degrees)")
            
        } else if gesture.state == .ended {
            
            // Save the last rotation
            let degrees = self.getDegreesRotation(view)
            //print("ended degrees: \(degrees)")
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
    
    private func configureViews() {
        view.backgroundColor = .white
        view.clipsToBounds = true
        self.configureCollectionView()
        
        //.numberOfPages = 8
        self.updateSelectedLayout()
        self.reloadDataAndLayouts()
        self.collectionView.reloadData()
    }
    
    private func updateSelectedLayout() {
        
        reloadAndInvalidateShapes()
    }
    
    func reloadAndInvalidateShapes() {
        collectionView?.reloadData()
        invalidateCollectionViewLayout()
    }
    
    private func configureCollectionView() {
        collectionView.registerClass(FLPageCollectionViewCell.self)
        
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        let layout = CollectionViewPagingLayout()
        collectionView.collectionViewLayout = layout
        layout.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
    }

    private func reloadDataAndLayouts() {
        collectionView?.reloadData()
        invalidateCollectionViewLayout()
    }
    
    private func invalidateCollectionViewLayout() {
        collectionView?.performBatchUpdates({ [weak self] in
            self?.collectionView?.collectionViewLayout.invalidateLayout()
        })
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
        }
        //self.flCreator.selectedView?.isSelected = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let iView = textView.superview as? InteractView {
            iView.isSelected = false
            self.flCreator.selectedView = iView
        }
    }
    
}

extension FLStageViewController: CollectionViewPagingLayoutDelegate {
    func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int) {
        //pageControlView.currentPage = currentPage
    }
}

extension FLStageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.pageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellClass(for: indexPath) as FLPageCollectionViewCell
        cell.backgroundColor = .gray
        return cell
    }
    
}


extension FLStageViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
