//
//  HalfModalTransitioningDelegate.swift
//  HalfModalPresentationController
//
//  Created by Martin Normark on 17/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class HalfModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var viewController: UIViewController
    var presentingViewController: UIViewController
    var interactionController: HalfModalInteractiveTransition
    
    var startHeight: CGFloat?
    var backgroundColor: UIColor?
    var interactiveDismiss = true
    
    init(viewController: UIViewController, presentingViewController: UIViewController) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController
        self.interactionController = HalfModalInteractiveTransition(viewController: self.viewController, withView: self.presentingViewController.view, presentingViewController: self.presentingViewController)
        
        super.init()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        interactiveDismiss = false
        return HalfModalTransitionAnimator(type: .Dismiss)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
        present.startHeight = self.startHeight
        present.backgroundColor = self.backgroundColor
        return present
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactiveDismiss {
            return self.interactionController
        }
        
        return nil
    }
    
}

extension UIViewController { }
