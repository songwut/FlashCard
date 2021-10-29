//
//  SnapGesture.swift
//  flash
//
//  Created by Songwut Maneefun on 20/7/2564 BE.
//

import UIKit

/*
 usage:

    add gesture:
        yourObjToStoreMe.snapGesture = SnapGesture(view: your_view)
    remove gesture:
        yourObjToStoreMe.snapGesture = nil
    disable gesture:
        yourObjToStoreMe.snapGesture.isGestureEnabled = false
    advanced usage:
        view to receive gesture(usually superview) is different from view to be transformed,
        thus you can zoom the view even if it is too small to be touched.
        yourObjToStoreMe.snapGesture = SnapGesture(transformView: your_view_to_transform, gestureView: your_view_to_recieve_gesture)

 */

class SnapGesture: NSObject, UIGestureRecognizerDelegate {

    // MARK: - init and deinit
    convenience init(view: InteractView) {
        self.init(transformView: view, gestureView: view)
    }
    init(transformView: UIView, gestureView: InteractView) {
        super.init()

        self.addGestures(v: gestureView)
        self.weakTransformView = transformView
    }
    deinit {
        self.cleanGesture()
    }
    
    var minimumSize:CGFloat = 30

    // MARK: - private method
    private weak var weakGestureView: UIView?
    private weak var weakTransformView: UIView?

    private var tapGesture: UITapGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?
    private var pinchGesture: UIPinchGestureRecognizer?
    private var rotationGesture: UIRotationGestureRecognizer?

    private func addGestures(v: InteractView) {
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapProcess(_:)))
        v.addGestureRecognizer(tapGesture!)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panProcess(_:)))
        v.isUserInteractionEnabled = true
        panGesture?.delegate = self     // for simultaneous recog
        v.addGestureRecognizer(panGesture!)

        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchMoveScale(_:)))
        //view.isUserInteractionEnabled = true
        pinchGesture?.delegate = self   // for simultaneous recog
        v.addGestureRecognizer(pinchGesture!)
        
//        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchScale(_:)))
//        //view.isUserInteractionEnabled = true
//        pinchGesture?.delegate = self   // for simultaneous recog
//        v.addGestureRecognizer(pinchGesture!)
        
        /*
        let isText = (v.element?.type == .text)
        if isText {
            
        } else {
        
        }
         */
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationProcess(_:)))
        rotationGesture?.delegate = self
        v.addGestureRecognizer(rotationGesture!)
        
        self.weakGestureView = v
    }

    private func cleanGesture() {
        if let view = self.weakGestureView {
            //for recognizer in view.gestureRecognizers ?? [] {
            //    view.removeGestureRecognizer(recognizer)
            //}
            if tapGesture != nil {
                view.removeGestureRecognizer(tapGesture!)
                tapGesture = nil
            }
            if panGesture != nil {
                view.removeGestureRecognizer(panGesture!)
                panGesture = nil
            }
            if pinchGesture != nil {
                view.removeGestureRecognizer(pinchGesture!)
                pinchGesture = nil
            }
            if rotationGesture != nil {
                view.removeGestureRecognizer(rotationGesture!)
                rotationGesture = nil
            }
        }
        self.weakGestureView = nil
        self.weakTransformView = nil
    }




    // MARK: - API

    private func setView(view:UIView?) {
        self.setTransformView(view, gestgureView: view)
    }

    private func setTransformView(_ transformView: UIView?, gestgureView:UIView?) {
        self.cleanGesture()

        if let v = gestgureView as? InteractView {
            self.addGestures(v: v)
        }
        self.weakTransformView = transformView
    }

    open func resetViewPosition() {
        UIView.animate(withDuration: 0.4) {
            self.weakTransformView?.transform = CGAffineTransform.identity
        }
    }

    open var isGestureEnabled = true

    // MARK: - gesture handle
    
    @objc func tapProcess(_ gesture: UITapGestureRecognizer) {
        //self.flCreator.selectedView?.isSelected = false
        
        guard let iView = gesture.view as? InteractView else { return }
        iView.isSelected = true
    }

    // location will jump when finger number change
    private var initPanFingerNumber:Int = 1
    private var isPanFingerNumberChangedInThisSession = false
    private var lastPanPoint:CGPoint = CGPoint(x: 0, y: 0)
    @objc func panProcess(_ gesture:UIPanGestureRecognizer) {
        if isGestureEnabled {
            //guard let view = recognizer.view else { return }
            guard let iView = self.weakTransformView as? InteractView else { return }
           
            iView.unSelectTextView()
            iView.isSelected = true
            if let stageView = self.weakTransformView?.superview as? FLStageView {
                let translation = gesture.translation(in: stageView)
                print("move")
                print("x : \(translation.x)")
                print("y : \(translation.y)")
            }

            // init
            if gesture.state == .began {
                lastPanPoint = gesture.location(in: iView)
                initPanFingerNumber = gesture.numberOfTouches
                isPanFingerNumberChangedInThisSession = false
            }

            // judge valid
            if gesture.numberOfTouches != initPanFingerNumber {
                isPanFingerNumberChangedInThisSession = true
            }
            if isPanFingerNumberChangedInThisSession {
                return
            }

            // perform change
            let point = gesture.location(in: iView)
            iView.transform = iView.transform.translatedBy(x: point.x - lastPanPoint.x, y: point.y - lastPanPoint.y)
            print("width:\(iView.bounds.width)")
            iView.setNeedsDisplay()
            lastPanPoint = gesture.location(in: iView)
        }
    }


    var initialBounds = CGRect.zero
    var initialDistance: CGFloat = 0
    var deltaAngle: CGFloat = 0

    private var lastScale:CGFloat = 1.0
    private var lastIconScale:CGFloat = 1.0
    private var lastPinchPoint:CGPoint = CGPoint(x: 0, y: 0)
    @objc func pinchMoveScale(_ recognizer:UIPinchGestureRecognizer) {
        if isGestureEnabled {
            guard let view = self.weakTransformView as? InteractView else { return }
            view.unSelectTextView()
            let touchLocation = recognizer.location(in: view.superview)
            let center = view.center
            // judge valid
            if recognizer.numberOfTouches < 2 {
                lastPinchPoint = recognizer.location(in: view)
                return
            }
            
            switch recognizer.state {
            case .began:
                lastScale = 1.0;
                lastIconScale = 1.0
                lastPinchPoint = recognizer.location(in: view)
                deltaAngle = CGFloat(atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))) - getAngle(view.transform)
                initialBounds = view.bounds
                initialDistance = getDistance(center, touchLocation)
                break
            case .changed:
                // Scale
                let scale = 1.0 - (lastScale - recognizer.scale);
                let tScale = view.transform.scaledBy(x: scale, y: scale)
                view.transform = tScale
                lastScale = recognizer.scale;
                
                // Translate
                let point = recognizer.location(in: view)
                view.transform = view.transform.translatedBy(x: point.x - lastPinchPoint.x, y: point.y - lastPinchPoint.y)
                
                var fScale = getDistance(center, touchLocation) / initialDistance
                let min:CGFloat = [initialBounds.size.width, initialBounds.size.height].min() ?? 0
                let minimumScale = CGFloat(self.minimumSize) / min
                let max: CGFloat = [fScale, minimumScale].max() ?? 0
                fScale = max
                let scaledBounds = getRectScale(initialBounds, fScale, scale)
                //view.bounds = scaledBounds
                //view.setNeedsDisplay()
                print("Pinch width:\(view.bounds.width)")
                
                view.closeImageView?.transform = tScale.inverted()
                view.flipImageView?.transform = tScale.inverted()
                view.rotateImageView?.transform = tScale.inverted()
                view.noneImageView?.transform = tScale.inverted()
                
                lastPinchPoint = recognizer.location(in: view)
                break
            default:
                break
            }
            
        }
    }
    
    @objc func pinchScale(_ gesture: UIPinchGestureRecognizer) {
        print("x:\(gesture.scale)")
        print("y:\(gesture.scale)")
        guard let view = gesture.view as? InteractView else { return }
        
        let scale = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        view.transform = scale
        gesture.scale = 1
        
        view.closeImageView?.transform = scale.inverted()
        view.flipImageView?.transform = scale.inverted()
        view.rotateImageView?.transform = scale.inverted()
        view.noneImageView?.transform = scale.inverted()
        //limit scale
        view.setNeedsDisplay()
        if scale.a > 1, scale.d > 1 {
            
        }
    }
    
    func  getRectScale(_ rect: CGRect, _ wScale: CGFloat, _ hScale: CGFloat) -> CGRect {
        return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * wScale, height: rect.size.height * hScale)
    }
    
    func getAngle(_ t: CGAffineTransform ) -> CGFloat {
      return atan2(t.b, t.a);
    }
    
    func getDistance(_ point1: CGPoint, _ point2: CGPoint ) -> CGFloat {
        let fx = CGFloat(point2.x - point1.x)
        let fy = CGFloat(point2.y - point1.y)
        return sqrt((fx * fx + fy * fy))
    }


    @objc func rotationProcess(_ gesture: UIRotationGestureRecognizer) {
        if isGestureEnabled {
//            guard let view = self.weakTransformView else { return }
//
//            view.transform = view.transform.rotated(by: recognizer.rotation)
//            self.controlView?.updateRelateView(view)
//            recognizer.rotation = 0
            
            
            guard let view = self.weakTransformView as? InteractView else { return }
            view.isSelected = true
            var originalRotation = CGFloat()
            if gesture.state == .began {
                print("sender.rotation: \(gesture.rotation)")
                //gesture.rotation is radians
                //view.rotation is degrees
                let radians = self.getRadians(degrees: Double(view.rotation))
                gesture.rotation = CGFloat(radians)
                originalRotation = gesture.rotation
                
            } else if gesture.state == .changed {
                let scale = CGAffineTransform(scaleX: view.currentScale.x, y: view.currentScale.y)
                let newRotation = gesture.rotation + originalRotation
                view.transform = scale.rotated(by: newRotation)
                view.setNeedsDisplay()
                //view.closeImageView?.transform = view.transform.inverted()
                //view.flipImageView?.transform = view.transform.inverted()
                //view.rotateImageView?.transform = view.transform.inverted()
                //view.noneImageView?.transform = view.transform.inverted()
                view.setPosition(.topRight, for: .close)
                let degrees = view.getDegreesRotation()
                print("changed degrees: \(degrees)")
                
            } else if gesture.state == .ended {
                // Save the last rotation
                let degrees = view.getDegreesRotation()
                print("ended degrees: \(degrees)")
                view.rotation = Double(degrees)
                gesture.rotation = 0
            }
        }
    }

    private func getRadians(degrees: Double) -> Double {
        let radians = degrees * .pi / 180
        return radians
    }

    //MARK:- UIGestureRecognizerDelegate Methods
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }

}
