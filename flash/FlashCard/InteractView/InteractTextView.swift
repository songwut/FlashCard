//
//  InteractTextView.swift
//  flash
//
//  Created by Songwut Maneefun on 16/7/2564 BE.
//

import UIKit

class InteractTextView: InteractView {

    @IBOutlet weak var textViewInSide: UITextView!
    
    override func awakeFromNib() {
        
    }
    
    class func instanciateFromNib() -> InteractTextView {
        return Bundle.main.loadNibNamed("InteractTextView", owner: nil, options: nil)![0] as! InteractTextView
    }

}
