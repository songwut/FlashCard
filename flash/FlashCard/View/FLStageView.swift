//
//  FLStageView.swift
//  flash
//
//  Created by Songwut Maneefun on 2/9/2564 BE.
//

import UIKit

class FLStageView: FlashStageView {
    var isVideoAutoPlay = false
    var isRequireSave = false
    var playerView: FLPlaverView?
    var playerState: FLPlayerState = .user
    var stageRatio:CGFloat = 1
    var flCreator: FLCreator!
    var isEditor = false
    var isRequireToLoadElement = true
    var viewModel: FLFlashCardViewModel?
    var cover: UIImageView!
    var coverImageBase64: String?
    var flColor: FLColorResult = MockObject.flColor {
        didSet {
            self.backgroundColor = UIColor(flColor.hex)
        }
    }
    
    deinit {
        print("FLStageView removed")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = FlashStyle.cardCornerRadius
        self.cover = UIImageView(frame: CGRect(origin: .zero, size: frame.size))
        self.backgroundColor = .white
    }
    
    var card: FLCardPageResult? {
        didSet {
            if let card = self.card {
                card.stage = self
            }
            print("FLStageView frame: \(self.frame)")
        }
    }
    
    var cardDetail: FLCardPageDetailResult? {
        didSet {
            guard let cardDetail = self.cardDetail else { return }
            //self.sort = cardDetail.sort // sort manual is worked
        }
    }
    
    func loadElement(viewModel:FLFlashCardViewModel,
                     complete: @escaping (_ content: Any?) -> ()) {
        self.viewModel = viewModel
        guard let card = self.card else { return }
        for v in self.subviews {
           v.removeFromSuperview()
        }
        self.cover.imageUrl(card.image)
        
        self.viewModel?.callAPICardDetail(card) { [weak self] (cardDetail) in
            guard let self = self else { return }
            guard let cardDetail = cardDetail else { return }
            self.cardDetail = cardDetail
            self.flColor = cardDetail.bgColor
            
            for element in cardDetail.componentList {
                let anyView = self.createElement(element)
                
                anyView?.tag = element.id
                if let iView = anyView as? InteractView {
                    iView.element = element
                    iView.element?.sort = self.subviews.count + 1
                    iView.isHiddenEditingTool = true
                    iView.isUserInteractionEnabled = self.isEditor
                    
                } else if let iView = anyView as? InteractTextView {
                    iView.element = element
                    iView.element?.sort = self.subviews.count + 1
                    iView.isHiddenEditingTool = true
                    iView.isUserInteractionEnabled = self.isEditor
                    
                } else if let quizView = anyView as? FLQuizView {
                    quizView.element = element
                    quizView.element?.sort = self.subviews.count + 1
                    if !self.isEditor {//animate in player
                        self.quizManageSizeAnimate(quizView)
                    }
                }
                
                if let v = anyView {
                    self.addSubview(v)
                }
                complete(anyView)
            }
            self.cover.isHidden = true
        }
    }
    
    func quizManageSizeAnimate(_ quizView: FLQuizView) {
        //updateQuizContentSize
        quizView.updateLayoutAll()
        let originalCenter = quizView.center
        quizView.alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let cardHeight = quizView.cardView.bounds.height + 50 //fix size
            quizView.bounds = CGRect(x: 0, y: 0, width: quizView.bounds.width, height: cardHeight)
            quizView.center = originalCenter
            quizView.alpha = 1.0
            quizView.popIn(fromScale: 0.5, toScale: quizView.scaleUI, duration: 0.5, delay: 0) { (done) in
                print("popIn quizView: \(quizView.frame)")
            }
        }
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
        return view
    }
    
    func sendAnswer(_ answer: Any?) {
        guard let card = self.card else { return }
        guard let a = answer as? FLAnswerResult else { return }
        let parame = a.createJSON()
        print("sendAnswer param:\(parame?.jsonString ?? "")")
        self.viewModel?.callAPICardDetailAnswer(card, method: .post, param: parame, complete: { (answer) in
            print("sendAnswer:\(String(describing: answer))")
        })
    }
    
    func createQuizView(_ element: FlashElement) -> FLQuizView {
        
        let stageView = self
        let quizView = self.flCreator.createQuiz(element, in: stageView)
        quizView.isEditor = self.isEditor
        quizView.didSelectChoice = Action(handler: { [weak self] (sender) in
            if self?.playerState == .user {
                self?.sendAnswer(sender)
            }
        })
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
    
    func createJSON() -> [String: Any]? {
        var dict = [String: Any]()
        var data = [String: AnyObject]()
        
        var component = [[String: AnyObject]]()
        var eSort = 1
        for view in self.subviews {
            if let iView = view as? InteractView {
                var dictElement = iView.createJSON()
                dictElement["sort"] = eSort as AnyObject
                ConsoleLog.show("iView: \(dictElement)")
                component.append(dictElement)
                
            } else if let iViewText = view as? InteractTextView {
                var dictElement = iViewText.createJSON()
                dictElement["sort"] = eSort as AnyObject
                component.append(dictElement)
                ConsoleLog.show("iViewText: \(dictElement)")
                
            } else if let quizView = view as? FLQuizView {
                var dictElement = quizView.createJSON()
                dictElement["sort"] = eSort as AnyObject
                component.append(dictElement)
                ConsoleLog.show("quizView: \(dictElement)")
            }
            eSort += 1
        }
        
        let colorDict = self.flColor.createJSON()
        
        data["bg_color"] = colorDict as AnyObject
        data["component"] = component as AnyObject?
        
        dict["data"] = data as AnyObject?
        if let coverImageBase64 = self.coverImageBase64 {
            dict["image"] = coverImageBase64 as AnyObject?
        }
        
        if let card = self.card {//sort by array order
            dict["sort"] = card.order as AnyObject?
        }
        
        return dict
    }
    
    func prepareBeforeSaveView() {
        for v in self.subviews {
            if let quizView = v as? FLQuizView {
                quizView.endEditing(true)
            }
        }
    }
}
