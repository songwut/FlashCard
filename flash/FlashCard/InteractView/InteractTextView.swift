//
//  InteractTextView.swift
//  flash
//
//  Created by Songwut Maneefun on 16/7/2564 BE.
//

import UIKit

@objc protocol InteractTextViewDelegate {
    @objc optional func interacTextViewDidBeginMoving(view: InteractTextView)
    @objc optional func interacTextViewDidChangeMoving(view: InteractTextView)
    @objc optional func interacTextViewDidEndMoving(view: InteractTextView)
    @objc optional func interacTextViewDidBeginRotating(view: InteractTextView)
    @objc optional func interacTextViewDidChangeRotating(view: InteractTextView)
    @objc optional func interacTextViewDidEndRotating(view: InteractTextView)
    @objc optional func interacTextViewDidClose(view: InteractTextView)
    @objc optional func interacTextViewDidTap(view: InteractTextView)
}


class InteractTextView: UIView {
    var isSelectAll = false
    var flColorText: FLColorResult? {
        didSet {
            guard let flColor = self.flColorText else { return }
            self.element?.textColor = flColor.hex
            self.textView?.textColor = UIColor(flColor.hex)
        }
    }
    var element: FlashElement?
    var type: FLType = .unknow
    var rotation: Float = 0 {
        didSet {
            print("update rotation: \(self.rotation)")
        }
    }
    @IBOutlet weak var textView: FLTextView!
    var delegate: InteractTextViewDelegate?
    private let controlWidthIcon = UIImage(named: "controll_width")
    private let frameIcon = UIImage(named: "ic-fl-frame")
    var defaultInset: Int = Int(FlashStyle.text.marginIView / 2)
    var defaultMinimumSize: Int = 4 * Int(FlashStyle.text.marginIView / 2)
    var minimumSize = 0
    var angle: CGFloat = 0
    var contentFixWidth: CGFloat?
    var outlineBorderColor: UIColor = .clear {
        didSet {
            self.contentView.layer.borderColor = self.outlineBorderColor.cgColor
        }
    }
    /*
    func setContentView(_ view: UIView!) {//use next phase
        if let textView = view as? FLTextView {
            self.contentView = textView
        } else if let v = view as? UIView {
            self.contentView = v
            self.textView.removeFromSuperview()
        }
    }
    */
    var contentView: UIView {
        get {
            return self.textView
        }
        set {
            guard let textView = newValue as? FLTextView else { return }
            self.textView = textView
        }
    }
    
    func update(rotation: Double?) {
        if let r = rotation {
            self.rotation = Float(r)
            let rAngle = CGFloat(r)
            self.transform = CGAffineTransform(rotationAngle: rAngle)
        }
    }
    
    var beginningPoint: CGPoint = .zero
    var beginningCenter: CGPoint = .zero
    
    var scale: Float = 0 {
        didSet {
            print("update scale: \(self.scale)")
        }
    }
    
    func update(scale: Float) {
        self.scale = scale
        self.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
    }
    
    @objc func handleCloseGesture(recognizer: UITapGestureRecognizer) {
        self.delegate?.interacTextViewDidClose?(view: self)
    }
    
    var isEnableNone = false{
        didSet {
            self.rotateImageView.isUserInteractionEnabled = isEnableNone
        }
    }
    
    var isEnableRotate = false{
        didSet {
            self.rotateImageView.isUserInteractionEnabled = isEnableRotate
        }
    }
    
    var isenableFlip = false {
        didSet {
            self.flipImageView.isUserInteractionEnabled = isenableFlip
        }
    }
    
    var isEnableClose = false {
        didSet {
            self.closeImageView.isUserInteractionEnabled = isEnableClose
        }
    }
    
    lazy var pinchGesture: PinchGesture = {
        let pinchGesture = PinchGesture(target: self, action: #selector(handlePinchGesture))
        //tapGesture.delegate = self
        return pinchGesture
    }()
    
    lazy var tapGesture: TapGesture = {
        let tapGesture = TapGesture(target: self, action: #selector(handleTapGesture))
        //tapGesture.delegate = self
        return tapGesture
    }()
    
    lazy var moveGesture: PanGesture = {
        let tapGesture = PanGesture(target: self, action: #selector(handleMoveGesture))
        //tapGesture.delegate = self
        return tapGesture
    }()
    
    lazy var closeGesture: TapGesture = {
        let tapGesture = TapGesture(target: self, action: #selector(handleCloseGesture))
        //tapGesture.delegate = self
        return tapGesture
    }()
    
    lazy var rotateFrameGesture: PanGesture = {
        let panGesture = PanGesture(target: self, action: #selector(handleRotateFrameGesture))
        //tapGesture.delegate = self
        return panGesture
    }()
    
    lazy var closeImageView: FLControlIcon = {
        let width = FlashStyle.text.marginIView
        let icon  = FLControlIcon(frame: CGRect(x: 0, y: 0, width: width, height: width))
        icon.image = frameIcon
        icon.contentMode = .center
        icon.backgroundColor = .clear
        icon.isUserInteractionEnabled = true
        icon.addGestureRecognizer(closeGesture)
        return icon
    }()
    
    lazy var noneImageView: FLControlIcon = {
        let width = FlashStyle.text.marginIView
        let icon  = FLControlIcon(frame: CGRect(x: 0, y: 0, width: width, height: width))
        icon.image = frameIcon
        icon.contentMode = .center
        icon.backgroundColor = .clear
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    lazy var flipImageView: FLControlIcon = {
        let width = FlashStyle.text.marginIView
        let icon  = FLControlIcon(frame: CGRect(x: 0, y: 0, width: width, height: width))
        icon.image = frameIcon
        icon.contentMode = .center
        icon.backgroundColor = .clear
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    lazy var rotateImageView: FLControlIcon = {
        let width = FlashStyle.text.marginIView
        let icon  = FLControlIcon(frame: CGRect(x: 0, y: 0, width: width, height: width))
        icon.image = frameIcon
        icon.contentMode = .center
        icon.backgroundColor = .clear
        icon.isUserInteractionEnabled = true
        icon.addGestureRecognizer(self.rotateFrameGesture)
        return icon
    }()
    
    lazy var controlTextLeft: FLControlIcon = {
        let width = FlashStyle.text.marginIView
        let icon  = FLControlIcon(frame: CGRect(x: 0, y: 0, width: width, height: 60))
        icon.image = controlWidthIcon
        icon.contentMode = .center
        icon.backgroundColor = .clear
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    lazy var controlTextRight: FLControlIcon = {
        let width = FlashStyle.text.marginIView
        let icon  = FLControlIcon(frame: CGRect(x: 0, y: 0, width: width, height: 60))
        icon.image = controlWidthIcon
        icon.contentMode = .center
        icon.backgroundColor = .clear
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    var isHiddenEditingTool: Bool = false {
        didSet {
            self.noneImageView.isHidden = self.isHiddenEditingTool
            self.closeImageView.isHidden = self.isHiddenEditingTool
            self.flipImageView.isHidden = self.isHiddenEditingTool
            self.rotateImageView.isHidden = self.isHiddenEditingTool
            self.controlTextLeft.isHidden = self.isHiddenEditingTool
            self.controlTextRight.isHidden = self.isHiddenEditingTool
            //self.contentView.layer.borderWidth = self.isHiddenEditingTool ? 0 : 2
            self.textView?.layer.borderWidth = self.isHiddenEditingTool ? 0 : 2
        }
    }
    
    func createTextIView() {
        self.addGestureRecognizer(self.moveGesture)
        self.addGestureRecognizer(self.tapGesture)
        self.addGestureRecognizer(self.pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationProcess(_:)))
        //rotationGesture.delegate = self
        self.addGestureRecognizer(rotationGesture)
        
        self.setPosition(.topRight, handler: .close)
        self.setPosition(.bottomRight, handler: .rotate)
        self.setPosition(.bottomLeft, handler: .flip)
        self.setPosition(.topLeft, handler: .none)
        self.setPositionTextControl(view: self.controlTextLeft, position: .midLeft)
        self.setPositionTextControl(view: self.controlTextRight, position: .midRight)
        
        self.addSubview(self.closeImageView)
        self.addSubview(self.rotateImageView)
        self.addSubview(self.flipImageView)
        self.addSubview(self.noneImageView)
        self.addSubview(self.controlTextLeft)
        self.addSubview(self.controlTextRight)

        self.isHiddenEditingTool = false
        self.isEnableClose = true
        self.isEnableRotate = true
        self.isenableFlip = true
        self.isEnableNone = true

        self.minimumSize = defaultMinimumSize;
        self.outlineBorderColor = .black
        
        self.controlTextLeft.image = controlWidthIcon
        self.controlTextRight.image = controlWidthIcon
        
        self.controlTextLeft.addGestureRecognizer(PanGesture(target: self, action: #selector(self.scaleWidthDraging(_:))))
        self.controlTextRight.addGestureRecognizer(PanGesture(target: self, action: #selector(self.scaleWidthDraging(_:))))
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
    var hardScale: CGFloat = 0
    
    var currentScale: CGPoint {
        let a = transform.a
        let b = transform.b
        let c = transform.c
        let d = transform.d
        
        let sx = sqrt(a * a + b * b)
        let sy = sqrt(c * c + d * d)
        
        return CGPoint(x: sx, y: sy)
    }
    
    func setImage(_ image: UIImage?, handler: FLInteractViewHandler) {
        guard let icon = image  else { return }
        
        self.controlTextLeft.image = controlWidthIcon
        self.controlTextRight.image = controlWidthIcon
        
        switch handler {
        case .close:
            self.closeImageView.image = icon
            break
        case .rotate:
            self.rotateImageView.image = icon
            break
        case .flip:
            self.flipImageView.image = icon
            break
        case .none:
            self.noneImageView.image = icon
            break
        }
    }
    
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
            
            self.updateFixWidth(scale: scale, originalBounds: originalBounds)
//            let scaledBounds = CGRectScale(initialBounds, scale, scale)
//
//            self.hardScale = scale
//            self.bounds = CGRect(x: 0, y: 0, width: scaledBounds.width, height: originalBounds.height)
//            self.contentFixWidth = scaledBounds.width - (FlashStyle.text.marginIView / 2)
            //self.setNeedsDisplay()
            break
        default:
            break
        }
    }
    
    func updateFixWidth(scale: CGFloat, originalBounds: CGRect) {
        self.hardScale = scale
        let scaledBounds = CGRectScale(initialBounds, scale, scale)
        self.bounds = CGRect(x: 0, y: 0, width: scaledBounds.width, height: originalBounds.height)
        self.contentFixWidth = scaledBounds.width - (FlashStyle.text.marginIView / 2)
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        print("x:\(gesture.scale)")
        print("y:\(gesture.scale)")
        //let scale = CGAffineTransform(scaleX: self.currentScale.x, y: self.currentScale.y)
        let scale = self.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        
        
        switch gesture.state {
        case .began: break
            
        case .changed:
            self.transform = scale
            gesture.scale = 1
            self.closeImageView.transform = scale.inverted()
            self.flipImageView.transform = scale.inverted()
            self.rotateImageView.transform = scale.inverted()
            self.noneImageView.transform = scale.inverted()
            break
        case .ended:
//            self.closeImageView.transform = .identity
//            self.flipImageView.transform = .identity
//            self.rotateImageView.transform = .identity
//            self.noneImageView.transform = .identity
            
            break
        default:
            break
        }
        //limit scale
        //self.setNeedsDisplay()
        if scale.a > 1, scale.d > 1 {
            
        }
    }
    
    func getDegreesRotation() -> Double {
        let view = self
        let radians:Double = atan2( Double(view.transform.b), Double(view.transform.a))
        let degrees = radians * Double((180 / Float.pi))
        print("degrees: \(degrees)")
        return degrees
    }
    
    private func getRadians(degrees: Double) -> Double {
        let radians = degrees * .pi / 180
        return radians
    }
    
    @objc func handleRotateFrameTextGesture(_ gesture: UIPanGestureRecognizer) {
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
            /*
            let angle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
              
            let angleDiff = Float(deltaAngle) - angle
            self.angle = CGFloat(-angleDiff)
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff))
            */
            var scale = getDistance(center, touchLocation) / initialDistance
            let min:CGFloat = [initialBounds.size.width, initialBounds.size.height].min() ?? 0.0
            let minimumScale = CGFloat(self.minimumSize) / CGFloat(min)
            let max: CGFloat = [scale, minimumScale].max() ?? 0
            scale = max
            
            let scaledBounds = CGRectScale(initialBounds, scale, scale)
            
            self.hardScale = scale
            
            let tScale = CGAffineTransform(scaleX: scale, y: scale)
            self.transform = tScale
            self.closeImageView.transform = tScale.inverted()
            self.flipImageView.transform = tScale.inverted()
            self.rotateImageView.transform = tScale.inverted()
            self.noneImageView.transform = tScale.inverted()
            self.bounds = scaledBounds
            self.setNeedsDisplay()
            break
        case .ended:
            self.closeImageView.transform = .identity
            self.flipImageView.transform = .identity
            self.rotateImageView.transform = .identity
            self.noneImageView.transform = .identity
        default:
            break
        }
    }
    
    @objc func rotationProcess(_ gesture: UIRotationGestureRecognizer) {
            var originalRotation = CGFloat()
            if gesture.state == .began {
                print("sender.rotation: \(gesture.rotation)")
                //gesture.rotation is radians
                //view.rotation is degrees
                let radians = self.getRadians(degrees: Double(self.rotation))
                gesture.rotation = CGFloat(radians)
                originalRotation = gesture.rotation
                
            } else if gesture.state == .changed {
                let scale = CGAffineTransform(scaleX: self.currentScale.x, y: self.currentScale.y)
                let newRotation = gesture.rotation + originalRotation
                self.transform = scale.rotated(by: newRotation)
                
                let degrees = self.getDegreesRotation()
                print("changed degrees: \(degrees)")
                
            } else if gesture.state == .ended {
                // Save the last rotation
                let degrees = self.getDegreesRotation()
                print("ended degrees: \(degrees)")
                self.rotation = Float(degrees)
                gesture.rotation = 0
            }
    }
    
    @objc func rotationProcess1(_ gesture: UIRotationGestureRecognizer) {
        let view = self
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
            self.setPosition(.topRight, handler: .close)
            self.setPosition(.bottomRight, handler: .rotate)
            self.setPosition(.bottomLeft, handler: .flip)
            self.setPosition(.topLeft, handler: .none)
            self.setPositionTextControl(view: self.controlTextLeft, position: .midLeft)
            self.setPositionTextControl(view: self.controlTextRight, position: .midRight)
            let degrees = self.getDegreesRotation()
            print("changed degrees: \(degrees)")
            
        } else if gesture.state == .ended {
            // Save the last rotation
            let degrees = self.getDegreesRotation()
            print("ended degrees: \(degrees)")
            view.rotation = Float(degrees)
            gesture.rotation = 0
        }
    }
    
    //rotationProcess use for TextView zoom/scale look good
    //handleRotateFrameGesture not work for font scale
    @objc func handleRotateFrameGesture(_ gesture: UIPanGestureRecognizer) {
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
            /*
            let angle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
              
            let angleDiff = Float(deltaAngle) - angle
            self.angle = CGFloat(-angleDiff)
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff))
            */
            var scale = getDistance(center, touchLocation) / initialDistance
            let min:CGFloat = [initialBounds.size.width, initialBounds.size.height].min() ?? 0.0
            let minimumScale = CGFloat(self.minimumSize) / CGFloat(min)
            let max: CGFloat = [scale, minimumScale].max() ?? 0
            scale = max
            
            let scaledBounds = CGRectScale(initialBounds, scale, scale)
            
            self.hardScale = scale
            
            let tScale = CGAffineTransform(scaleX: scale, y: scale)
            self.transform = tScale
            self.closeImageView.transform = tScale.inverted()
            self.flipImageView.transform = tScale.inverted()
            self.rotateImageView.transform = tScale.inverted()
            self.noneImageView.transform = tScale.inverted()
            self.bounds = scaledBounds
            if type != .text {
                self.contentView.bounds = CGRect(origin: .zero, size: scaledBounds.size)
            }
            self.setNeedsDisplay()
            break
        default:
            break
        }
    }
    
    @objc func handleMoveGesture(_ gesture: UIPanGestureRecognizer) {
        let touchLocation = gesture.location(in: self.superview)

        switch gesture.state {
        case .began:
            beginningPoint = touchLocation
            beginningCenter = self.center
            self.delegate?.interacTextViewDidBeginMoving?(view: self)
            break

        case .changed:
            self.center = CGPoint(x: beginningCenter.x + (touchLocation.x - beginningPoint.x),
                                  y: beginningCenter.y + (touchLocation.y - beginningPoint.y));
            self.delegate?.interacTextViewDidChangeMoving?(view: self)
            break

        case .ended:
            self.center = CGPoint(x: beginningCenter.x + (touchLocation.x - beginningPoint.x),
                                  y: beginningCenter.y + (touchLocation.y - beginningPoint.y));

            self.delegate?.interacTextViewDidEndMoving?(view: self)
            break

          default:
            break
        }
    }
    
    @objc func handleTapGesture(_ gesture: UIPanGestureRecognizer) {
        self.delegate?.interacTextViewDidTap?(view: self)
    }

    
    func setPosition(_ position: FLInteractViewPosition, handler: FLInteractViewHandler) {
        let origin = contentView.frame.origin
        let size = contentView.frame.size
        var handlerView: FLControlIcon
        switch handler {
        case .close:
            handlerView = self.closeImageView
            break
            
        case .rotate:
            handlerView = self.rotateImageView
            break
            
        case .flip:
            handlerView = self.flipImageView
            break
        case .none:
            handlerView = self.noneImageView
        }
        
        handlerView.translatesAutoresizingMaskIntoConstraints = true
        
        switch position {
        case .topLeft:
            handlerView.center = origin
            handlerView.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
            break
            
        case .topRight:
            handlerView.center = CGPoint(x: origin.x + size.width, y: origin.y)
            handlerView.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
            break
            
        case .bottomLeft:
            handlerView.center = CGPoint(x: origin.x, y: origin.y + size.height)
            handlerView.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
            break
            
        case .bottomRight:
            handlerView.center = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
            handlerView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
            break
            
        case .midLeft:
            handlerView.center = CGPoint(x: origin.x, y: origin.y + (size.height / 2))
            handlerView.autoresizingMask = [.flexibleRightMargin , .flexibleBottomMargin, .flexibleTopMargin]
            break
        case .midRight:
            handlerView.center = CGPoint(x: origin.x + size.width, y: origin.y + (size.height / 2))
            handlerView.autoresizingMask = [.flexibleLeftMargin , .flexibleBottomMargin, .flexibleTopMargin]
            break
        
        }
        
        handlerView.position = position
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
        
        view.position = position
    }
    
    func unSelectTextView() {
        if let textView = self.textView {
            if let _ = textView.selectedTextRange {
                textView.selectedTextRange = nil
            }
        }
    }
    
    func setHandlerSize(_ size: Int) {
        if (size <= 0) {
            return
        }
        defaultInset = Int(size / 2)
        defaultMinimumSize = 4 * defaultInset
        self.minimumSize = [self.minimumSize, defaultMinimumSize].max() ?? 0
        
        
        let originalTransform = self.transform
        var frame = contentView.frame
        frame = CGRect(x: 0, y: 0, width: Int(frame.size.width) + defaultInset * 2, height: Int(frame.size.height) + defaultInset * 2);
        
        if self.type != .text {
            self.contentView.removeFromSuperview()
            
            self.transform = .identity
            self.frame = frame
            
            contentView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            addSubview(contentView)
            self.sendSubviewToBack(contentView)
        }
        
        
        let handlerFrame = CGRect(x: 0, y: 0, width: defaultInset * 2, height: defaultInset * 2);
        self.closeImageView.frame = handlerFrame
        self.setPosition(self.closeImageView.position, handler: .close)
        self.rotateImageView.frame = handlerFrame
        self.setPosition(self.rotateImageView.position, handler: .rotate)
        self.flipImageView.frame = handlerFrame
        self.setPosition(self.flipImageView.position, handler: .flip)
        self.noneImageView.frame = handlerFrame
        self.setPosition(self.noneImageView.position, handler: .none)
        
        self.setPositionTextControl(view: self.controlTextLeft, position: .midLeft)
        self.setPositionTextControl(view: self.controlTextRight, position: .midRight)
        self.controlTextLeft.image = controlWidthIcon
        self.controlTextRight.image = controlWidthIcon
        
        self.transform = originalTransform
    }
    
    override func awakeFromNib() {
    }
    
    class func instanciateFromNib() -> InteractTextView {
        return Bundle.main.loadNibNamed("InteractTextView", owner: nil, options: nil)![0] as! InteractTextView
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
            if let imageSrc = element.src { //TODO: set after upload api
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
            if let videoSrc = element.src {
                dict["src"] = videoSrc as AnyObject
            }
        } else if element.type == .text {
            if let textDict = element.createTextJSON() {
                for (key, value) in textDict { //TODO: ถาม ตูน format text style,aliment
                    dict[key] = value
                }
            }
            
        }
        
        return dict
    }

}


