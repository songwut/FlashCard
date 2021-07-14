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
    var didChangeTextColor: DidAction?
    var didChangeTextStyle: DidAction?
    var didChangeTextAlignment: DidAction?
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var toolStackView: UIStackView!
    @IBOutlet weak var colorStackView: UIStackView!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var textToolStackView: UIStackView!
    @IBOutlet weak var keyboardView: UIView!
    
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var keyboardButton: UIButton!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    
    private var addBarView = FLMenuBarView.instanciateFromNib()
    private var colorToolView = FLColorView.instanciateFromNib()
    private var textStyleView = FLTextStyleView.instanciateFromNib()
    private var textColorView = FLColorView.instanciateFromNib()
    
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
        
//        if self.isToolReady {
//            self.open(setup.tool)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.updateLayout()
        self.view.roundCorners([.topLeft, .topRight], radius: 16)
        self.titleLabel.textColor = .black
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
        //self.keyboardView.isHidden = true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if self.keyboardFrame == nil {
            if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                if self.keyboardFrame == nil {
                    print("keyboardSize.height:\(keyboardFrame.height)")
                    self.keyboardHeight.constant = keyboardFrame.height - self.safeAreaBottomHeight
                    self.keyboardFrame = keyboardFrame
                }
            }
        }
        
    }
    
    @objc func keyboardPressed(_ button: UIButton) {
        //TODO: show keyboard and height
        if self.textMenu != .keyboard {
            self.textMenu = .keyboard
            self.open(.text)
        }
    }
    
    @objc func stylePressed(_ button: UIButton) {
        //TODO: show text style
        if self.textMenu != .style {
            self.textMenu = .style
            self.open(.text)
        }
    }
    
    @objc func colorPressed(_ button: UIButton) {
        //TODO: show color picker
        if self.textMenu != .color {
            self.textMenu = .color
            self.open(.text)
        }
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
            self.addBarView.stackView.addArrangedSubview(toolView)
        }
        self.addBarView.stackView.spacing = spacing
        let h = self.addBarView.barHeight.constant
        self.addBarView.heightAnchor.constraint(equalToConstant: h).isActive = true
        self.toolStackView.addArrangedSubview(self.addBarView)
        self.toolStackView.isHidden = false
        
        self.updateViewLayout(self.addBarView)
        
        self.viewModel.colorList { (colorList) in
            self.createColorTool(colorList)
            self.createTextTool(colorList)
        }
    }
    
    @objc func toolPressed(_ sender: UIButton) {
        guard let btn = sender as? FLButton else { return }
        if btn.tool == .text {
            //create text need to auto select, manage keyboard
            self.didCreateText?.handler(nil)
        } else {
            //open tool menu
            self.open(btn.tool)
        }
    }
    
    func createColorTool(_ colorList: [String]) {
        self.colorToolView.setup(colorList: colorList)
        self.colorToolView.didSelectedColor = self.didSelectedColor
        self.colorStackView.removeAllArranged()
        self.colorStackView.addArrangedSubview(self.colorToolView)
        self.colorStackView.isHidden = true
        self.updateViewLayout(self.colorStackView)
    }
    
    func createTextTool(_ colorList: [String]) {
        self.textColorView.setup(colorList: colorList)
        self.textColorView.didSelectedColor = self.didChangeTextColor
        self.textStackView.addArrangedSubview(self.textColorView)
        self.textColorView.isHidden = true
        self.updateViewLayout(self.textColorView)
        
        //self.textStyleView.didChangeTextAlignment = self.didChangeTextAlignment
        //self.textStyleView.didChangeTextStyle = self.didChangeTextStyle
        self.textStyleView.styleStackView.removeAllArranged()
        self.textStackView.addArrangedSubview(self.textStyleView)
        self.textStackView.isHidden = true
        self.updateViewLayout(self.textStyleView)
    }
    
    func updateViewLayout(_ view: UIView) {
        view.updateLayout()
        let h = view.frame.height
        view.heightAnchor.constraint(equalToConstant: h).isActive = true
    }
    
    
    func updateToNewHeight(_ height: CGFloat) -> Void {
        if let presetation = self.presentationController as? HalfModalPresentationController {
            let titleHeight = titleView.bounds.height
            presetation.startHeight = titleHeight + height + self.safeAreaBottomHeight
            presetation.changeScale(to: .normal)
        }
    }
    
    func open(_ tool: FLTool, isCreating: Bool = false) {
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
            self.colorStackView.isHidden = true
            self.manageText(self.textMenu, isCreating: isCreating)
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
    
    func manageText(_ textMenu: FLTextMenu, isCreating: Bool) {
        
        switch textMenu {
        case .keyboard:
            if !isCreating {
                self.resetTextView(isActive: true)
            }
            self.keyboardView.isHidden = false
            self.textStyleView.isHidden = true
            self.textColorView.isHidden = true
            
            break
        case .style:
            self.resetTextView()
            self.keyboardView.isHidden = true
            self.textStyleView.isHidden = false
            self.textColorView.isHidden = true
            break
        case .color:
            self.resetTextView()
            self.keyboardView.isHidden = true
            self.textStyleView.isHidden = true
            self.textColorView.isHidden = false
            break
        }
        
    }
    
    func resetTextView(isActive: Bool = false) {
        //resignFirstResponder > textViewDidEndEditing
        //make isSelected = false
        //need to set iView still selecting
        if let textView = self.viewModel.iView?.textView {
            self.viewModel.iView?.isCreateNew = false
            if isActive, !textView.isFirstResponder {
                if let text = textView.text {
                    let range = NSRange(textView.text)
                    let start = textView.beginningOfDocument
                    let end = textView.endOfDocument
                    //textView.selectedTextRange = textView.textRange(from: start, to: end)!
                    textView.becomeFirstResponder()
                }
                //
            } else {
                //textView.selectedTextRange = nil
                textView.resignFirstResponder()
            }
            
            self.viewModel.iView?.isSelected = true
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton?) {
        self.dismiss(animated: true, completion: nil)//if use present
        self.didClose?.handler(nil)
        
        //reset to tool UI
        self.toolStackView.isHidden = false
        let tool = self.viewModel.tool
        
        switch tool {
        case .background:
            self.textStackView.isHidden = true
            self.colorStackView.isHidden = true
            self.viewModel.tool = .menu
            break
        case .media:
            break
        case .text:
            self.textStackView.isHidden = true
            self.textColorView.isHidden = true
            self.keyboardView.isHidden = true
            self.textMenu = .keyboard//reset default
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
