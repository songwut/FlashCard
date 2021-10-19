//
//  DashBorderView.swift
//  flash
//
//  Created by Songwut Maneefun on 26/8/2564 BE.
//

import UIKit

@IBDesignable
class DashBorderView: UIView {

    @IBInspectable var dashColor:UIColor = UIColor.purple
    @IBInspectable var dashBorderWidth:CGFloat = 3
    var lineDash: [NSNumber] = [4, 4]
    private let border = CAShapeLayer()

    override func draw(_ rect: CGRect) {
        border.lineWidth = dashBorderWidth
        border.frame = self.bounds
        border.fillColor = nil
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.addSublayer(border)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        border.lineDashPattern = self.lineDash
        border.strokeColor = dashColor.cgColor
    }
}
