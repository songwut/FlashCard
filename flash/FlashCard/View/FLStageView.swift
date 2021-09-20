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
    
    var page: FlashPageResult? {
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
        self.viewModel?.callAPICardList(cardId: page.id, complete: { (pageDetail: FLPageDetailResult) in
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
    
    func createTextView(_ element: FlashElement) -> InteractView {
        
        let stageView = self
        let textElement = self.flCreator.createText(element, in: stageView)
        
        textElement.textView?.isEditable = false
        return textElement
    }
}
