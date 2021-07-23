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
    convenience init(view: UIView) {
        self.init(transformView: view, gestureView: view)
    }
    init(transformView: UIView, gestureView: UIView) {
        super.init()

        self.addGestures(v: gestureView)
        self.weakTransformView = transformView
    }
    deinit {
        self.cleanGesture()
    }
    
    var controlView: FLControlView?

    // MARK: - private method
    private weak var weakGestureView: UIView?
    private weak var weakTransformView: UIView?

    private var tapGesture: UITapGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?
    private var pinchGesture: UIPinchGestureRecognizer?
    private var rotationGesture: UIRotationGestureRecognizer?

    private func addGestures(v: UIView) {

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapProcess(_:)))
        v.addGestureRecognizer(tapGesture!)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panProcess(_:)))
        v.isUserInteractionEnabled = true
        panGesture?.delegate = self     // for simultaneous recog
        v.addGestureRecognizer(panGesture!)

        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchProcess(_:)))
        //view.isUserInteractionEnabled = true
        pinchGesture?.delegate = self   // for simultaneous recog
        v.addGestureRecognizer(pinchGesture!)

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

        if let v = gestgureView  {
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
        //self.flCreator.selectedView = iView
        //self.controlView?.updateFrame(iView.frame)
        self.controlView?.transform = iView.transform
        self.controlView?.bounds = iView.bounds
        self.controlView?.center = iView.center
    }

    // location will jump when finger number change
    private var initPanFingerNumber:Int = 1
    private var isPanFingerNumberChangedInThisSession = false
    private var lastPanPoint:CGPoint = CGPoint(x: 0, y: 0)
    @objc func panProcess(_ recognizer:UIPanGestureRecognizer) {
        if isGestureEnabled {
            //guard let view = recognizer.view else { return }
            guard let view = self.weakTransformView else { return }

            // init
            if recognizer.state == .began {
                lastPanPoint = recognizer.location(in: view)
                initPanFingerNumber = recognizer.numberOfTouches
                isPanFingerNumberChangedInThisSession = false
            }

            // judge valid
            if recognizer.numberOfTouches != initPanFingerNumber {
                isPanFingerNumberChangedInThisSession = true
            }
            if isPanFingerNumberChangedInThisSession {
                return
            }

            // perform change
            let point = recognizer.location(in: view)
            view.transform = view.transform.translatedBy(x: point.x - lastPanPoint.x, y: point.y - lastPanPoint.y)
            self.controlView?.transform = view.transform
            self.controlView?.bounds = view.bounds
            self.controlView?.center = view.center
            lastPanPoint = recognizer.location(in: view)
        }
    }



    private var lastScale:CGFloat = 1.0
    private var lastPinchPoint:CGPoint = CGPoint(x: 0, y: 0)
    @objc func pinchProcess(_ recognizer:UIPinchGestureRecognizer) {
        if isGestureEnabled {
            guard let view = self.weakTransformView else { return }

            // init
            if recognizer.state == .began {
                lastScale = 1.0;
                lastPinchPoint = recognizer.location(in: view)
            }

            // judge valid
            if recognizer.numberOfTouches < 2 {
                lastPinchPoint = recognizer.location(in: view)
                return
            }

            // Scale
            let scale = 1.0 - (lastScale - recognizer.scale);
            view.transform = view.transform.scaledBy(x: scale, y: scale)
            lastScale = recognizer.scale;

            // Translate
            let point = recognizer.location(in: view)
            view.transform = view.transform.translatedBy(x: point.x - lastPinchPoint.x, y: point.y - lastPinchPoint.y)
            self.controlView?.transform = view.transform
            self.controlView?.bounds = view.bounds
            self.controlView?.center = view.center
            lastPinchPoint = recognizer.location(in: view)
        }
    }


    @objc func rotationProcess(_ recognizer: UIRotationGestureRecognizer) {
        if isGestureEnabled {
            guard let view = self.weakTransformView else { return }

            view.transform = view.transform.rotated(by: recognizer.rotation)
            self.controlView?.transform = view.transform
            self.controlView?.bounds = view.bounds
            self.controlView?.center = view.center
            recognizer.rotation = 0
        }
    }


    //MARK:- UIGestureRecognizerDelegate Methods
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }

}
