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
    @IBOutlet weak var questionHeight: NSLayoutConstraint!
    @IBOutlet weak var questionTextView: GrowingTextView!
    @IBOutlet weak var choiceStackView: UIStackView!
    @IBOutlet weak var addStackView: UIStackView!
    @IBOutlet weak var addButton: FLDashButton?
    
    var didDelete: DidAction?
    var isCreate = false
    var scale:CGFloat = 1.0
    var choiceCount: Int {
        guard let question = self.question else { return 0 }
        return question.choiceList.count
    }
    
    func createNewUI(question: FLQuestionResult?) {
        guard let q = question else { return }
        self.isCreate = true
        self.question = q
        
        self.addButton?.updateLayout()
    }
    
    private func createChoiceView(_ choice: FLChoiceResult) -> FLChoiceView {
        let choiceView = FLChoiceView.instanciateFromNib()
        choiceView.isCreate = self.isCreate
        
        choiceView.choice = choice
        choiceView.didDelete = DidAction(handler: { [weak self] (sender) in
            guard let question = self?.question else { return }
            if question.choiceList.count > 1 {
                let index = choiceView.checkButton.tag - 1
                question.choiceList.remove(at: index)
                choiceView.removeFromSuperview()
                
                self?.addStackView.isHidden = question.choiceList.count == FlashStyle.maxChoice
            }
        })
        choiceView.checkButton.addTarget(self, action: #selector(self.choicePressed(_:)), for: .touchUpInside)
        return choiceView
    }
    
    var question: FLQuestionResult? {
        didSet {
            self.titleLabel.text = "Question :"
            self.questionTextView.font = FontHelper.getFontSystem(.paragraph, font: .text)
            self.questionTextView.placeholder = "Write your question."
            self.questionTextView.placeholderColor = .white
            
            self.questionTextView.maxLength = FlashStyle.maxCharQuestion
            
            guard let question = self.question else { return }
            self.choiceStackView.removeAllArranged()
            for index in 0..<question.choiceList.count {
                let choice = question.choiceList[index]
                let choiceView = self.createChoiceView(choice)
                choiceView.checkButton.tag = index + 1
                self.choiceStackView.addArrangedSubview(choiceView)
            }
        }
    }
    
    @objc func choicePressed(_ sender: UIButton) {
        guard let question = self.question else { return }
        //reset select
        for i in 0..<question.choiceList.count {
            if let choiceView = self.choiceStackView.arrangedSubviews[i] as? FLChoiceView {
                let choice = question.choiceList[i]
                choice.isAnswer = false
                choiceView.choice = choice
            }
        }
        
        //update select
        let selectedIndex = sender.tag - 1
        let choice = question.choiceList[selectedIndex]
        choice.isAnswer = true
        if let choiceView = self.choiceStackView.arrangedSubviews[selectedIndex] as? FLChoiceView {
            choiceView.choice = choice
        }
    }
    
    @IBAction func addChoicePressed(_ sender: UIButton) {
        guard let question = self.question else { return }
        //create new choice
        let order = self.choiceCount + 1
        let title = "Option \(order)"
        let choice = FLChoiceResult(JSON: ["id" : -1, "value" : title])!
        let choiceView = self.createChoiceView(choice)
        choiceView.checkButton.tag = order
        self.choiceStackView.addArrangedSubview(choiceView)
        question.choiceList.append(choice)
        
        print("question.choiceList.count: \(question.choiceList.count)")
        self.addStackView.isHidden = question.choiceList.count == FlashStyle.maxChoice
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        self.didDelete?.handler(nil)
    }
    
    override func awakeFromNib() {
        self.titleLabel.textColor = .white
        self.questionTextView.delegate = self
        self.questionTextView.backgroundColor = .clear
        self.questionTextView.textColor = .white
        self.questionTextView.minHeight = 36
        
        self.addButton?.titleFont =  FontHelper.getFontSystem(.paragraph, font: .text)
        self.addButton?.setTitle("+ Add Option", for: .normal)
        
        self.cardView.cornerRadius = 8
        self.cardView.backgroundColor = UIColor("4A4A4A")
        self.questionTextView.delegate = self
    }
    
    class func instanciateFromNib() -> FLQuizView {
        return Bundle.main.loadNibNamed("FLQuizView", owner: nil, options: nil)![0] as! FLQuizView
    }
}

extension FLQuizView: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        ConsoleLog.show("question GrowingTextView height:\(height)")
        //self.textView.superview?.layoutIfNeeded()
        self.questionHeight.constant = height
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        ConsoleLog.show("question textViewDidBeginEditing")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count  <= FlashStyle.maxCharQuestion {
            self.question?.value = textView.text
            self.questionTextView.updateLayout()
            ConsoleLog.show("question textViewDidChange: \(textView.text.count)")
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.contains("\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

