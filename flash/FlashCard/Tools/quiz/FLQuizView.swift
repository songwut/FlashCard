//
//  FLQuizView.swift
//  flash
//
//  Created by Songwut Maneefun on 16/8/2564 BE.
//

import UIKit
import GrowingTextView

class FLQuizView: UIView {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var questionHeight: NSLayoutConstraint!
    @IBOutlet weak var questionTextView: GrowingTextView!
    @IBOutlet weak var choiceStackView: UIStackView!
    @IBOutlet weak var addButton: UIButton!
    
    var didDelete: DidAction?
    var isCreate = false
    var choiceCount = 0
    var scale:CGFloat = 1.0
    
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
            //self.cardView.updateLayout()
            self.titleLabel.text = "Question :"
            self.questionTextView.placeholder = "Write your question."
            self.questionTextView.placeholderColor = .white
            
            self.questionTextView.returnKeyType = .done
            self.questionTextView.enablesReturnKeyAutomatically = true
            self.questionTextView.maxLength = 300
            
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
            self.choiceStackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    @IBAction func addChoicePressed(_ sender: UIButton) {
        let choiceView = FLChoiceView.instanciateFromNib()
        let choice = FLChoiceResult(JSON: ["id" : -1])!
        choiceView.choice = choice
        self.question?.choiceList.append(choice)
        self.choiceStackView.addArrangedSubview(choiceView)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        self.didDelete?.handler(nil)
    }
    
    override func awakeFromNib() {
        self.titleLabel.textColor = .white
        self.questionTextView.delegate = self
        self.questionTextView.backgroundColor = .clear
        self.questionTextView.font = FontHelper.getFontSystem(.paragraph, font: .text)
        self.questionTextView.textColor = .white
        self.questionTextView.minHeight = 36
        
        self.cardView.cornerRadius = 8
        self.cardView.backgroundColor = UIColor("4A4A4A")
        self.addButton.isHidden = true
        self.addButton.titleFont = FontHelper.getFontSystem(.paragraph, font: .text)
        self.addButton.setTitle("+ Add Option", for: .normal)
        self.addButton.tintColor = .white
        self.addButton.setTitleColor(.white, for: .normal)
        self.addButton.cornerRadius = 8
        let edge = FlashStyle.quiz.choiceMargin
        self.addButton.imageEdgeInsets = UIEdgeInsets(top: edge / 2, left: edge, bottom: edge / 2, right: edge)
        self.questionTextView.delegate = self
        //self.button.backgroundColor = FlashStyle.bottonToolColor
        //self.button.tintColor = .white
    }
    
    class func instanciateFromNib() -> FLQuizView {
        return Bundle.main.loadNibNamed("FLQuizView", owner: nil, options: nil)![0] as! FLQuizView
    }
}

extension FLQuizView: GrowingTextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        ConsoleLog.show("textViewDidBeginEditing")
    }
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        ConsoleLog.show("GrowingTextView height:\(height)")
        //self.questionTextView.maxHeight = height
    }
    
    private func textViewDidChange(_ growingTextView: GrowingTextView) {
        ConsoleLog.show("growingTextViewDidChange:\(String(describing: growingTextView.text))")
        self.question?.value = growingTextView.text
    }
}

