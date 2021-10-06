//
//  UITextView.swift
//  flash
//
//  Created by Songwut Maneefun on 20/7/2564 BE.
//

import UIKit
extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[.foregroundColor: newValue!])
        }
    }
}
extension UITextView {
    func frameFromContent(fixWidth: CGFloat? = nil) -> CGRect {
        //get width by content
        let textViewSize = self.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        //with from content
        var width = fixWidth ?? textViewSize.width
        let fix: CGFloat = 10
        //width = width + fix
        let height = self.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        print("textViewSize: \(textViewSize)")
        print("height: \(height)")
        return CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height + fix))
    }
}
