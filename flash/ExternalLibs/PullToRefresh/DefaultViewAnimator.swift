//
//  DefaultViewAnimator.swift
//  PullToRefreshDemo
//
//  Created by Serhii Butenko on 26/7/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class DefaultViewAnimator: RefreshViewAnimator {
    
    fileprivate let refreshView: DefaultRefreshView
    
    init(refreshView: DefaultRefreshView) {
        self.refreshView = refreshView
    }
    
    func animate(_ state: PTRState) {
        switch state {
        case .initial:
            refreshView.activityIndicator.stopAnimating()
            
        case .releasing(let progress):
            refreshView.activityIndicator.isHidden = false
            
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: progress, y: progress)
            transform = transform.rotated(by: CGFloat(Double.pi) * progress * 2)
            refreshView.activityIndicator.transform = transform
            
        case .loading:
            refreshView.activityIndicator.startAnimating()
            
        default: break
        }
    }
}
