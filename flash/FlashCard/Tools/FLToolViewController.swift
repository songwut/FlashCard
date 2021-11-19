//
//  FLToolViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 6/7/2564 BE.
//

import UIKit

class FLToolViewController: UIViewController {
    
    var didClose: Action?
    var didCreateQuiz: Action?
    var didCreateText: Action?
    var didSelectedColor: Action?
    var didChangeTextColor: Action?
    var didChangeTextStyle: Action?
    var didChangeTextAlignment: Action?
    var didSelectedGraphic: Action?
    
    var didMediaPressed: Action?
    
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
    
    @IBOutlet weak var graphicStackView: UIStackView!
    @IBOutlet weak var graphicMenuStackView: UIStackView!
    @IBOutlet weak var graphicToolStackView: UIStackView!
    @IBOutlet weak var shapeButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var graphicLineView: UIView!
    private var graphicSelectView: UIView!
    
    private var addBarView = FLMenuBarView.instanciateFromNib()
    private var colorToolView = FLColorView.instanciateFromNib()
    private var textStyleView = FLTextStyleView.instanciateFromNib()
    private var textColorView = FLColorView.instanciateFromNib()
    private var graphicView = FLGraphicView.instanciateFromNib()
    
    var viewModel = FLToolViewModel()
    var textMenu: FLTextMenu = .keyboard
    var graphicMenu: FLGraphicMenu = .shape
    var quizMenu: FLItemView?
    private var isToolReady = false
    private var keyboardFrame:CGRect?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.isIpad() ? .all : .portrait
    }
    
    func getElement() -> FlashElement? {
        if let v = self.viewModel.view as? InteractView {
            return v.element
            
        } else if let v = self.viewModel.view as? InteractTextView {
            return v.element
        } else {
            return nil
        }
    }
    
    func setup(_ setup: FLToolViewSetup) {
        self.titleLabel.text = setup.tool.title()
        self.viewModel.tool = setup.tool
        self.viewModel.view = setup.view
        
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
        
        self.graphicStackView.isHidden = true
        self.graphicMenuStackView.updateLayout()
        self.graphicSelectView = UIView()
        self.graphicSelectView.backgroundColor = .black
        self.graphicSelectView.frame = CGRect(x: 0, y: 28, width: self.shapeButton.frame.width, height: 2)
        self.graphicLineView.addSubview(self.graphicSelectView)
        self.graphicMenuStackView.spacing = FlashStyle.graphic.menuSpacing
        
        self.shapeButton.addTarget(self, action: #selector(self.shapePressed(_:)), for: .touchUpInside)
        self.stickerButton.addTarget(self, action: #selector(self.stickerPressed(_:)), for: .touchUpInside)
        
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
    
    @objc func shapePressed(_ button: UIButton) {
        if self.graphicMenu != .shape {
            self.graphicMenu = .shape
            self.open(.graphic)
            print("button frame:\(button.frame)")
        }
    }
    
    @objc func stickerPressed(_ button: UIButton) {
        if self.graphicMenu != .sticker {
            self.graphicMenu = .sticker
            self.open(.graphic)
            print("button frame:\(button.frame)")
        }
    }
    
    @objc func keyboardPressed(_ button: UIButton) {
        if self.textMenu != .keyboard {
            self.open(.text, textMenu: .keyboard)
        }
    }
    
    @objc func stylePressed(_ button: UIButton) {
        if self.textMenu != .style {
            self.open(.text, textMenu: .style)
        }
    }
    
    @objc func colorPressed(_ button: UIButton) {
        //TODO: show color picker
        if self.textMenu != .color {
            self.open(.text, textMenu: .color)
        }
    }
    
    func createMenuTool(_ tools: [FLTool]) {
        //prepare Tool UI
        let didPressTool = Action(handler: { (sender) in
            guard let tool = sender as? FLTool else { return }
            self.open(tool)
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
            if tool == .quiz {
                self.quizMenu = toolView
            }
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
        
        self.viewModel.callApiGraphic { (graphicList) in
            self.createGraphicTool(graphicList)
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
    
    func updatePageDetail(_ detail: FLCardPageDetailResult) {
        self.colorToolView.selectedColor = detail.bgColor.hex
        self.colorToolView.reloadColor()
    }
    
    func createColorTool(_ colorList: [FLColorResult]) {
        self.colorToolView.didSelectedColor = self.didSelectedColor
        self.colorStackView.removeAllArranged()
        self.colorStackView.addArrangedSubview(self.colorToolView)
        self.colorStackView.isHidden = true
        self.colorToolView.setup(colorList: colorList)
        self.updateViewLayout(self.colorToolView)
    }
    
    func createTextTool(_ colorList: [FLColorResult]) {
        self.textColorView.selectedColor = self.getElement()?.textColor ?? "ffffff"
        self.textColorView.didSelectedColor = self.didChangeTextColor
        self.textStackView.addArrangedSubview(self.textColorView)
        self.textColorView.isHidden = true
        self.textColorView.setup(colorList: colorList)
        self.updateViewLayout(self.textColorView)
        
        self.textStyleView.styleList = self.getElement()?.flTextStyle ?? []
        self.textStyleView.didChangeTextAlignment = self.didChangeTextAlignment
        self.textStyleView.didChangeTextStyle = self.didChangeTextStyle
        self.textStackView.addArrangedSubview(self.textStyleView)
        self.textStackView.isHidden = true
        self.updateViewLayout(self.textStyleView)
    }
    
    func createGraphicTool(_ graphicList: [FLGraphicResult]) {
        self.graphicView.didSelectedGraphic = self.didSelectedGraphic
        self.graphicToolStackView.addArrangedSubview(self.graphicView)
        self.graphicView.setup(graphicList: graphicList) {
            self.graphicView.update(graphicList: graphicList)
            self.graphicView.updateLayout()
            let h = self.graphicView.height
            self.graphicView.heightAnchor.constraint(equalToConstant: h).isActive = true
        }
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
    
    func open(_ tool: FLTool, textMenu: FLTextMenu = .keyboard, isCreating: Bool = false) {
        let iView = self.viewModel.view
        self.viewModel.tool = tool
        self.titleLabel.text = tool.title()
        
        switch tool {
        case .background:
            self.graphicStackView.isHidden = true
            self.toolStackView.isHidden = true
            self.textStackView.isHidden = true
            self.colorStackView.isHidden = false
            let toolHeight = self.colorStackView.bounds.height
            self.updateToNewHeight(toolHeight)
            break
        case .media:
            //dismiss and open image/video picker native
            self.didMediaPressed?.handler(tool)
            break
        case .text:
            //show text editor
            self.graphicStackView.isHidden = true
            self.toolStackView.isHidden = true
            self.textStackView.isHidden = false
            self.colorStackView.isHidden = true
            self.manageText(textMenu, isCreating: isCreating)
            break
        case .graphic:
            self.graphicStackView.isHidden = false
            self.toolStackView.isHidden = true
            self.textStackView.isHidden = true
            self.colorStackView.isHidden = true
            self.manageGraphic(self.graphicMenu)
            //show graphic, sticker
            break
        case .quiz:
            //show quiz editor
            self.graphicStackView.isHidden = true
            self.toolStackView.isHidden = false
            self.textStackView.isHidden = true
            self.colorStackView.isHidden = true
            self.didCreateQuiz?.handler(nil)
            break
        case .menu:
            //show hide all tool
            self.textStackView.isHidden = true
            self.graphicStackView.isHidden = true
            self.toolStackView.isHidden = false
            self.textStackView.isHidden = true
            self.colorStackView.isHidden = true
            break
        }
    }
    
    func manageGraphic(_ menu: FLGraphicMenu) {
        self.viewModel.graphicMenu = menu
        self.viewModel.callApiGraphic { (list) in
            self.graphicView.update(graphicList: list)
        }
        
        //self.graphicSelectView.frame = CGRect(x: 0, y: 28, width: self.shapeButton.frame.width, height: 2)
        switch menu {
        //TODO: api reload if need
        case .sticker:
            self.stickerButton.tintColor = .black
            self.shapeButton.tintColor = .text50()
            
            break
        case .shape:
            self.stickerButton.tintColor = .text50()
            self.shapeButton.tintColor = .black
            break
        }
    }
    
    var element: FlashElement?
    
    func manageText(_ textMenu: FLTextMenu, isCreating: Bool) {
        self.textMenu = textMenu
        switch textMenu {
        case .keyboard:
            if !isCreating {
                self.resetTextView(menu: textMenu, isActive: true)
            }
            self.keyboardView.isHidden = false
            self.textStyleView.isHidden = true
            self.textColorView.isHidden = true
            
            break
        case .style:
            self.resetTextView(menu: textMenu)
            self.keyboardView.isHidden = true
            self.textStyleView.isHidden = false
            self.textColorView.isHidden = true
            if let e = self.element {
                self.textStyleView.styleList = e.flTextStyle
                self.textStyleView.alignment = e.flAlignment
                self.textStyleView.setAlinement(a: e.flAlignment)
            }
            break
        case .color:
            self.resetTextView(menu: textMenu)
            self.keyboardView.isHidden = true
            self.textStyleView.isHidden = true
            self.textColorView.isHidden = false
            if let e = self.element {
                self.textColorView.selectedColor = e.textColor
                self.textColorView.reloadColor()
            }
            break
        }
        
    }
    
    func resetTextView(menu: FLTextMenu, isActive: Bool = false) {
        //resignFirstResponder > textViewDidEndEditing
        //make isSelected = false
        //need to set iView still selecting
        var textView: UITextView!
        if let iViewText = self.viewModel.view as? InteractTextView {
            textView = iViewText.textView
            
        } else if let iView = self.viewModel.view as? InteractView {
            iView.isCreateNew = false
            iView.isSelected = true
            textView = iView.textView!
        }
        
        if isActive, !textView.isFirstResponder {
            // back to keyboard
            if let text = textView.text, menu == .keyboard {
                //let range = NSRange(textView.text)
                let start = textView.beginningOfDocument
                let end = textView.endOfDocument
                textView.selectedTextRange = textView.textRange(from: start, to: end)!
                textView.becomeFirstResponder()
                print("resetTextView select view \(isActive) : isFirstResponder\(textView.isFirstResponder)")
            }
            //
        } else if isActive {
            print("resetTextView select view \(isActive) : isFirstResponder\(textView.isFirstResponder)")
            //ignore resignFirstResponder
        } else {
            //textView.selectedTextRange = nil
            if textView.isFirstResponder {
                //case still editing and goto style, color
                //dismiss keyboard
                textView.resignFirstResponder()
                print("resetTextView select view \(isActive) : isFirstResponder\(textView.isFirstResponder)")
                
            } else {
                
                print("resetTextView select view \(isActive) : isFirstResponder\(textView.isFirstResponder)")
            }
            
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton?) {
        self.dismiss(animated: true, completion: nil)//if use present
        
        //reset to tool UI
        self.toolStackView.isHidden = false
        let tool = self.viewModel.tool
        
        self.didClose?.handler(tool)
        
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
            self.graphicStackView.isHidden = true
            self.viewModel.tool = .menu
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
