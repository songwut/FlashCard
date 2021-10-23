//
//  LoadingPageView.swift
//  LEGO
//
//  Created by Songwut on 23/2/2561 BE.
//  Copyright © 2561 Conicle. All rights reserved.
//

import UIKit

class LoadingPageView: UIView {

    var refreshControl: UIActivityIndicatorView!
    var isAnimatingFinal:Bool = false
    var currentTransform:CGAffineTransform?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.refreshControl = UIActivityIndicatorView(style: .medium)
        self.refreshControl.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.refreshControl.center = self.center
        self.refreshControl.color = .config_primary()
        self.addSubview(self.refreshControl)
        self.prepareInitialAnimation()
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTransform(inTransform:CGAffineTransform, scaleFactor:CGFloat) {
        if isAnimatingFinal {
            return
        }
        self.currentTransform = inTransform
    }
    
    func prepareInitialAnimation() {
        
        self.isAnimatingFinal = false
        self.refreshControl?.stopAnimating()
    }
    
    func startAnimate() {
        self.refreshControl?.startAnimating()
    }
    
    func stopAnimate() {
        self.refreshControl?.stopAnimating()
    }
    
    func animateFinal() {
        if isAnimatingFinal {
            return
        }
        self.isAnimatingFinal = true
        UIView.animate(withDuration: 0.2) {
            self.refreshControl?.transform = CGAffineTransform.identity
        }
    }
}
