//
//  SlideSheetPresentationController.swift
//  flash
//
//  Created by Songwut Maneefun on 8/7/2564 BE.
//

import UIKit

class SlideSheetPresentationController: UIPresentationController {
    
    let shadowView: UIView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        shadowView = UIView()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.shadowView.isUserInteractionEnabled = true
        self.shadowView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                0.6))
    }

    override func presentationTransitionWillBegin() {
        self.shadowView.alpha = 0
        self.containerView?.addSubview(shadowView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.shadowView.alpha = 0.7
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.shadowView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.shadowView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
      presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        shadowView.frame = containerView!.bounds
    }

    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
