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
    var isRequireToLoadElement = true
    var viewModel: FLFlashCardViewModel?
    var cover: UIImageView!
    var coverImageBase64: String?
    //var sort:Int?
    var flColor: FLColorResult = FLColorResult(JSON: ["code" : "color_01", "cl_code": "FFFFFF"])! {
        didSet {
            self.backgroundColor = UIColor(flColor.hex)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cornerRadius = FlashStyle.cardCornerRadius
        self.cover = UIImageView(frame: CGRect(origin: .zero, size: frame.size))
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
            //self.sort = cardDetail.sort
        }
    }
    /*
    func loadElement(viewModel:FLFlashCardViewModel) {//User Player
        self.viewModel = viewModel
        guard let card = self.card else { return }
        for v in self.subviews {
           v.removeFromSuperview()
        }
        self.cover.imageUrl(card.image)
        
        self.viewModel?.callAPICardDetail(card) { [weak self] (cardDetail) in
            guard let self = self else { return }
            guard let cardDetail = cardDetail else { return }
            self.flColor = cardDetail.bgColor
            for element in cardDetail.componentList {
                let v = self.createElement(element)
                v?.tag = element.id
                if let quizView = v as? FLQuizView {
                    self.quizManageSize(quizView)
                }
            }
            
            //Manage size
            self.cover.isHidden = true
        }
    }
    */
    
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
                let v = self.createElement(element)
                v?.tag = element.id
                if !self.isEditor {//animate in player
                    if let quizView = v as? FLQuizView {
                        self.quizManageSize(quizView)
                    }
                }
                
                complete(v)
            }
            self.cover.isHidden = true
        }
    }
    
    func quizManageSize(_ quizView: FLQuizView) {
        quizView.alpha = 0.0
        let originalCenter = quizView.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            quizView.bounds = CGRect(x: 0, y: 0, width: quizView.bounds.width, height: self.frame.height)
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
        if let v = view {
            self.addSubview(v)
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
            self?.sendAnswer(sender)
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
