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
    
    var didChangeTextStyle: Action?
    var didChangeTextAlignment: Action?
    
    var alignment: FLTextAlignment? {
        didSet {
        }
    }
    
    var styleList = [FLTextStyle]() {
        didSet {
            self.setStyle(button: boldButton, list: styleList)
            self.setStyle(button: italicButton, list: styleList)
            self.setStyle(button: underlineButton, list: styleList)
        }
    }
    
    @IBAction func alignmentPressed(_ sender: UIButton) {
        guard let btn = sender as? FLButton else { return }
        self.setAlinement(a: btn.alignment)
        self.didChangeTextAlignment?.handler(btn.alignment)
    }
    
    @IBAction func stylePressed(_ sender: UIButton) {
        guard let btn = sender as? FLButton else { return }
        self.manageStyleList(new: btn.textStyle)
        self.setStyle(button: btn, list: styleList)
        self.didChangeTextStyle?.handler(btn.textStyle)
    }
    
    func manageStyleList(new: FLTextStyle?) {
        guard let newStyle = new else { return }
        if styleList.contains(newStyle) {
            let index = styleList.firstIndex { (style) -> Bool in
                return style == newStyle
            }
            if let i = index {
                styleList.remove(at: i)
            }
        } else {
            styleList.append(newStyle)
        }
        
        print("styleList: \(styleList)")
    }
    
    override func awakeFromNib() {
        self.layoutStackView.axis = UIDevice.isIpad() ? .horizontal : .vertical
        
        self.boldLabel.text = FLTextStyle.bold.rawValue
        self.boldButton.textStyle = .bold
        self.boldButton.tintColor = .text75()
        self.boldButton.cornerRadius = 8
        
        self.italicLabel.text = FLTextStyle.italic.rawValue
        self.italicButton.textStyle = .italic
        self.italicButton.tintColor = .text75()
        self.italicButton.cornerRadius = 8
        
        self.underlineLabel.text = FLTextStyle.underline.rawValue
        self.underlineButton.textStyle = .underline
        self.underlineButton.tintColor = .text75()
        self.underlineButton.cornerRadius = 8
        
        self.leftButton.alignment = .left
        self.leftButton.tintColor = .text50()
        
        self.centerButton.alignment = .center
        self.centerButton.tintColor = .text50()
        
        self.righrButton.alignment = .right
        self.righrButton.tintColor = .text50()
        
        self.justifiedButton.alignment = .justified
        self.justifiedButton.tintColor = .text50()
        
    }
    
    func setAlinement(a: FLTextAlignment) {
        let color = UIColor("7D7D7D")
        self.leftButton.tintColor = self.leftButton.alignment == a ? .black : color
        self.centerButton.tintColor = self.centerButton.alignment == a ? .black : color
        self.righrButton.tintColor = self.righrButton.alignment == a ? .black : color
        self.justifiedButton.tintColor = self.justifiedButton.alignment == a ? .black : color
    }
    
    func setStyle(button: FLButton, list: [FLTextStyle]) {
        let boldList = list.filter { (style) -> Bool in
            return style == .bold
        }
        if let _ = boldList.first {
            self.boldButton.tintColor = .black
            self.boldButton.borderColor = .black
        } else {
            self.boldButton.tintColor = .text75()
            self.boldButton.borderColor = UIColor("7D7D7D")
        }
        
        let italicList = list.filter { (style) -> Bool in
            return style == .italic
        }
        if let _ = italicList.first {
            self.italicButton.tintColor = .black
            self.italicButton.borderColor = .black
        } else {
            self.italicButton.tintColor = .text75()
            self.italicButton.borderColor = UIColor("7D7D7D")
        }
        
        let underlineList = list.filter { (style) -> Bool in
            return style == .underline
        }
        if let _ = underlineList.first {
            self.underlineButton.tintColor = .black
            self.underlineButton.borderColor = .black
        } else {
            self.underlineButton.tintColor = .text75()
            self.underlineButton.borderColor = UIColor("7D7D7D")
        }
    }
    
    class func instanciateFromNib() -> FLTextStyleView {
        return Bundle.main.loadNibNamed("FLTextStyleView", owner: nil, options: nil)![0] as! FLTextStyleView
    }

}
