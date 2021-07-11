//
//  FLMenuBarView.swift
//  flash
//
//  Created by Songwut Maneefun on 1/7/2564 BE.
//

import UIKit

class FLMenuBarView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instanciateFromNib() -> FLMenuBarView {
        return Bundle.main.loadNibNamed("FLMenuBarView", owner: nil, options: nil)![0] as! FLMenuBarView
    }
}

