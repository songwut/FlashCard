//
//  Models.swift
//  flash
//
//  Created by Songwut Maneefun on 17/6/2564 BE.
//

import UIKit
import SVGKit

open class DidAction {
    var handler: ((_ sender: Any?) -> Void)!
    
    init(handler: @escaping ((_ sender: Any?) -> Void)) {
        self.handler = handler
    }
 
    
}

class FLButton: UIButton {
    
}

class InteractView: UIView {
    
    var isProcessing = false
    var imageView:UIImageView?
    var rotation: Float = 0 {
        didSet {
            print("update rotation: \(self.rotation)")
        }
    }
    var scale: Float = 0 {
        didSet {
            print("update rotation: \(self.scale)")
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            self.layer.borderWidth = self.isSelected ? 1 : 0
            self.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    var textView: UITextView? {
        didSet {
            self.textView?.delegate = self
        }
    }
    
    var svgImage: SVGKImage?
    
    func updateVector(_ svgImage:SVGKImage?) {
        self.imageView?.image = svgImage?.uiImage
    }
    
    func update(rotation:Float?) {
        if let r = rotation {
            self.rotation = r
            let rAngle = CGFloat(r)
            self.transform = CGAffineTransform(rotationAngle: rAngle)
        }
    }
    
    var view: UIView? {
        didSet {
            guard let view = self.view else { return }
            self.addSubview(view)
        }
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
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
            print("Add all the behavior here")
        }
}

extension InteractView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let isSelected = !self.isSelected
        self.isSelected = isSelected
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let f = textView.frame
        let viewH = textView.systemLayoutSizeFitting(CGSize(width: f.width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        textView.frame = CGRect(x: 0, y: 0, width: f.width, height: viewH)
        
        let selfFrame = self.frame
        self.frame = CGRect(x: selfFrame.origin.x, y: selfFrame.origin.y, width: selfFrame.width, height: viewH)
    }
}

extension InteractView {
    
    func enableZoom() {
      let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
      isUserInteractionEnabled = true
      addGestureRecognizer(pinchGesture)
    }
    
    @objc private func startZooming(_ gesture: UIPinchGestureRecognizer) {
        print("x:\(gesture.scale)")
        print("y:\(gesture.scale)")
        guard let view = gesture.view as? InteractView else { return }
        view.scale = Float(gesture.scale)
        let scale = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        if scale.a > 1, scale.d > 1 {
            view.transform = scale
            gesture.scale = 1
            if !self.isProcessing {
                self.isProcessing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let svgImage = view.svgImage {
                        if let imageView = view.imageView {
                            view.updateVector(svgImage)
                            self.isProcessing = false
                        }
                    }
                }
            }
            
            
        }
        
        if gesture.state == .began {
            
        } else if gesture.state == .recognized {
            //gesture.scale = 1
        } else if gesture.state == .ended {
            
            
        }
    
    }
}

class FlashElement {
    var rotation:Float?
    var scale:Float = 1.0//default
    
}

class TextElement: FlashElement {
    var text = "font with orange color and Italic 🧚"
    var textColor = "#005733"
    var fill:String? = "#FF5733"
    var x:CGFloat = 50
    var y:CGFloat = 50
    var fontSize:CGFloat = 36
    var width:CGFloat = 80
    
    override init() {
        super.init()
        //self.rotation = 1.69
    }
}

class ImageElement: FlashElement {
    var src = ""
    var textColor = "#005733"
    var fill:String?
    var x:CGFloat = 60
    var y:CGFloat = 10
    var width:CGFloat = 30
    var height:CGFloat = 20
    
    override init() {
        super.init()
        self.rotation = 45
    }
}

class VectorElement: FlashElement {
    var src = "https://openclipart.org/download/181651/manhammock.svg"
    var textColor = "#005733"
    var fill = "#8888EE"
    var x:CGFloat = 70
    var y:CGFloat = 70
    var width:CGFloat = 40
    var height:CGFloat = 20
    
    override init() {
        
    }
}

class VideoElement: FlashElement {
    //https://test-videos.co.uk/bigbuckbunny/mp4-h264
    var src = "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4"
    var textColor = "#005733"
    var fill = "#8888EE"
    var x:CGFloat = 50
    var y:CGFloat = 80
    var width:CGFloat = 80
    var height:CGFloat = 30
    
    override init() {
        
    }
}

class ArrowElement: FlashElement {
    var textColor = "#005733"
    var stroke = "#000000"
    var strokeWidth:Float = 1
    var fill = "#8888EE"
    var x:CGFloat = 2
    var y:CGFloat = 50
    var width:CGFloat = 80
    var height:CGFloat = 2
    
    override init() {
        
    }
}
