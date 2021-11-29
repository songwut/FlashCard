//
//  FLTypeButton.swift
//  flash
//
//  Created by Songwut Maneefun on 4/7/2564 BE.
//

import UIKit

class FLTypeButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class RotationGesture: UIRotationGestureRecognizer {
    
}
class PanGesture: UIPanGestureRecognizer {
    
}
class TapGesture: UITapGestureRecognizer {
    
}

class PinchGesture: UIPinchGestureRecognizer {
    
}

class FLTextView: UITextView {
    override open func layoutSubviews() {
        super.layoutSubviews()
        print("FLTextView layoutSubviews")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
//            return false
//        } else if action == #selector(UIResponderStandardEditActions.copy(_:)) {
//            return false
//        } else if action == #selector(UIResponderStandardEditActions.cut(_:)) {
//            return false
//        }
//        return false
        
        return super.canPerformAction(action, withSender: sender)
    }
}
