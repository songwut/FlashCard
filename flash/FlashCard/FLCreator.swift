//
//  FLCreator.swift
//  flash
//
//  Created by Songwut Maneefun on 17/6/2564 BE.
//

import UIKit
import AVKit

struct FLCreator {
    var isEditor = true
    var playerState: FLPlayerState = .user
    
    init(isEditor:Bool) {
        self.isEditor = isEditor
    }
    
    func createText(_ element:FlashElement ,in stage: FLStageView) -> InteractTextView {
        let viewX = (stage.frame.width * CGFloat(truncating: element.x) / 100)
        let viewY = ((stage.frame.height * CGFloat(truncating: element.y)) / 100)
        var viewW = ((stage.frame.width * CGFloat(truncating: element.width)) / 100)
        var viewH = ((stage.frame.height * CGFloat(truncating: element.height)) / 100)
        
        var viewUnScaleW = ((FlashStyle.baseStageWidth * CGFloat(truncating: element.width)) / 100)
        var viewUnScaleH = ((FlashStyle.baseStageHeight * CGFloat(truncating: element.height)) / 100)
        
        let stageRatio = stage.frame.width / FlashStyle.baseStageWidth
        var scale = (Float(element.scale) + Float(stageRatio)) - 1.0
        element.fontScale = CGFloat(scale) // scale font up to screen ratio
        let font:UIFont = element.manageFontScale()
        
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
        
        let plusWidth:CGFloat = FlashStyle.text.plusWidth
        let textMargin = FlashStyle.text.textMargin
        
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
        textView.textContainerInset = UIEdgeInsets(
            top: textMargin + 10,
            left: textMargin + 6,
            bottom: 6,
            right: textMargin + 6
        )
        
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
        
        //let textViewSize = element.text.size(font: font, maxWidth: stage.frame.width, maxHeight: stage.frame.height)
        var textViewSize:CGRect = .zero
        if element.isCreating {//case new text
            textViewSize = textView.frameFromContent()
        } else if self.isEditor {
            textViewSize = textView.frameFromContent(fixWidth: viewW)
        } else {
            textViewSize = textView.frameFromContent(fixWidth: viewW)
        }
        let realSizeCal = textView.textAreaSizePur()
        ConsoleLog.show("//////")
        ConsoleLog.show("elementText: \(element.text)")
        ConsoleLog.show("realSizeCal: \(realSizeCal)")
        ConsoleLog.show("fontSizeDisplay: \(element.fontSizeDisplay) | \(element.fontScale) || \(font)")
        
        // case from web need width
        if element.width == 0, element.width == 0 {//case create new
            //let textViewFrame = textView.frameFromContent()
            //let fixWidth:CGFloat = 60//plus for digit missing
            
            scale = Float(stageRatio)// case 1.0 use stageRation// will remove if new way work
            
            textViewSize = textView.frameFromContent()
            //viewW = (FlashStyle.text.textWidthFromFont36 * CGFloat(scale)) + fixWidth
            viewW = (textViewSize.width * stageRatio) + margin
            viewH = (textViewSize.height * stageRatio) + margin
        }
        
        //new web UI support text with frame area
        //viewW, viewH read direct from element
        //viewW = viewUnScaleW
        //viewH = viewUnScaleH
        
        //this code below for test with text without area
        /*        if realSizeCal.width > textViewSize.width {//case no \n
            viewW = textViewSize.width + plusWidth
            viewH = textViewSize.height + plusWidth
        } else {//case one line
            viewW = realSizeCal.width + plusWidth
            viewH = realSizeCal.height + plusWidth
        }
        */
        
        //let iView1 = InteractView(contentView: textView)!
        iView.type = .text
        //iView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: viewW, height: viewW))
        
        iView.contentView = textView
        textView.frame = CGRect(x: marginXY, y: marginXY, width: viewW - margin, height: viewH - margin)
        textView.textColor = UIColor(element.textColor)
        if let fill = element.fill {
            textView.backgroundColor = UIColor(fill)
        } else {
            textView.backgroundColor = .clear
        }
        
        let center = CGPoint(x: viewX, y: viewY)
        let frame = CGRect(x: 0, y: 0, width: viewW + margin, height: viewH + margin)
        iView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        iView.center = center
        //textView.updateLayout()//this line make frame bug
        iView.type = element.type
        iView.element = element
        iView.backgroundColor = .clear
        textView.backgroundColor = .clear
        iView.frame = frame
        iView.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        iView.center = center
        stage.addSubview(iView)
        iView.scale = (scale == 1.0) ? 1.0 : scale//1.1405
        //iView.update(scale: scale)
        let radians = InteractView.getRadians(degrees: element.rotation?.doubleValue ?? 0)
        iView.rotation = Float(radians)
        iView.update(rotation: radians)
        //iView.update(scale: scale, rotation: Float(radians))
        return iView
    }
    
    func createImage(_ element: FlashElement ,in stage: FLStageView) -> InteractView {
        let viewX = (stage.frame.width * CGFloat(truncating: element.x) / 100)
        let viewY = ((stage.frame.height * CGFloat(truncating: element.y)) / 100)
        var viewW = ((stage.frame.width * CGFloat(truncating: element.width)) / 100)
        var viewH = ((stage.frame.height * CGFloat(truncating: element.height)) / 100)
        var scale = (Float(element.scale) + Float(stage.stageRatio)) - 1.0
        
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
        
        //image scale in width and height
        //iView.scale = (scale == 1.0) ? 1.0 : scale
        //iView.update(scale: scale)
        iView.frame = frame
        iView.center = center
        //iView.contentView = imageview
        let radians = InteractView.getRadians(degrees: element.rotation?.doubleValue ?? 0)
        iView.update(rotation: radians)
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
        stage.addSubview(quizView)
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
            let radians = InteractView.getRadians(degrees: element.rotation?.doubleValue ?? 0)
            iView.update(rotation: radians)
            stage.addSubview(iView)
            return iView
        }
        return nil
    }
}
