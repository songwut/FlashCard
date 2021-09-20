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
    case close
    case rotate
    case flip
}

enum FLInteractViewPosition: Int {
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
    var position: FLInteractViewPosition = .topRight
}

class FLPlaverView: UIView {
    
}

struct FLPlayerCreator {
    //for media
    var mediaUrl: URL
    var playerViewFrame: CGRect
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    mutating func createPlayerView(_ url: URL) -> FLPlaverView {
        
        let playerView = FLPlaverView()
        playerView.frame = playerViewFrame
        playerView.backgroundColor = .black
        
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: self.player!)
        playerView.layer.addSublayer(playerLayer!)
        
        playerItem = AVPlayerItem(url: mediaUrl)
        player?.replaceCurrentItem(with: playerItem)
        self.playerLayer?.frame = playerView.bounds
        player?.play()
        
        return playerView
    }
}

class InteractView: CHTStickerView {
    //var delegate: InteractViewDelegate?
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
    
    var playerCreator: FLPlayerCreator?
    
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
            self.setPosition(position: .topRight, handler: .close)
            self.setPosition(position: .bottomRight, handler: .rotate)
            self.setPosition(position: .bottomLeft, handler: .flip)
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
    
    var defaultInset: Int = 11
    var defaultMinimumSize: Int = 4 * 11
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

extension InteractView1 {
    
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
    
    func setIcon(_ image: UIImage?, handler: FLInteractViewHandler) {
        guard let icon = image  else { return }
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
        }
    }
    
    func setPosition(position: FLInteractViewPosition, handler: FLInteractViewHandler) {
        guard let contentView = self.contentView else { return }
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
        }
        
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
        }
        
        handlerView.position = position
    }
    
    
    
    func setHandlerSize(size: Int) {
        if (size <= 0) {
            return
        }
        guard let contentView = self.contentView else { return }
        defaultInset = Int(size / 2)
        defaultMinimumSize = 4 * defaultInset
        self.minimumSize = [self.minimumSize, defaultMinimumSize].max() ?? 0
        
        
        let originalCenter = self.center
        let originalTransform = self.transform
        var frame = contentView.frame
        frame = CGRect(x: 0, y: 0, width: Int(frame.size.width) + defaultInset * 2, height: Int(frame.size.height) + defaultInset * 2);
        
        self.contentView?.removeFromSuperview()
        
        self.transform = .identity
        self.frame = frame
        
        contentView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        addSubview(contentView)
        self.sendSubviewToBack(contentView)
        
        let handlerFrame = CGRect(x: 0, y: 0, width: defaultInset * 2, height: defaultInset * 2);
        self.closeImageView.frame = handlerFrame
        self.setPosition(position: self.closeImageView.position, handler: .close)
        self.rotateImageView.frame = handlerFrame
        self.setPosition(position: self.rotateImageView.position, handler: .rotate)
        self.flipImageView.frame = handlerFrame
        self.setPosition(position: self.flipImageView.position, handler: .flip)
        
        self.center = originalCenter
        self.transform = originalTransform
    }
}
