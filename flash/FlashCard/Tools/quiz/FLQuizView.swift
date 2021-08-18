//
//  FLQuizView.swift
//  flash
//
//  Created by Songwut Maneefun on 16/8/2564 BE.
//

import UIKit
import GrowingTextView

final class FLQuizView: UIView {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionTextView: GrowingTextView!
    @IBOutlet weak var choiceStackView: UIStackView!
    @IBOutlet weak var addButton: UIButton!
    
    var didDelete: DidAction?
    var isCreate = false
    
//var choiceList = [FLChoiceResult]()
    var choiceCount = 0
    
    func createNew(question: FLQuestionResult?) {
        guard let q = question else { return }
        self.isCreate = true
        self.question = q
        
        self.addButton.isHidden = false
        self.addButton.updateLayout()
        self.addButton.addDash(1, color: UIColor("D7DFE9"))
        
    }
    
    var question: FLQuestionResult? {
        didSet {
            self.titleLabel.text = "Question :"
            guard let question = self.question else { return }
            self.choiceStackView.removeAllArranged()
            var choiceTag = 1
            for choice in question.choiceList {
                let choiceView = FLChoiceView.instanciateFromNib()
                choiceView.isCreate = self.isCreate
                self.choiceStackView.addArrangedSubview(choiceView)
                choiceView.choice = choice
                choiceView.checkButton.tag = choiceTag
                
                choiceView.checkButton.addTarget(self, action: #selector(self.choicePressed(_:)), for: .touchUpInside)
                choiceTag += 1
            }
            self.questionTextView.delegate = self
        }
    }
    
    @objc func choicePressed(_ sender: UIButton) {
        let index = sender.tag - 1
        guard let question = self.question else { return }
        let choice = question.choiceList[index]
        var newIsAnswer = false
        if let isAnswer = choice.isAnswer {
            newIsAnswer = !isAnswer
        } else {
            newIsAnswer = true
        }
        choice.isAnswer = newIsAnswer
        
        if let choiceView = self.choiceStackView.arrangedSubviews[index] as? FLChoiceView {
            choiceView.choice = choice
        }
        
        //self.didPressTool?.handler(self.tool)
    }
    
    @objc func addChoicePressed(_ sender: UIButton) {
        let choiceView = FLChoiceView.instanciateFromNib()
        choiceView.choice = FLChoiceResult(JSON: ["id" : -1])
        self.choiceStackView.addArrangedSubview(choiceView)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        self.didDelete?.handler(nil)
    }
    
    override func awakeFromNib() {
        self.cardView.cornerRadius = 8
        self.cardView.backgroundColor = UIColor("4A4A4A")
        self.addButton.isHidden = true
        self.addButton.titleFont = FontHelper.getFontSystem(.s, font: .text)
        self.addButton.setTitle("+ Add Option", for: .normal)
        self.addButton.cornerRadius = 8
        let edge = FlashStyle.quiz.choiceMargin
        self.addButton.imageEdgeInsets = UIEdgeInsets(top: edge / 2, left: edge, bottom: edge / 2, right: edge)
        
        //self.button.backgroundColor = FlashStyle.bottonToolColor
        //self.button.tintColor = .white
    }
    
    class func instanciateFromNib() -> FLQuizView {
        return Bundle.main.loadNibNamed("FLQuizView", owner: nil, options: nil)![0] as! FLQuizView
    }
}

extension FLQuizView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.question?.value = textView.text
    }
    
}
