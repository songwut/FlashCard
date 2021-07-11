//
//  SheetCardViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 6/7/2564 BE.
//

import UIKit

class SheetCardViewController: UIViewController {
    
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.clear
        return bdView
    }()
    
    var sheetHeight = UIScreen.main.bounds.height / 2
    var isPresenting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        
        self.view.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension SheetCardViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = transitionDuration(using: transitionContext)
        isPresenting = !isPresenting
        
        if isPresenting == true {
            
            //self.view.frame.origin.y += sheetHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
                self.view.frame.origin.y -= self.sheetHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
                self.view.frame.origin.y += self.sheetHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
        
    }
}
