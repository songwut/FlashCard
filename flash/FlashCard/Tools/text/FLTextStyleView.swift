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
    
    var didChangeTextStyle: DidAction?
    var didChangeTextAlignment: DidAction?
    
    func setup() {
        
    }
    
    override func awakeFromNib() {
        self.layoutStackView.axis = UIDevice.isIpad() ? .horizontal : .vertical
        
    }
    
    class func instanciateFromNib() -> FLTextStyleView {
        return Bundle.main.loadNibNamed("FLTextStyleView", owner: nil, options: nil)![0] as! FLTextStyleView
    }

}
