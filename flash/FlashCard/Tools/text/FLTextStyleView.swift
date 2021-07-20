//
//  FLTextStyleView.swift
//  flash
//
//  Created by Songwut Maneefun on 13/7/2564 BE.
//

import UIKit

class FLTextStyleView: UIView {

    @IBOutlet weak var layoutStackView: UIStackView!
    @IBOutlet weak var styleStackView: UIStackView!
    @IBOutlet weak var alignmentStackView: UIStackView!
    
    @IBOutlet weak var boldButton: FLButton!
    @IBOutlet weak var italicButton: FLButton!
    @IBOutlet weak var underlineButton: FLButton!
    @IBOutlet weak var boldLabel: UILabel!
    @IBOutlet weak var italicLabel: UILabel!
    @IBOutlet weak var underlineLabel: UILabel!
    
    @IBOutlet weak var leftButton: FLButton!
    @IBOutlet weak var centerButton: FLButton!
    @IBOutlet weak var righrButton: FLButton!
    @IBOutlet weak var justifiedButton: FLButton!
    
    var didChangeTextStyle: DidAction?
    var didChangeTextAlignment: DidAction?
    
    
    @IBAction func alignmentPressed(_ sender: UIButton) {
        guard let btn = sender as? FLButton else { return }
        self.didChangeTextAlignment?.handler(btn.alignment)
    }
    
    @IBAction func stylePressed(_ sender: UIButton) {
        guard let btn = sender as? FLButton else { return }
        self.didChangeTextStyle?.handler(btn.textStyle)
    }
    
    override func awakeFromNib() {
        self.layoutStackView.axis = UIDevice.isIpad() ? .horizontal : .vertical
        
        self.boldLabel.text = FLTextStyle.bold.rawValue
        self.boldButton.textStyle = .bold
        self.boldButton.tintColor = .text75()
        
        self.italicLabel.text = FLTextStyle.italic.rawValue
        self.italicButton.textStyle = .italic
        self.italicButton.tintColor = .text75()
        
        self.underlineLabel.text = FLTextStyle.underline.rawValue
        self.underlineButton.textStyle = .underline
        self.underlineButton.tintColor = .text75()
        
        self.leftButton.alignment = .left
        self.leftButton.borderColor = UIColor("7D7D7D")
        self.leftButton.tintColor = .text50()
        
        self.centerButton.alignment = .left
        self.centerButton.borderColor = UIColor("7D7D7D")
        self.centerButton.tintColor = .text50()
        
        self.righrButton.alignment = .left
        self.righrButton.borderColor = UIColor("7D7D7D")
        self.righrButton.tintColor = .text50()
        
        self.justifiedButton.alignment = .left
        self.justifiedButton.borderColor = UIColor("7D7D7D")
        self.justifiedButton.tintColor = .text50()
        
    }
    
    class func instanciateFromNib() -> FLTextStyleView {
        return Bundle.main.loadNibNamed("FLTextStyleView", owner: nil, options: nil)![0] as! FLTextStyleView
    }

}
