//
//  FLToolViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 6/7/2564 BE.
//

import UIKit

class FLToolViewController: UIViewController {
    
    var didSelectedColor: DidAction?
    var didCreateText: DidAction?
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var toolStackView: UIStackView!
    @IBOutlet weak var colorStackView: UIStackView!
    
    private var addBarView = FLMenuBarView.instanciateFromNib()
    private var colorToolView = FLColorView.instanciateFromNib()
    
    private var viewModel = FLToolViewModel()
    
    private var colorList = [String]()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.isIpad() ? .all : .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.updateLayout()
        self.view.roundCorners([.topLeft, .topRight], radius: 16)
        self.closeButton.tintColor = .black
        self.createMenuTool(FlashStyle.toolList)
        
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
            toolView.didPressTool = didPressTool
            toolView.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
            self.addBarView.stackView.spacing = spacing
            self.addBarView.stackView.addArrangedSubview(toolView)
        }
        self.toolStackView.addArrangedSubview(self.addBarView)
        self.toolStackView.isHidden = false
        
        self.createColorTool()
    }
    
    func createColorTool() {
        self.colorToolView.didSelectedColor = self.didSelectedColor
        
        self.colorStackView.removeAllArranged()
        self.colorStackView.addArrangedSubview(self.colorToolView)
        self.viewModel.colorList { (colorList) in
            self.colorList = colorList
            self.colorToolView.setup(colorList: self.colorList)
        }
        self.colorStackView.isHidden = true
    }
    
    func setup(_ setup: FLToolViewSetup) {
        self.titleLabel.text = setup.tool.title()
        self.viewModel.tool = setup.tool
    }
    
    func updateToNewHeight(_ height: CGFloat) -> Void {
        if let presetation = self.presentationController as? HalfModalPresentationController {
            let titleHeight = titleView.bounds.height
            presetation.startHeight = titleHeight + height + self.safeAreaBottomHeight
            presetation.changeScale(to: .normal)
        }
    }
    
    func open(_ tool: FLTool) {
        self.viewModel.tool = tool
        self.titleLabel.text = tool.title()
        
        switch tool {
        case .background:
            self.toolStackView.isHidden = true
            self.colorStackView.isHidden = false
            let toolHeight = self.colorStackView.bounds.height
            self.updateToNewHeight(toolHeight)
            break
        case .media:
            //dismiss and open image/video picker native
            break
        case .text:
            //show text editor
            self.didCreateText?.handler(tool)
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
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
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
