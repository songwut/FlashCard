//
//  FLToolViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 6/7/2564 BE.
//

import UIKit

class FLToolViewController: UIViewController {
    
    var didClose: DidAction?
    var didCreateText: DidAction?
    var didSelectedColor: DidAction?
    var didChangeTextStyle: DidAction?
    var didChangeTextAlignment: DidAction?
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var toolStackView: UIStackView!
    @IBOutlet weak var colorStackView: UIStackView!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var textToolStackView: UIStackView!
    
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var keyboardButton: UIButton!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    
    private var addBarView = FLMenuBarView.instanciateFromNib()
    private var colorToolView = FLColorView.instanciateFromNib()
    private var textStyleView = FLTextStyleView.instanciateFromNib()
    private var keyboardView = UIView()
    
    private var viewModel = FLToolViewModel()
    var textMenu: FLTextMenu = .keyboard
    private var isToolReady = false
    private var keyboardFrame:CGRect?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.isIpad() ? .all : .portrait
    }
    
    func setup(_ setup: FLToolViewSetup) {
        self.titleLabel.text = setup.tool.title()
        self.viewModel.tool = setup.tool
        self.viewModel.iView = setup.iView
        
        if self.isToolReady {
            self.open(setup.tool)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.updateLayout()
        self.view.roundCorners([.topLeft, .topRight], radius: 16)
        self.closeButton.tintColor = .black
        self.createMenuTool(FlashStyle.toolList)
        
        self.keyboardButton.setTitle("Keyboard", for: .normal)
        self.styleButton.setTitle("Style", for: .normal)
        self.colorButton.setTitle("Color", for: .normal)
        
        self.keyboardButton.addTarget(self, action: #selector(self.keyboardPressed(_:)), for: .touchUpInside)
        self.styleButton.addTarget(self, action: #selector(self.stylePressed(_:)), for: .touchUpInside)
        self.colorButton.addTarget(self, action: #selector(self.colorPressed(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.isToolReady = true
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.keyboardFrame == nil {
                print("keyboardSize.height:\(keyboardFrame.height)")
                self.keyboardHeight.constant = keyboardFrame.height - self.safeAreaBottomHeight
                self.keyboardFrame = keyboardFrame
            }
        }
    }
    
    @objc func keyboardPressed(_ button: UIButton) {
        //TODO: show keyboard and height
        self.textMenu = .keyboard
        self.open(.text)
    }
    
    @objc func stylePressed(_ button: UIButton) {
        //TODO: show text style
        self.textMenu = .style
        self.open(.text)
    }
    
    @objc func colorPressed(_ button: UIButton) {
        //TODO: show color picker
        self.textMenu = .color
        self.open(.text)
        
    }
    
    func createMenuTool(_ tools: [FLTool]) {
        //prepare Tool UI
        let didPressTool = DidAction(handler: { [weak self] (sender) in
            guard let tool = sender as? FLTool else { return }
            self?.open(tool)
        })
        self.toolStackView.removeAllArranged()
        self.addBarView.stackView.removeAllArranged()
        let width:CGFloat = UIDevice.isIpad() ? 400 : self.view.bounds.width - 32
        let itemWidthInMargin:CGFloat = width / CGFloat(FlashStyle.toolList.count)
        let spacing = itemWidthInMargin * FlashStyle.toolMargin
        let itemWidth = itemWidthInMargin - spacing
        for tool in tools {
            let toolView = FLItemView.instanciateFromNib()
            toolView.tool = tool
            //toolView.didPressTool = didPressTool
            toolView.button.addTarget(self, action: #selector(self.toolPressed(_:)), for: .touchUpInside)
            toolView.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
            self.addBarView.stackView.spacing = spacing
            self.addBarView.stackView.addArrangedSubview(toolView)
        }
        self.toolStackView.addArrangedSubview(self.addBarView)
        self.toolStackView.isHidden = false
        
        self.createColorTool()
    }
    
    @objc func toolPressed(_ sender: UIButton) {
        guard let btn = sender as? FLButton else { return }
        self.open(btn.tool)
    }
    
    func createColorTool() {
        self.colorToolView.didSelectedColor = self.didSelectedColor
        
        self.colorStackView.removeAllArranged()
        self.colorStackView.addArrangedSubview(self.colorToolView)
        self.viewModel.colorList { (colorList) in
            self.colorToolView.setup(colorList: colorList)
        }
        self.colorStackView.isHidden = true
    }
    
    func createTextTool() {
        //self.textStyleView.didChangeTextAlignment = self.didChangeTextAlignment
        //self.textStyleView.didChangeTextStyle = self.didChangeTextStyle
        self.textStyleView.styleStackView.removeAllArranged()
        self.textStackView.addArrangedSubview(self.textStyleView)
        self.textStackView.isHidden = true
        
    }
    
    
    
    func updateToNewHeight(_ height: CGFloat) -> Void {
        if let presetation = self.presentationController as? HalfModalPresentationController {
            let titleHeight = titleView.bounds.height
            presetation.startHeight = titleHeight + height + self.safeAreaBottomHeight
            presetation.changeScale(to: .normal)
        }
    }
    
    func open(_ tool: FLTool) {
        let iView = self.viewModel.iView
        self.viewModel.tool = tool
        self.titleLabel.text = tool.title()
        
        switch tool {
        case .background:
            self.toolStackView.isHidden = true
            self.textStackView.isHidden = true
            self.colorStackView.isHidden = false
            let toolHeight = self.colorStackView.bounds.height
            self.updateToNewHeight(toolHeight)
            break
        case .media:
            //dismiss and open image/video picker native
            break
        case .text:
            //show text editor
            self.toolStackView.isHidden = true
            self.textStackView.isHidden = false
            self.manageText(self.textMenu)
            if iView == nil {
                self.didCreateText?.handler(tool)
            } else {
                print("Select:\(iView?.frame)")
                //TODO: case selected
            }
            break
        case .graphic:
            //show graphic, sticker
            break
        case .quiz:
            //show quiz editor
            break
        case .menu:
            //show hide all tool
            break
        }
    }
    
    func manageText(_ textMenu: FLTextMenu) {
        
        switch textMenu {
        case .keyboard:
            self.textStyleView.isHidden = true
            self.colorStackView.isHidden = true
            break
        case .style:
            self.textStyleView.isHidden = false
            self.colorStackView.isHidden = true
            break
        case .color:
            self.textStyleView.isHidden = true
            self.colorStackView.isHidden = false
            break
        }
        
    }
    
    @IBAction func closePressed(_ sender: UIButton?) {
        self.dismiss(animated: true, completion: nil)
        self.didClose?.handler(nil)
        
        //reset to tool UI
        self.toolStackView.isHidden = false
        let tool = self.viewModel.tool
        
        switch tool {
        case .background:
            self.colorStackView.isHidden = true
            self.viewModel.tool = .menu
            break
        case .media:
            break
        case .text:
            self.textStackView.isHidden = true
            self.viewModel.tool = .menu
            break
        case .graphic:
            break
        case .quiz:
            break
        case .menu:
            self.view.isHidden = true
            break
        }
        
        
    }
    
    //Screen Rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.dismiss(animated: true, completion: nil)
        
        if UIDevice.current.orientation.isLandscape {
            print("horizontal")
           //stackView.axis = .horizontal

        } else {
            print("vertical")
           //stackView.axis = .vertical

        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
