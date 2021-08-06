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
    
    func setColor(_ color: UIColor, count: Int? = nil, menu: FLMenuList) {
        self.button.tintColor = color
        self.titleLabel.textColor = color
        var text = menu.text().localized()
        if let c = count {
            text = text + " (\(c))"
        }
        self.titleLabel.text = text
    }
    
    var menu: FLMenuList = .select {
        didSet {
            
            self.button.updateLayout()
            let edge:CGFloat = self.button.frame.width * 0.3
            self.button.imageEdgeInsets = UIEdgeInsets(top: edge, left: edge, bottom: edge, right: edge)
            
            let icon = UIImage(named: self.menu.iconName())
            self.button.actionMenu = self.menu
            self.button.setImage(icon, for: .normal)
            self.button.backgroundColor = .clear
            //self.button.contentVerticalAlignment = .center
            //self.button.contentHorizontalAlignment = .center
            
            self.titleLabel.text = self.menu.text().localized()
            self.button.tintColor = ColorHelper.text75()
            self.titleLabel.textColor = ColorHelper.text()
        }
    }
    
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
