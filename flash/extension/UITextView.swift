//
//  UITextView.swift
//  flash
//
//  Created by Songwut Maneefun on 20/7/2564 BE.
//

import UIKit

extension UITextView {
    func frameFromContent(fixWidth: CGFloat? = nil) -> CGRect {
        //get width by content
        let textViewSize = self.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        //with from content
        let width = fixWidth ?? textViewSize.width
        
        let callH = self.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        print("textViewSize: \(textViewSize)")
        print("callH: \(callH)")
        return CGRect(origin: self.frame.origin, size: textViewSize)
    }
}
