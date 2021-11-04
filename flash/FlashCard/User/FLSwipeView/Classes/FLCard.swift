//
//  TinderCard.swift
//  TinderSwipeView
//
//  Created by Nick on 11/05/19.
//  Copyright © 2019 Nick. All rights reserved.
//

import UIKit

let theresoldMargin = (UIScreen.main.bounds.size.width/2) * 0.75
let stength : CGFloat = 4
let range : CGFloat = 0.90

protocol TinderCardDelegate: NSObjectProtocol {
    func didSelectCard(card: FLCard)
    func cardGoesRight(card: FLCard)
    func cardGoesLeft(card: FLCard)
    func currentCardStatus(card: FLCard, distance: CGFloat)
    func fallbackCard(card: FLCard)
}

class FLCard: UIView {
    
    var index: Int!
    
    var overlay: UIView?
    var containerView : UIView!
    weak var delegate: TinderCardDelegate?
    
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var originalPoint = CGPoint.zero
    
    var isLiked = false
    var model : Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * Initializing View
     */
    private var theShadowLayer: CAShapeLayer?
    func setupView() {
        
        if self.theShadowLayer == nil {
            let rounding = FlashStyle.cardCornerRadius

            let shadowLayer = CAShapeLayer()
            self.theShadowLayer = shadowLayer
            shadowLayer.path = UIBezierPath.init(roundedRect: bounds, cornerRadius: rounding).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor

            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowRadius = FlashStyle.cardCornerRadius
            shadowLayer.shadowOpacity = Float(0.2)
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)

            self.layer.insertSublayer(shadowLayer, at: 0)
            
        }
        
        originalPoint = center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        
        containerView = UIView(frame: bounds)
        containerView.backgroundColor = .clear
        
//        containerView.cornerRadius = FlashStyle.cardCornerRadius //bounds.width/20
//        containerView.clipsToBounds = false
//        containerView.layer.masksToBounds = false
//        containerView.layer.shadowRadius = FlashStyle.cardCornerRadius
//        containerView.layer.shadowOpacity = 0.2
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        containerView.layer.shadowColor = UIColor.black.cgColor
    }
    
    /*
     * Adding Overlay to TinderCard
     */
    func addContentView( view: UIView?){
        
        if let overlay = view{
            self.overlay = overlay
            self.insertSubview(overlay, belowSubview: containerView)
        }
    }
    
    /*
     * Card goes right method
     */
    func cardGoesRight() {
        
        delegate?.cardGoesRight(card: self)
        let finishPoint = CGPoint(x: frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = true
    }
    
    /*
     * Card goes left method
     */
    func cardGoesLeft() {
        
        delegate?.cardGoesLeft(card: self)
        let finishPoint = CGPoint(x: -frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            //self.removeFromSuperview()
        })
        isLiked = false
    }
    
    /*
     * Card goes right action method
     */
    func rightClickAction() {
        
        setInitialLayoutStatus(isleft: false)
        let finishPoint = CGPoint(x: center.x + frame.size.width * 2, y: center.y)
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.animateCard(to: finishPoint, angle: 1, alpha: 1.0)
        }, completion: {(_ complete: Bool) -> Void in
            //self.removeFromSuperview()
        })
        isLiked = true
        delegate?.cardGoesRight(card: self)
    }
    
    
    /*
     * Card goes left action method
     */
    func leftClickAction() {
        
        setInitialLayoutStatus(isleft: true)
        let finishPoint = CGPoint(x: center.x - frame.size.width * 2, y: center.y)
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.animateCard(to: finishPoint, angle: -1, alpha: 1.0)
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        isLiked = false
        delegate?.cardGoesLeft(card: self)
    }
    
    /*
     * Reverting current card method
     */
    func makeUndoAction() {
        
//        statusImageView.image = makeImage(name: isLiked ? "ic_like" : "overlay_skip")
//        overlayImageView.image = makeImage(name: isLiked ? "overlay_like" : "overlay_skip")
//        statusImageView.alpha = 1.0
//        overlayImageView.alpha = 1.0
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.center = self.originalPoint
            self.transform = CGAffineTransform(rotationAngle: 0)
//            self.statusImageView.alpha = 0
//            self.overlayImageView.alpha = 0
        })
    }
    
    /*
     * Removing last card from view
     */
    func rollBackCard(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    /*
     * Shake animation method
     */
    func shakeAnimationCard(completion: @escaping (Bool) -> ()){
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            let finishPoint = CGPoint(x: self.center.x - (self.frame.size.width / 2), y: self.center.y)
            self.animateCard(to: finishPoint, angle: -0.2, alpha: 1.0)
        }, completion: {(_) -> Void in
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.animateCard(to: self.originalPoint)
            }, completion: {(_ complete: Bool) -> Void in
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    let finishPoint = CGPoint(x: self.center.x + (self.frame.size.width / 2) ,y: self.center.y)
                    self.animateCard(to: finishPoint , angle: 0.2, alpha: 1)
                }, completion: {(_ complete: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        self.animateCard(to: self.originalPoint)
                    }, completion: {(_ complete: Bool) -> Void in
                        completion(true)
                    })
                })
            })
        })
    }
    
    /*
     * Setting up initial status for imageviews
     */
    fileprivate func setInitialLayoutStatus(isleft:Bool){
        
        
    }
    
    /*
     * Acessing image from bundle
     */
    fileprivate func makeImage(name: String) -> UIImage? {
        
        let image = UIImage(named: name, in: Bundle(for: type(of: self)), compatibleWith: nil)
        return image
    }
    
    /*
     * Animation with center point
     */
    fileprivate func animateCard(to center:CGPoint,angle:CGFloat = 0,alpha:CGFloat = 0){
        
        self.center = center
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
}

// MARK: UIGestureRecognizerDelegate Methods
extension FLCard: UIGestureRecognizerDelegate {
    
    /*
     * Gesture methods
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /*
     * Gesture methods
     */
    @objc fileprivate func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        switch gestureRecognizer.state {
        // Keep swiping
        case .began:
            originalPoint = self.center;
            addSubview(containerView)
            self.delegate?.didSelectCard(card: self)
            break;
        //in the middle of a swipe
        case .changed:
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8 * rotationStrength
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: 1, y: 1)
            self.transform = scaleTransform
            updateOverlay(xCenter)
            break;
            
        // swipe ended
        case .ended:
            containerView.removeFromSuperview()
            afterSwipeAction()
            break;
            
        case .possible:break
        case .cancelled:break
        case .failed:break
        @unknown default:
            fatalError()
        }
    }
    
    /*
     * Tinder Card swipe action
     */
    fileprivate func afterSwipeAction() {
        
        if xCenter > theresoldMargin {
            cardGoesRight()
        }
        else if xCenter < -theresoldMargin {
            cardGoesLeft()
        }
        else {
            self.delegate?.fallbackCard(card: self)
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            })
        }
    }
    
    /*
     * Updating overlay methods
     */
    fileprivate func updateOverlay(_ distance: CGFloat) {
        delegate?.currentCardStatus(card: self, distance: distance)
    }
}
