//
//  InteractView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/7/2564 BE.
//

import UIKit
import SVGKit
import AVKit

enum FLInteractViewHandler: Int {
    case none
    case close
    case rotate
    case flip
}

enum FLInteractViewPosition {
    case midLeft
    case midRight
    
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

@objc protocol InteractViewDelegate {
    @objc optional func interacViewDidBeginMoving(view: InteractView)
    @objc optional func interacViewDidChangeMoving(view: InteractView)
    @objc optional func interacViewDidEndMoving(view: InteractView)
    @objc optional func interacViewDidBeginRotating(view: InteractView)
    @objc optional func interacViewDidChangeRotating(view: InteractView)
    @objc optional func interacViewDidEndRotating(view: InteractView)
    @objc optional func interacViewDidClose(view: InteractView)
    @objc optional func interacViewDidTap(view: InteractView)
}

enum FLType: String {
    case unknow = ""
    case text = "text"
    case image = "image"
    case video = "video"
    case shape = "shape"
    case sticker = "sticker"
    case quiz = "question"
}

class FLControlIcon: UIImageView {
    var position: FLInteractViewPosition = .midLeft
}

class FLPlaverView: UIView {
    var player = AVPlayer()
    var playerItem: AVPlayerItem?
    
    var playerLayer: CALayer?
    var mediaUrl: URL!
    
    func createVideo(url: URL) {
        self.backgroundColor = .black
        mediaUrl = url
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer?.contentsGravity = .resizeAspectFill
        playerLayer?.backgroundColor = UIColor.purple.cgColor
        playerLayer?.frame = self.bounds
        layer.addSublayer(playerLayer!)
        
        playerItem = AVPlayerItem(url: mediaUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func updateUrl(url: URL) {
        mediaUrl = url
        playerItem = AVPlayerItem(url: mediaUrl)
        player.replaceCurrentItem(with: playerItem)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
    }
}

class InteractView: CHTStickerView {
    //var delegate: InteractViewDelegate?
    var textColor: String?
    var contentFixWidth: CGFloat?
    var isCreateNew = true
    var imageView:UIImageView?
    var element: FlashElement?
    var type: FLType = .unknow
    var gesture: SnapGesture?
    
    var removeButton: UIButton?
    var scaleLeftButton: UIButton?
    var scaleRightButton: UIButton?
    
    var topLeftButton: UIButton?
    var bottomLeftButton: UIButton?
    var bottomRightButton: UIButton?
    
    var playerView: FLPlaverView?
    
    var isHiddenEditingTool: Bool = false {
        didSet {
            self.noneImageView.isHidden = self.isHiddenEditingTool
            self.closeImageView.isHidden = self.isHiddenEditingTool
            self.flipImageView.isHidden = self.isHiddenEditingTool
            self.rotateImageView.isHidden = self.isHiddenEditingTool
            self.controlTextLeft.isHidden = self.isHiddenEditingTool
            self.controlTextRight.isHidden = self.isHiddenEditingTool
            self.contentView.layer.borderWidth = self.isHiddenEditingTool ? 0 : 2
        }
    }
    
    private let controlWidthIcon = UIImage(named: "controll_width")
    
    lazy var controlTextLeft: FLControlIcon = {
        let width = FlashStyle.text.marginIView
        let icon  = FLControlIcon(frame: CGRect(x: 0, y: 0, width: width, height: 60))
        icon.image = controlWidthIcon
        icon.contentMode = .center
        icon.backgroundColor = .clear
        icon.isUserInteractionEnabled = true
        //imageView.addGestureRecognizer(self.closeGesture)
        return icon
    }()
    
    lazy var controlTextRight: FLControlIcon = {
        let width = FlashStyle.text.marginIView
        let icon  = FLControlIcon(frame: CGRect(x: 0, y: 0, width: width, height: 60))
        icon.image = controlWidthIcon
        icon.contentMode = .center
        icon.backgroundColor = .clear
        icon.isUserInteractionEnabled = true
        //imageView.addGestureRecognizer(self.closeGesture)
        return icon
    }()
    
    override init!(contentView: UIView!) {
        super.init(contentView: contentView)
        
        if let _ = contentView as? FLTextView {
            self.setPositionTextControl(view: self.controlTextLeft, position: .midLeft)
            self.setPositionTextControl(view: self.controlTextRight, position: .midRight)
            self.controlTextLeft.addGestureRecognizer(PanGesture(target: self, action: #selector(self.scaleWidthDraging(_:))))
            self.controlTextRight.addGestureRecognizer(PanGesture(target: self, action: #selector(self.scaleWidthDraging(_:))))
            self.addSubview(self.controlTextLeft)
            self.addSubview(self.controlTextRight)
        }
        self.isHiddenEditingTool = false
    }
    
    override func setPosition(_ position: CHTStickerViewPosition, for handler: CHTStickerViewHandler) {
        super.setPosition(position, for: handler)
        
        self.setPositionTextControl(view: self.controlTextLeft, position: .midLeft)
        self.setPositionTextControl(view: self.controlTextRight, position: .midRight)
        
        self.controlTextLeft.image = controlWidthIcon
        self.controlTextRight.image = controlWidthIcon
    }
    
    private func getDistance(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
      let fx = CGFloat(point2.x - point1.x)
      let fy = CGFloat(point2.y - point1.y)
      return sqrt((fx * fx + fy * fy))
    }
    
    private func CGAffineTransformGetAngle(_ t: CGAffineTransform) -> CGFloat {
      return atan2(t.b, t.a);
    }
    
    private func CGRectScale(_ rect: CGRect, _ wScale: CGFloat, _ hScale: CGFloat) -> CGRect {
        return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * wScale, height: rect.size.height * hScale);
    }
    
    private var isScaleWidth = false
    var initialBounds = CGRect.zero
    var initialDistance: CGFloat = 0
    var deltaAngle: CGFloat = 0
    
    @objc func scaleWidthDraging(_ gesture: UIPanGestureRecognizer) {
        let touchLocation = gesture.location(in: self.superview)
        let center = self.center
        let originalBounds = self.bounds
        
        switch gesture.state {
        case .began:
            deltaAngle = CGFloat(atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))) - CGAffineTransformGetAngle(self.transform)
            initialBounds = self.bounds
            initialDistance = getDistance(center, touchLocation)
            break
        case .changed:
            var scale = getDistance(center, touchLocation) / initialDistance
            let min:CGFloat = [initialBounds.size.width, initialBounds.size.height].min() ?? 0.0
            let minimumScale = CGFloat(self.minimumSize) / CGFloat(min)
            let max: CGFloat = [scale, minimumScale].max() ?? 0
            scale = max
            
            let scaledBounds = CGRectScale(initialBounds, scale, scale)
            
            self.hardScale = scale
            self.bounds = CGRect(x: 0, y: 0, width: scaledBounds.width, height: originalBounds.height)
            self.contentFixWidth = scaledBounds.width - (FlashStyle.text.marginIView / 2)
            self.setNeedsDisplay()
            break
        default:
            break
        }
        /*
        //scale X
        //textViewDidChange
        var deltaX:CGFloat
        var deltaY:CGFloat
        if button.tag == FLTag.left.rawValue {
            deltaX = location.x - previous.x
            deltaY = location.y - previous.y
        } else {
            deltaX = location.x + previous.x
            deltaY = location.y + previous.y
        }
        print("******")
        print("previous X: \(previous.x) Y:\(previous.y)")
        print("location X: \(location.x) Y:\(location.y)")
        print("deltaX: \(deltaX) Y:\(deltaY)")
        //use only text
        if let iView = self.selectedView, let textView = iView.textView {
            //let textViewFrame = textView.frame
            let iViewFrame = iView.frame
            let deltaXConvert = deltaX * -1
            //scale left+right
            let newWidth = iViewFrame.width + (deltaXConvert * 2)
            
            let newX:CGFloat = iViewFrame.origin.x + deltaX
            let iViewFrameUpdate = CGRect(x: newX, y: iViewFrame.origin.y, width: newWidth, height: iViewFrame.height)
            
            iView.frame = iViewFrameUpdate
            
            print("out iView:\(iView.frame)")
            if !self.isScaleWidth {//for textview fix layout
                self.isScaleWidth = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UIView.animate(withDuration: 0.05, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        textView.frame = CGRect(x: 0, y: 0, width: iViewFrameUpdate.width, height: iViewFrameUpdate.height)
                        //textView.frame = CGRect(x: 0, y: 0, width: iViewFrameUpdate.width, height: iViewFrameUpdate.width)
                        //textView.contentSize.width
                        
                        self.updateTextviewHeight(iView)
                    }, completion: { [weak self] (ended) in
                        self?.isScaleWidth = false
                        let factH = iView.frame.height - textView.frame.height
                        print("factH:\(factH)")
                        print("iView:\(iView.frame)")
                        print("textView:\(textView.frame)")
                        print("contentsize:\(textView.contentSize)")
                    })
                }
                
            }
            //TODO: Do when touches end
            //iView.textView?.contentSize = iViewFrameUpdate.size
            //iView.textView?.frame.size = iViewFrameUpdate.size
            //iView.textView?.textContainer
            //button.center = CGPointMake(button.center.x + delta_x, button.center.y + delta_y);
        }
        */
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPositionTextControl(view: FLControlIcon, position: FLInteractViewPosition) {
        let origin = self.contentView.frame.origin
        let size = self.contentView.frame.size
        
        view.translatesAutoresizingMaskIntoConstraints = true
        
        switch position {
        case .midLeft:
            view.center = CGPoint(x: origin.x, y: origin.y + (size.height / 2))
            view.autoresizingMask = [.flexibleRightMargin , .flexibleBottomMargin, .flexibleTopMargin]
            break
        case .midRight:
            view.center = CGPoint(x: origin.x + size.width, y: origin.y + (size.height / 2))
            view.autoresizingMask = [.flexibleLeftMargin , .flexibleBottomMargin, .flexibleTopMargin]
            break
        default :
            break
        }
    }
    
    func createJSON() -> [String: AnyObject] {
        
        var dict = [String: AnyObject]()
        guard let stage = self.superview as? FLStageView else { return dict }
        guard let element = self.element else { return dict }
        let marginIView = FlashStyle.text.marginIView
        let size = self.bounds.size
        let contentSize = CGSize(width: size.width - marginIView, height: size.height - marginIView)
        let percentWidth = (contentSize.width / stage.bounds.width) * 100
        let percentHeight = (contentSize.height / stage.bounds.height) * 100
        
        let rotationDegree = self.getDegreesRotation()
        let angle = self.angle
        let scale = self.hardScale
        let elementCenter = self.center
        let centerX = (elementCenter.x / stage.bounds.width) * 100
        let centerY = (elementCenter.y / stage.bounds.height) * 100
        let type = element.type.rawValue
        
        dict["width"] = percentWidth as AnyObject
        dict["height"] = percentHeight as AnyObject
        dict["position_x"] = centerX as AnyObject
        dict["position_y"] = centerY as AnyObject
        dict["rotation"] = angle as AnyObject
        dict["scale"] = scale as AnyObject
        dict["type"] = type as AnyObject
        
        if element.type == .image {
            if let imageSrc = element.imageUploaded { //TODO: set after upload api
                dict["src"] = imageSrc as AnyObject
            }
            
        } else if element.type == .sticker {
            if let stickerDict = element.createGraphicJSON() {
                for (key, value) in stickerDict {
                    dict[key] = value
                }
            }
        } else if element.type == .shape {
            if let shapeDict = element.createGraphicJSON() {
                for (key, value) in shapeDict {
                    dict[key] = value
                }
            }
        } else if element.type == .video {
            if let videoSrc = element.mp4VideoUploade { //TODO: set after upload api
                dict["src"] = videoSrc as AnyObject
            }
        } else if element.type == .text {
            if let textDict = element.createTextJSON() {
                for (key, value) in textDict {
                    dict[key] = value
                }
            }
            
        } else if element.type == .quiz {
            let question = element.question
        }
        
        return dict
    }
    
    func getDegreesRotation() -> Double {
        let view = self
        let radians:Double = atan2( Double(view.transform.b), Double(view.transform.a))
        let degrees = radians * Double((180 / Float.pi))
        print("degrees: \(degrees)")
        return degrees
    }
    
    var rotation: Float = 0 {
        didSet {
            print("update rotation: \(self.rotation)")
        }
    }
    
    func update(controlView:FLControlView) {
//        self.controlBgView.addSubview(controlView)
//        controlView.bounds = CGRect(origin: .zero, size: self.bounds.size)
//        controlView.isHidden = false
//        let isText = self.type == .text
//        controlView.leftWidthButton.isHidden = !isText
//        controlView.rightWidthButton.isHidden = !isText
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
    
    func unSelectTextView() {
        if let textView = self.textView {
            if let _ = textView.selectedTextRange {
                textView.selectedTextRange = nil
            }
        }
    }
    
    var svgImage: SVGKImage?
    
    func updateVector(_ svgImage:SVGKImage?) {
        self.imageView?.image = svgImage?.uiImage
    }
    
    var currentScale: CGPoint {
        let a = transform.a
        let b = transform.b
        let c = transform.c
        let d = transform.d
        
        let sx = sqrt(a * a + b * b)
        let sy = sqrt(c * c + d * d)
        
        return CGPoint(x: sx, y: sy)
    }
}

class InteractView1: UIView, UIGestureRecognizerDelegate {
    var delegate: InteractViewDelegate?
    var textColor: String?
    
    var isCreateNew = true
    var imageView:UIImageView?
    var element: FlashElement?
    var type: FLType = .unknow
    var gesture: SnapGesture?
    
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
//        self.controlBgView.addSubview(controlView)
//        controlView.bounds = CGRect(origin: .zero, size: self.bounds.size)
//        controlView.isHidden = false
//        let isText = self.type == .text
//        controlView.leftWidthButton.isHidden = !isText
//        controlView.rightWidthButton.isHidden = !isText
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
    
    var contentView: UIView? {
        didSet {
            guard let contentView = self.contentView else { return }
            
            
            self.isUserInteractionEnabled = true
            self.backgroundColor = .clear
            //[self addGestureRecognizer:self.moveGesture];
            //[self addGestureRecognizer:self.tapGesture];

            // Setup content view
            self.contentView?.center = self.center
            self.contentView?.isUserInteractionEnabled = false
            self.contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.contentView?.layer.allowsEdgeAntialiasing = true
            self.addSubview(contentView)
            
            // Setup editing handlers
//            self.setPosition(position: .topRight, handler: .close)
//            self.setPosition(position: .bottomRight, handler: .rotate)
//            self.setPosition(position: .bottomLeft, handler: .flip)
            self.addSubview(self.closeImageView)
            self.addSubview(self.rotateImageView)
            self.addSubview(self.flipImageView)

            self.showEditingHandlers = true
            self.enableClose = true
            self.enableRotate = true
            self.enableFlip = true

            self.minimumSize = defaultMinimumSize
            self.outlineBorderColor = .black
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
        
//        if self.controlBgView == nil {
//            self.controlBgView = UIView()
//            self.addSubview(self.controlBgView)
//        }
//        self.controlBgView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
    }
    
    var defaultInset: Int = Int(FlashStyle.text.marginIView / 2)
    var defaultMinimumSize: Int = 4 * Int(FlashStyle.text.marginIView / 2)
    var enableRotate = false
    var enableFlip = false
    
    var enableClose = false {
        didSet {
            self.closeImageView.isHidden = !enableClose
            self.closeImageView.isUserInteractionEnabled = enableClose
        }
    }
    
    var showEditingHandlers = false {
        didSet {
            self.enableClose = self.showEditingHandlers
            self.contentView?.layer.borderWidth = self.showEditingHandlers ? 2 : 0
        }
    }
    
    var outlineBorderColor: UIColor = .clear {
        didSet {
            self.contentView?.layer.borderColor = self.outlineBorderColor.cgColor
        }
    }
    
    lazy var closeGesture: UITapGestureRecognizer = {
        let tapGesture = TapGesture(target: self, action: #selector(handleCloseGesture))
        tapGesture.delegate = self
        return tapGesture
    }()
    
    @objc func handleCloseGesture(recognizer: UITapGestureRecognizer) {
        //self.delegate?.interacViewDidClose?(view: self)
        self.removeFromSuperview()
    }
    
    lazy var closeImageView: FLControlIcon = {
        let imageView  = FLControlIcon(frame: CGRect(x: 0, y: 0, width: defaultInset * 2, height: defaultInset * 2))
        imageView.contentMode = .scaleAspectFit;
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(self.closeGesture)
        return imageView
    }()
    
    var rotateImageView = FLControlIcon() //TODO: like close
    var flipImageView = FLControlIcon() //TODO: like close
    var minimumSize: Int = 0//= [self.minimumSize, self.defaultMinimumSize].max() ?? 0
}


