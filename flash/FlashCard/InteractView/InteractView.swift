//
//  InteractView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/7/2564 BE.
//

import UIKit
import SVGKit

enum FLType: String {
    case unknow = ""
    case text = "text"
    case image = "image"
    case video = "video"
    case shape = "shape"
    case sticker = "sticker"
}

class InteractView: UIView {
    
    var textColor: String?
    
    var isCreateNew = true
    var imageView:UIImageView?
    var element:TextElement?
    var type: FLType = .unknow
    var gesture: SnapGesture?
    
    var controlBgView: UIView!
    
    var removeButton: UIButton?
    var scaleLeftButton: UIButton?
    var scaleRightButton: UIButton?
    
    var topLeftButton: UIButton?
    var bottomLeftButton: UIButton?
    var bottomRightButton: UIButton?
    
    var rotation: Float = 0 {
        didSet {
            print("update rotation: \(self.rotation)")
        }
    }
    
    func update(controlView:FLControlView) {
        self.controlBgView.addSubview(controlView)
        controlView.bounds = CGRect(origin: .zero, size: self.bounds.size)
        controlView.isHidden = false
        let isText = self.type == .text
        controlView.leftWidthButton.isHidden = !isText
        controlView.rightWidthButton.isHidden = !isText
    }
    
    func update(rotation:Float?) {
        if let r = rotation {
            self.rotation = r
            let rAngle = CGFloat(r)
            self.transform = CGAffineTransform(rotationAngle: rAngle)
        }
    }
    
    var scale: Float = 0 {
        didSet {
            print("update scale: \(self.scale)")
        }
    }
    
    func update(scale: Float) {
        self.scale = scale
        self.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
    }
    
    var isSelected: Bool = false {
        didSet {
            //self.layer.borderWidth = self.isSelected ? 1 : 0
            //.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    var textView: UITextView?
    
    var svgImage: SVGKImage?
    
    func updateVector(_ svgImage:SVGKImage?) {
        self.imageView?.image = svgImage?.uiImage
    }
    
    var view: UIView? {
        didSet {
            guard let view = self.view else { return }
            self.insertSubview(view, belowSubview: self.controlBgView)
            addBehavior()
        }
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        self.layoutIfNeeded()
        addBehavior()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func addBehavior() {
        self.isUserInteractionEnabled = true
        if self.controlBgView == nil {
            self.controlBgView = UIView()
            self.addSubview(self.controlBgView)
        }
        self.controlBgView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
    }
}

extension InteractView {
    
    var currentScale: CGPoint {
        let a = transform.a
        let b = transform.b
        let c = transform.c
        let d = transform.d

        let sx = sqrt(a * a + b * b)
        let sy = sqrt(c * c + d * d)

        return CGPoint(x: sx, y: sy)
    }
    
    func enableZoom() {
      let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
      isUserInteractionEnabled = true
      addGestureRecognizer(pinchGesture)
    }
    
    @objc private func startZooming(_ gesture: UIPinchGestureRecognizer) {
        print("x:\(gesture.scale)")
        print("y:\(gesture.scale)")
        guard let view = gesture.view as? InteractView else { return }
        let scale = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        view.transform = scale
        gesture.scale = 1
        
        //limit scale
        if scale.a > 1, scale.d > 1 {
            
        }
    }
}
