//
//  FLPageControlView.swift
//  flash
//
//  Created by Songwut Maneefun on 3/7/2564 BE.
//

import UIKit

class FLPageControlView: UIView {
    
    var numberOfPages: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard numberOfPages > 0 else { return }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}
