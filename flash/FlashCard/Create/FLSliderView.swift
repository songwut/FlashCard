//
//  FLSliderView.swift
//  flash
//
//  Created by Songwut Maneefun on 13/7/2564 BE.
//

import UIKit

final class FLSliderView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftWidth: NSLayoutConstraint!
    @IBOutlet weak var rightWidth: NSLayoutConstraint!
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    override func awakeFromNib() {
        
    }
    
    class func instanciateFromNib() -> FLSliderView {
        return Bundle.main.loadNibNamed("FLSliderView", owner: nil, options: nil)![0] as! FLSliderView
    }
}
