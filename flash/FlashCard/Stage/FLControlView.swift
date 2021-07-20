//
//  FLControlView.swift
//  flash
//
//  Created by Songwut Maneefun on 15/7/2564 BE.
//

import UIKit

enum FLTag: Int {
    case left = 1
    case right = 2
}

class FLControlView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var leftWidthButton: UIButton!
    @IBOutlet weak var rightWidthButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    override func layoutSubviews() {
        print("FLControlView \(self.frame)")
    }
    
    func updateFrame(_ frame: CGRect, center: CGPoint) {
        let size = frame.size
        let margin = FlashStyle.text.marginIView
        self.frame = CGRect(x: frame.origin.x - (margin / 2), y: frame.origin.y - (margin / 2), width: size.width + margin, height: size.height + margin)
        //self.center = center
    }
    
    func manageControlView(_ frame: CGRect, isHidden: Bool) {
        self.frame = frame
        self.isHidden = isHidden
    }

    override func awakeFromNib() {
        self.isUserInteractionEnabled = true
        self.view.borderWidth = 1
        self.view.borderColor = .black
        self.view.backgroundColor = .clear
    }
    
    class func instanciateFromNib() -> FLControlView {
        return Bundle.main.loadNibNamed("FLControlView", owner: nil, options: nil)![0] as! FLControlView
    }

}
