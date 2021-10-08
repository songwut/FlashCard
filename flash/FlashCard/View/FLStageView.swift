//
//  FLStageView.swift
//  flash
//
//  Created by Songwut Maneefun on 2/9/2564 BE.
//

import UIKit

class FLStageView: UIView {
    var stageRatio:CGFloat = 1
    var flCreator: FLCreator!
    var isEditor = false
    var viewModel: FLStageViewModel?
    var cover: UIImageView!
    
    var flColor: FLColorResult? {
        didSet {
            guard let flColor = self.flColor else { return }
            self.backgroundColor = UIColor(flColor.hex)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.flCreator = FLCreator(stage: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.flCreator = FLCreator(stage: self)
        self.cornerRadius = FlashStyle.cardCornerRadius
        self.cover = UIImageView(frame: CGRect(origin: .zero, size: frame.size))
    }
    
    var page: FLCardPageResult? {
        didSet {
            print("FLStageView frame: \(self.frame)")
        }
    }
    
    func loadElement() {
        guard let page = self.page else { return }
        for v in self.subviews {
           v.removeFromSuperview()
        }
        self.cover.imageUrl(page.image)
        self.viewModel?.callAPICardList(cardId: page.id, complete: { (pageDetail: FLCardPageDetailResult) in
            self.backgroundColor = UIColor(pageDetail.bgColor.hex)
            for element in pageDetail.componentList {
                let v = self.createElement(element)
                v?.tag = element.id
            }
            self.cover.isHidden = true
        })
    }
    
    func createElement(_ element: FlashElement) -> UIView? {
        var view: UIView?
        if element.type == .text {
            view = self.createTextView(element)
            
        } else if element.type == .image {
            view = self.createImage(element)
            
        } else if element.type == .shape {
            view = self.createImage(element)
            
        } else if element.type == .sticker {
            view = self.createImage(element)
            
        }  else if element.type == .video {
            view = self.createVideo(element)
            
        }  else if element.type == .quiz {
            view = self.createQuizView(element)
        }
        if let v = view {
            self.addSubview(v)
        }
        return view
    }
    
    func createQuizView(_ element: FlashElement) -> FLQuizView {
        
        let stageView = self
        let quizView = self.flCreator.createQuiz(element, in: stageView)
        quizView.alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            quizView.alpha = 1.0
//            quizView.popIn(fromScale: 0.5, toScale: quizView.scale, duration: 0.5, delay: 0) { (done) in
//                print("popIn quizView: \(quizView.frame)")
//            }
            
        }
        return quizView
    }
    
    func createImage(_ element: FlashElement) -> InteractView {
        
        let stageView = self
        let iView = self.flCreator.createImage(element, in: stageView)
        return iView
    }
    
    func createVideo(_ element: FlashElement) -> InteractView? {
        
        let stageView = self
        let iView = self.flCreator.createVideo(element, in: stageView)
        return iView
    }
    
    func createTextView(_ element: FlashElement) -> InteractTextView {
        
        let stageView = self
        let textElement = self.flCreator.createText(element, in: stageView)
        
        textElement.textView?.isEditable = false
        return textElement
    }
    
    func createJSON() -> [String: AnyObject]? {
        var dict = [String: AnyObject]()
        
        var component = [[String: AnyObject]]()
        var sort = 1
        for view in self.subviews {
            if let iView = view as? InteractView {
                let dictElement = iView.createJSON()
                ConsoleLog.show("iView: \(dictElement)")
                component.append(dictElement)
                
            } else if let iViewText = view as? InteractTextView {
                let dictElement = iViewText.createJSON()
                component.append(dictElement)
                ConsoleLog.show("iViewText: \(dictElement)")
                
            } else if let quizView = view as? FLQuizView {
                let dictElement = quizView.createJSON()
                component.append(dictElement)
                ConsoleLog.show("quizView: \(dictElement)")
            }
            ConsoleLog.show("^^^component: \(sort)\n")
            sort += 1
        }
        
        var colorDict = [String: AnyObject]()
        if let flColor = self.flColor {
            colorDict["bg_color"] = flColor.createJSON() as AnyObject?
        }
        
        dict["bg_color"] = colorDict as AnyObject
        dict["component"] = component as AnyObject?
        
        return dict
    }
}
