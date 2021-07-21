//
//  FLItemView.swift
//  flash
//
//  Created by Songwut Maneefun on 1/7/2564 BE.
//

import UIKit

final class FLItemView: UIView {
    
    @IBOutlet weak var button: FLButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var didPressTool: DidAction?
    
    var didPressAlignment: DidAction?
    
    var textStyle: FLTextStyle?{
        didSet {
            guard let textStyle = self.textStyle else { return }
            self.updateUI()
            self.titleLabel.text = textStyle.rawValue
            let icon = UIImage(named: textStyle.iconName())
            self.button.textStyle = textStyle
            self.button.setImage(icon, for: .normal)
            self.button.borderWidth = 1
            self.button.borderColor = .clear
            self.button.backgroundColor = .clear
            self.button.tintColor = ColorHelper.text75()
        }
        
    }
    
    
    var alignment: FLTextAlignment! = .center {
        didSet {
            self.updateUI()
            let icon = UIImage(named: self.alignment.iconName())
            self.button.alignment = self.alignment
            self.button.setImage(icon, for: .normal)
            self.button.borderWidth = 1
            self.button.borderColor = UIColor("7D7D7D")
            self.button.backgroundColor = .clear
            self.button.tintColor = ColorHelper.text50()
            self.titleLabel.isHidden = true
        }
    }
    
    
    
    var tool: FLTool! = .none {
        didSet {
            self.updateUI()
            let icon = UIImage(named: self.tool.iconName())
            self.button.tool = self.tool
            self.button.setImage(icon, for: .normal)
            self.titleLabel.text = self.tool.name()
            self.button.addTarget(self, action: #selector(self.toolPressed(_:)), for: .touchUpInside)
        }
    }
    
    @objc func toolPressed(_ sender: UIButton) {
        self.didPressTool?.handler(self.tool)
    }
    
    private func updateUI() {
        self.button.updateLayout()
        let edge = self.button.bounds.height * FlashStyle.iconEedge
        self.button.imageEdgeInsets = UIEdgeInsets(top: edge, left: edge, bottom: edge, right: edge)
        self.button.cornerRadius = 8
    }
    
    override func awakeFromNib() {
        self.button.backgroundColor = FlashStyle.bottonToolColor
        self.button.tintColor = .white
    }
    
    class func instanciateFromNib() -> FLItemView {
        return Bundle.main.loadNibNamed("FLItemView", owner: nil, options: nil)![0] as! FLItemView
    }
}
