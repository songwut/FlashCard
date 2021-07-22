//
//  FLCreator.swift
//  flash
//
//  Created by Songwut Maneefun on 17/6/2564 BE.
//

import UIKit
import SVGKit
import AVKit

extension UIImageView {
    func downloadedsvg(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let receivedicon: SVGKImage = SVGKImage(data: data),
                let image = receivedicon.uiImage
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}


struct FLCreator {
    
    var selectedView: InteractView?
    var stageView: UIView!
    
    var stageRatio:CGFloat = 1//use for scale TextElement
    
    init(stage: UIView) {
        self.stageView = stage
    }
    
    func manageFont(element:TextElement) -> UIFont {
        let isItalic = element.flTextStyle.contains(.italic)
        var font = FontHelper.getFontSystem(element.fontSize, font: .text, isItalic: isItalic)
        if element.flTextStyle.contains(.bold) {
            font = FontHelper.getFontSystem(element.fontSize, font: .bold, isItalic: isItalic)
        }
        return font
    }
    
    func createText(_ element:TextElement ,in stage: UIView) -> InteractView {
        let viewX = (stage.frame.width * element.x / 100)
        let viewY = ((stage.frame.height * element.y) / 100)
        var viewW = ((stage.frame.width * element.width) / 100)
        var viewH = ((stage.frame.height * element.width) / 100)
        
        let iView = InteractView()
        iView.type = .text
        let font:UIFont = self.manageFont(element: element)
        
        let scale = (element.scale + Float(self.stageRatio)) - 1.0
        
        let textView = FLTextView()
        textView.text = element.text
        textView.textAlignment = element.flAlignment.alignment()
        textView.textColor = UIColor(element.textColor)
        textView.font = font
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        var atb: [NSAttributedString.Key:Any] = [
            .font: font,
            .foregroundColor: textView.textColor ?? .black,
            .paragraphStyle: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = 0
                return paragraph
            }()
        ]
        if element.flTextStyle.contains(.underline) {
            atb[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        let atbString =  NSMutableAttributedString(string: textView.text , attributes: atb)
        textView.attributedText = atbString
        textView.textAlignment = element.flAlignment.alignment()
        
        let margin = FlashStyle.text.marginIView
        let marginXY = margin / 2
        
        if element.width == 0, element.width == 0 {//case create new
            let textViewFrame = textView.frameFromContent()
            //let fixWidth:CGFloat = 40//plus for digit missing
            //viewW = (FlashStyle.text.textWidthFromFont36 * CGFloat(scale)) + fixWidth
            viewW = textViewFrame.width + margin
            viewH = textViewFrame.height + margin
        }
        
        
        let selfFrame = iView.frame
        iView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: viewW, height: viewW))
        
        //textView.translatesAutoresizingMaskIntoConstraints = false
        iView.view = textView
        textView.frame = CGRect(x: marginXY, y: marginXY, width: viewW - margin, height: viewH - margin)
        textView.textColor = UIColor(element.textColor)
        if let fill = element.fill {
            textView.backgroundColor = UIColor(fill)
        } else {
            textView.backgroundColor = .clear
        }
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
        
        iView.frame = frame
        iView.center = center
        iView.textView = textView
        iView.element = element
        iView.scale = (scale == 1.0) ? 1.0 : scale
        iView.update(scale: scale)
        iView.update(rotation: element.rotation)
        stage.addSubview(iView)
        return iView
    }
    
    func createImage(_ e: FlashElement ,in stage: UIView) -> InteractView? {
        guard let element = e as? ImageElement else { return nil }
        let viewX = (stage.frame.width * element.x / 100)
        let viewY = ((stage.frame.height * element.y) / 100)
        let viewW = ((stage.frame.width * element.width) / 100)
        let viewH = ((stage.frame.height * element.height) / 100)
        
        var size = CGSize(width: viewW, height: viewH)
        if let rawSize = e.rawSize {
            let ratio = rawSize.height / rawSize.width
            let w = stage.frame.width * 0.8//80% of stage
            let h = w * ratio//height by ratio
            size = CGSize(width: w, height: h)
        }
        
        let margin = FlashStyle.text.marginIView
        let marginXY = margin / 2
        let imageviewFrame = CGRect(x: marginXY, y: marginXY, width: size.width - margin, height: size.height - margin)
        
        let imageview = UIImageView()
        imageview.frame = imageviewFrame
        
        if let image = element.image {
            imageview.image = image
            
        } else if let imgSrc = element.src {
            imageview.imageFromUrl(imgSrc)
        }
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(origin: CGPoint.zero, size: size)
        let iView = InteractView()
        iView.type = .image
        iView.frame = frame
        iView.center = center
        iView.view = imageview
        iView.update(rotation: element.rotation)
        stage.addSubview(iView)
        return iView
    }
    
    func createVideo(_ element: VideoElement ,in stage: UIView) -> InteractView {
        let viewX = (stage.frame.width * element.x / 100)
        let viewY = ((stage.frame.height * element.y) / 100)
        let viewW = ((stage.frame.width * element.width) / 100)
        let viewH = ((stage.frame.height * element.height) / 100)
        let playerViewFrame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
        
        var playerLayer: AVPlayerLayer!
        var player: AVPlayer!
        var playerItem: AVPlayerItem!
        
        let playerView = UIView()
        playerView.frame = playerViewFrame
        playerView.backgroundColor = .black
        
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerView.layer.addSublayer(playerLayer)
        
        stage.addSubview(playerView)
        
        if let url = URL(string: element.src) {
            playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            DispatchQueue.main.async {
                playerLayer!.frame = playerView.bounds
            }
            player.play()
        }
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        let iView = InteractView()
        iView.frame = frame
        iView.center = center
        iView.view = playerView
        iView.update(rotation: element.rotation)
        stage.addSubview(iView)
        return iView
    }
    
    func createVector(_ element:VectorElement ,in stage: UIView) -> InteractView {
        let viewX = (stage.frame.width * element.x / 100)
        let viewY = ((stage.frame.height * element.y) / 100)
        let viewW = ((stage.frame.width * element.width) / 100)
        let viewH = ((stage.frame.height * element.height) / 100)
        let imageviewFrame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
        
        let svg = URL(string: "https://openclipart.org/download/181651/manhammock.svg")!
        let data = try? Data(contentsOf: svg)
        let receivedimage: SVGKImage = SVGKImage(data: data)
        let imageview = UIImageView()
        imageview.frame = imageviewFrame
        imageview.image = receivedimage.uiImage
        imageview.backgroundColor = UIColor(element.fill)
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        let iView = InteractView()
        iView.frame = frame
        iView.center = center
        iView.view = imageview
        iView.svgImage = receivedimage
        iView.imageView = imageview
        iView.update(rotation: element.rotation)
        stage.addSubview(iView)
        return iView
    }
    
    func createArrow(_ element: ArrowElement ,in stage: UIView) -> InteractView {
        let viewX = (stage.frame.width * element.x / 100)
        let viewY = ((stage.frame.height * element.y) / 100)
        let viewW = ((stage.frame.width * element.width) / 100)
        let viewH = ((stage.frame.height * element.height) / 100)
        
        let viewFrame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
        
        let view = UIView()
        view.frame = viewFrame
        let start = CGPoint(x: 0, y: viewFrame.height / 2)
        let end = CGPoint(x: viewFrame.width, y: viewFrame.height / 2)
        let strokeWidth = ((stage.frame.width * CGFloat(element.strokeWidth)) / 100)
        self.drawArrow(start: start, end: end, lineWidth: strokeWidth, in: view)
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        let iView = InteractView()
        iView.frame = frame
        iView.center = center
        iView.view = view
        iView.update(rotation: element.rotation)
        stage.addSubview(iView)
        return iView
    }
    
    func drawArrow(start:CGPoint, end:CGPoint, lineWidth:CGFloat, in view:UIView) {
        let arrow = UIBezierPath()
        arrow.addArrow(start: start, end: end, pointerLineLength: 30, arrowAngle: CGFloat(Double.pi / 4))
        let arrowLayer = CAShapeLayer()
        arrowLayer.strokeColor = UIColor.black.cgColor
        arrowLayer.lineWidth = lineWidth
        arrowLayer.path = arrow.cgPath
        arrowLayer.fillColor = UIColor.clear.cgColor
        arrowLayer.lineJoin = CAShapeLayerLineJoin.round
        arrowLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(arrowLayer)
    }
}
