//
//  FLCreator.swift
//  flash
//
//  Created by Songwut Maneefun on 17/6/2564 BE.
//

import UIKit
//import SVGKit
import AVKit
/*
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
*/

struct FLCreator {
    var isEditor = true
    //var stageView: FLStageView!//visual stage
    
    init(isEditor:Bool) {
        self.isEditor = isEditor
    }
    
    func createText(_ element:FlashElement ,in stage: FLStageView) -> InteractTextView {
        let viewX = (stage.frame.width * CGFloat(truncating: element.x) / 100)
        let viewY = ((stage.frame.height * CGFloat(truncating: element.y)) / 100)
        var viewW = ((stage.frame.width * CGFloat(truncating: element.width)) / 100)
        var viewH = ((stage.frame.height * CGFloat(truncating: element.height)) / 100)
        
        let font:UIFont = element.manageFont()
        let scale = (element.scale + Float(stage.stageRatio)) - 1.0
        
        let iView = InteractTextView.instanciateFromNib()
        //iView.setContentView(iView.textView)
        iView.type = element.type
        iView.createTextIView()
        iView.outlineBorderColor = .black
        iView.setImage(UIImage(named: "fl_delete"), handler: .close)
        iView.setImage(UIImage(named: "ic-fl-frame"), handler: .none)
        iView.setImage(UIImage(named: "ic-fl-frame"), handler: .flip)
        iView.setImage(UIImage(named: "ic-fl-frame"), handler: .rotate)
        iView.setHandlerSize(Int(FlashStyle.text.marginIView))
        
        iView.isHiddenEditingTool = !self.isEditor
        iView.isUserInteractionEnabled = self.isEditor
        
        
        let textView = iView.textView!
        //let textView = FLTextView()
        textView.contentMode = .scaleAspectFill
        textView.minimumZoomScale = 1.0
        textView.text = element.text
        textView.textAlignment = element.flAlignment.alignment()
        textView.textColor = UIColor(element.textColor)
        textView.font = font
        textView.isEditable = self.isEditor
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        var atb: [NSAttributedString.Key:Any] = [
            .font: font,
            .foregroundColor: textView.textColor ?? .black,
            .paragraphStyle: {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = FlashStyle.text.lineHeight
                return paragraph
            }()
        ]
        if element.flTextStyle.contains(.underline) {
            atb[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        let atbString =  NSMutableAttributedString(string: textView.text , attributes: atb)
        textView.attributedText = atbString
        textView.textAlignment = element.flAlignment.alignment()
        
        let margin: CGFloat = FlashStyle.text.marginIView
        let marginXY = margin / 2
        /* case for need width
        if element.width == 0, element.width == 0 {//case create new
            //let textViewFrame = textView.frameFromContent()
            //let fixWidth:CGFloat = 40//plus for digit missing
            //viewW = (FlashStyle.text.textWidthFromFont36 * CGFloat(scale)) + fixWidth
            viewW = textViewSize.width + margin
            viewH = textViewSize.height + margin
        }
        */
        //let textViewSize = element.text.size(font: font, maxWidth: stage.frame.width, maxHeight: stage.frame.height)
        if element.isCreating {//case new text
            let textViewSize = textView.frameFromContent()
            viewW = textViewSize.width
            viewH = textViewSize.height
        } else if self.isEditor {
            let textViewSize = textView.frameFromContent(fixWidth: viewW)
            viewW = textViewSize.width
            viewH = textViewSize.height
        } else {
            let textViewSize = textView.frameFromContent(fixWidth: viewW)
            viewW = textViewSize.width
            viewH = textViewSize.height
        }
        //let iView1 = InteractView(contentView: textView)!
        iView.type = .text
        //iView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: viewW, height: viewW))
        
        //iView.contentView = textView
        //textView.frame = CGRect(x: marginXY, y: marginXY, width: viewW - margin, height: viewH - margin)
        textView.textColor = UIColor(element.textColor)
        if let fill = element.fill {
            textView.backgroundColor = UIColor(fill)
        } else {
            textView.backgroundColor = .clear
        }
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(x: 0, y: 0, width: viewW + margin, height: viewH + margin)
        iView.contentFixWidth = viewW
        iView.frame = frame
        iView.center = center
        textView.updateLayout()
        //iView.textView = textView
        iView.type = element.type
        iView.element = element
        iView.scale = (scale == 1.0) ? 1.0 : scale
        iView.update(scale: scale)
        iView.update(rotation: element.rotation)
        //iView.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        //textView.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
        stage.addSubview(iView)
        return iView
    }
    
    func createImage(_ element: FlashElement ,in stage: FLStageView) -> InteractView {
        let viewX = (stage.frame.width * CGFloat(truncating: element.x) / 100)
        let viewY = ((stage.frame.height * CGFloat(truncating: element.y)) / 100)
        var viewW = ((stage.frame.width * CGFloat(truncating: element.width)) / 100)
        var viewH = ((stage.frame.height * CGFloat(truncating: element.height)) / 100)
        
        //fix size olly case create New
        if let _ = element.graphicType, element.isCreating {
            viewW = stage.frame.width * FlashStyle.graphic.displayRatio
            viewH = viewW//square
        }
        
        var size = CGSize(width: viewW, height: viewH)
        if let rawSize = element.rawSize {//image has rawSize
            let ratio = rawSize.height / rawSize.width
            let w = stage.frame.width * 0.8//80% of stage
            let h = w * ratio//height by ratio
            size = CGSize(width: w, height: h)
        }
        
        let margin = FlashStyle.text.marginIView
        let marginXY = margin / 2
        let imageviewFrame = CGRect(x: marginXY, y: marginXY, width: size.width, height: size.height)
        
        let imageview = UIImageView()
        imageview.frame = imageviewFrame
        
        if let image = element.uiimage {
            imageview.image = image
            
        } else if let imgSrc = element.src {
            imageview.imageUrl(imgSrc)
        }
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width + margin, height: size.height + margin) )
        let iView = InteractView(contentView: imageview)!
        
        iView.updateEditUI()
        
        iView.type = .image
        iView.element = element
        iView.frame = frame
        iView.center = center
        //iView.contentView = imageview
        iView.update(rotation: element.rotation)
        stage.addSubview(iView)
        return iView
    }
    
    func createQuiz(_ element: FlashElement ,in stage: FLStageView) -> FLQuizView {
        //let originalFrame = CGRect(x: 0, y: 0, width: 325, height: 200)
        //let stageW = stage.frame.width
        let quizW: CGFloat = 293
        let scaleUI: CGFloat = quizW / FlashStyle.baseStageWidth//0.9
        let expectQuizW: CGFloat = stage.bounds.width * scaleUI//370 / 0.9 = 334
        let quizView = FLQuizView.instanciateFromNib()
        quizView.scaleUI = expectQuizW / quizW//1.139
        let viewX = ((stage.frame.width * 50) / 100)
        let viewY = ((stage.frame.height * 50) / 100)
        //use stage width and scale down
        let size = CGSize(width: quizW, height: stage.frame.height)//let auto height
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(origin: CGPoint.zero, size: size)
        quizView.frame = frame
        quizView.center = center
        quizView.isEditor = self.isEditor
        quizView.createNewUI(element)
        return quizView
    }
    
    func sizeFromRaw(_ rawSize: CGSize, stage: FLStageView) -> CGSize {
        let ratio = rawSize.height / rawSize.width
        let w = stage.frame.width * 0.8//80% of stage
        let h = w * ratio//height by ratio
        return CGSize(width: w, height: h)
    }
    
    func createVideo(_ element: FlashElement ,in stage: FLStageView) -> InteractView? {
        let viewX = (stage.frame.width * CGFloat(truncating: element.x) / 100)
        let viewY = ((stage.frame.height * CGFloat(truncating: element.y)) / 100)
        let viewW = ((stage.frame.width * CGFloat(truncating: element.width)) / 100)
        let viewH = ((stage.frame.height * CGFloat(truncating: element.height)) / 100)
        
        
        var url: URL?
        if let deviceVideoUrl = element.deviceVideoUrl {
            url = deviceVideoUrl
            
        } else if let src = element.src, let urlsrc = URL(string: src) {
            url = urlsrc
        }
        
        var size = CGSize(width: viewW, height: viewH)
        if let rawSize = element.rawSize {
            size = self.sizeFromRaw(rawSize, stage: stage)
        }
        let margin = FlashStyle.text.marginIView
        let marginXY = margin / 2
        let playerViewFrame = CGRect(x: marginXY, y: marginXY, width: size.width, height: size.height)
        
        if let mediaUrl = url {
            let playerView = FLPlaverView(frame: playerViewFrame)
            playerView.createVideo(url: mediaUrl)
            
            let center = CGPoint(x: viewX, y: viewY)
            let frame = CGRect(x: viewX, y: viewY, width: size.width + margin, height: size.height + margin)
            let iView = InteractView(contentView: playerView)!
            
            iView.updateEditUI()
            
            iView.playerView = playerView
            iView.frame = frame
            iView.center = center
            //iView.contentView = playerView
            iView.update(rotation: element.rotation)
            stage.addSubview(iView)
            return iView
        }
        return nil
    }
    /*
    func createVector(_ element:FlashElement ,in stage: FLStageView) -> InteractView {
        let viewX = (stage.frame.width * CGFloat(element.x) / 100)
        let viewY = ((stage.frame.height * CGFloat(element.y)) / 100)
        let viewW = ((stage.frame.width * CGFloat(element.width)) / 100)
        let viewH = ((stage.frame.height * CGFloat(element.height)) / 100)
        let imageviewFrame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
        
        let svg = URL(string: "https://openclipart.org/download/181651/manhammock.svg")!
        let data = try? Data(contentsOf: svg)
        let receivedimage: SVGKImage = SVGKImage(data: data)
        let imageview = UIImageView()
        imageview.frame = imageviewFrame
        imageview.image = receivedimage.uiImage
        if let fill = element.fill {
            imageview.backgroundColor = UIColor(fill)
        }
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        let iView = InteractView(contentView: imageview)!
        iView.frame = frame
        iView.center = center
        //iView.contentView = imageview
        iView.svgImage = receivedimage
        iView.imageView = imageview
        iView.update(rotation: element.rotation)
        stage.addSubview(iView)
        return iView
    }
    */
    func createArrow(_ element: FlashElement ,in stage: FLStageView) -> InteractView {
        let viewX = (stage.frame.width * CGFloat(element.x) / 100)
        let viewY = ((stage.frame.height * CGFloat(element.y)) / 100)
        let viewW = ((stage.frame.width * CGFloat(element.width)) / 100)
        let viewH = ((stage.frame.height * CGFloat(element.height)) / 100)
        
        let viewFrame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
        
        let view = UIView()
        view.frame = viewFrame
        let start = CGPoint(x: 0, y: viewFrame.height / 2)
        let end = CGPoint(x: viewFrame.width, y: viewFrame.height / 2)
        let strokeWidth = ((stage.frame.width * CGFloat(element.strokeWidth ?? 1)) / 100)
        self.drawArrow(start: start, end: end, lineWidth: strokeWidth, in: view)
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        let iView = InteractView(contentView: view)!
        iView.frame = frame
        iView.center = center
        //iView.contentView = view
        iView.update(rotation: element.rotation)
        stage.addSubview(iView)
        return iView
    }
    
    func drawArrow(start:CGPoint, end:CGPoint, lineWidth:CGFloat, in view: UIView) {
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
