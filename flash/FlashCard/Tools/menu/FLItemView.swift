//
//  FLItemView.swift
//  flash
//
//  Created by Songwut Maneefun on 1/7/2564 BE.
//

import UIKit

final class FLItemView: UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var didPressTool: DidAction?
    
    var tool: FLTool! = .none {
        didSet {
            self.updateUI()
            let icon = UIImage(named: self.tool.iconName())
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
