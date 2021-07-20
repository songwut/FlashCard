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
    var tool: FLTool = .text
    var alignment: FLTextAlignment = .center
    var textStyle: FLTextStyle?
}

class InteractView: UIView {
    
    var styles = [FLTextStyle]()
    var alignment: FLTextAlignment?
    var textColor: String?
    
    var isCreateNew = true
    var isProcessing = false
    var imageView:UIImageView?
    var element:TextElement?
    
    var rotation: Float = 0 {
        didSet {
            print("update rotation: \(self.rotation)")
        }
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

class FLStageView: UIView {
    var page: FlashPage? {
        didSet {
            print("FLStageView frame: \(self.frame)")
        }
    }
}

class FlashPage {
    var id = 0
    var image = ""//cover
    var bgColor = "FFFFFF"
    var componentList = [FlashElement]()
    
}

enum FLTextStyle: String {
    case regular = "regular"
    case bold = "bold"
    case italic = "italic"
    case underline = "underline"
    
    func iconName() -> String {
        switch self {
        case .bold:
            return "ic_text_bold"
        case .italic:
            return "ic_text_Italic"
        case .underline:
            return "ic_text_underline"
        default:
            return ""
        }
    }
    
    //UIFont.w
}

enum FLTextAlignment: String {
    case left = "left"
    case center = "center"
    case right = "right"
    case justified = "justified"
    case natural = "natural"
    
    func alignment() -> NSTextAlignment {
        switch self {
        case .left:
            return .left
        case .center:
            return .center
        case .right:
            return .right
        case .justified:
            return .justified
        default:
            return .center
        }
    }
    
    func iconName() -> String {
        switch self {
        case .left:
            return "ic_text_left"
        case .center:
            return "ic_text_center"
        case .right:
            return "ic_text_right"
        case .justified:
            return "ic_text_justified"
        default:
            return ""
        }
    }
}

class FlashElement {
    var rotation:Float?
    var scale:Float = 1.0//default
    
}

class TextElement: FlashElement {
    
    var text = ""
    var textColor = "#000000"
    var fill:String?
    var x:CGFloat = 50
    var y:CGFloat = 50
    var fontSize:CGFloat = 36
    var width:CGFloat = 0
    var flAlignment = FLTextAlignment.center
    
    var widthPT:CGFloat?
    
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
