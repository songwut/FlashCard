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
    
    var screenRatio:CGFloat = 1
    
    init(stage: UIView) {
        self.screenRatio = self.calRatio(ref: stage.frame.width)
    }
    
    func calRatio(ref:CGFloat) -> CGFloat {
        //screen ratio
        return ref / FlashStyle.baseWidth
    }
    
    func createText(_ element:TextElement ,in stage: UIView) -> InteractView {
        let viewX = (stage.frame.width * element.x / 100)
        let viewY = ((stage.frame.height * element.y) / 100)
        let viewW = ((stage.frame.width * element.width) / 100)
        //let viewH = ((stage.frame.height * element.height) / 100)
        let fontSize:CGFloat = element.fontSize// ((stage.frame.width * element.fontSize) / 100)
        
        let textView = FLTextView()
        textView.text = element.text
        //label.textAlignment = //No
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: fontSize, weight: .regular)
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //case no height
        let viewH = textView.systemLayoutSizeFitting(CGSize(width: viewW, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        textView.frame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
        textView.textColor = UIColor(element.textColor)
        if let fill = element.fill {
            textView.backgroundColor = UIColor(fill)
        } else {
            textView.backgroundColor = .clear
        }
        
        let center = CGPoint(x: viewX, y: viewX)
        let frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        let iView = InteractView()
        iView.frame = frame
        iView.center = center
        iView.textView = textView
        iView.view = textView
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
    
    func createImage(_ element: ImageElement ,in stage: UIView) -> InteractView {
        let viewX = (stage.frame.width * element.x / 100)
        let viewY = ((stage.frame.height * element.y) / 100)
        let viewW = ((stage.frame.width * element.width) / 100)
        let viewH = ((stage.frame.height * element.height) / 100)
        let imageviewFrame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
        
        let image = UIImage(named: "monstera")
        let imageview = UIImageView()
        imageview.frame = imageviewFrame
        imageview.image = image
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        let iView = InteractView()
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
