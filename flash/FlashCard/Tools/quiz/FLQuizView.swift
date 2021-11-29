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
    @IBOutlet weak var deleteButton: UIButton?
    
    var didSelectChoice: Action?
    var didDelete: Action?
    var isEditor = false
    var scaleUI:CGFloat = 1.0
    var choiceCount: Int {
        guard let question = self.question else { return 0 }
        return question.choiceList.count
    }
    var correctChoiceView: FLChoiceView?
    var element: FlashElement? {
        didSet {
            self.question = self.element?.question
        }
        
    }
    
    var question: FLQuestionResult? {
        didSet {
            self.titleLabel.text = "Question :"
            self.questionTextView.font = .font(.paragraph, .text)
            if self.isEditor {
                self.questionTextView.placeholder = "Write your question."
                self.questionTextView.placeholderColor = .white
            }
            
            self.questionTextView.maxLength = FlashStyle.maxCharQuestion
            self.questionTextView.text = self.question?.value ?? ""
            self.deleteButton?.isHidden = !self.isEditor
            
            guard let question = self.question else { return }
            self.choiceStackView.removeAllArranged()
            for index in 0..<question.choiceList.count {
                let choice = question.choiceList[index]
                let choiceView = self.createChoiceView(choice, question: question)
                self.choiceStackView.addArrangedSubview(choiceView)
            }
            
            if self.isEditor {
                self.addStackView.isHidden = question.choiceList.count >= FlashStyle.maxChoice
            } else {
                self.addStackView.isHidden = true
            }
        }
    }
    
    func createNewUI(_ element: FlashElement?) {
        guard let e = element else { return }
        self.element = e
        self.addButton?.updateLayout()
    }
    
    func createJSON() -> [String: AnyObject] {
        
        var dict = [String: AnyObject]()
        guard let stage = self.superview as? FLStageView else { return dict }
        guard let question = self.question else { return dict }
        let marginIView = FlashStyle.text.marginIView
        let size = self.bounds.size
        let contentSize = CGSize(width: size.width - marginIView, height: size.height - marginIView)
        let percentWidth = (contentSize.width / stage.bounds.width) * 100
        let percentHeight = (contentSize.height / stage.bounds.height) * 100
        
        let elementCenter = self.center
        let centerX = (elementCenter.x / stage.bounds.width) * 100
        let centerY = (elementCenter.y / stage.bounds.height) * 100
        
        dict["width"] = percentWidth as AnyObject
        dict["height"] = percentHeight as AnyObject
        dict["position_x"] = centerX as AnyObject
        dict["position_y"] = centerY as AnyObject
        dict["type"] = FLType.quiz.rawValue as AnyObject
        
        var detail = [String: AnyObject]()
        var choiceListJson = [[String: AnyObject]]()
        for choice in question.choiceList {
            var choiceJson = [String: AnyObject]()
            choiceJson["id"] = choice.id as AnyObject
            choiceJson["value"] = choice.value as AnyObject
            choiceJson["is_answer"] = choice.isAnswer as AnyObject?
            choiceListJson.append(choiceJson)
        }
        
        //detail["id"] = question.id as AnyObject//back gen
        let quizTitle = question.value == "" ? "question".localized() : question.value
        detail["value"] = quizTitle as AnyObject
        detail["choice"] = choiceListJson as AnyObject
        dict["detail"] = detail as AnyObject
        
        return dict
    }
    
    func updateHeight(_ complete: @escaping () -> ()) {
        self.updateLayout()
        self.cardView.updateLayout()
        self.choiceStackView.updateLayout()
        let originalCenter = self.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("self.frame.height: \(self.frame.height)")
            print("self.cardView.frame.height: \(self.cardView.frame.height)")
            self.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            self.center = originalCenter
            complete()
        }
    }
    
    private func createChoiceView(_ choice: FLChoiceResult, question: FLQuestionResult) -> FLChoiceView {
        let choiceView = FLChoiceView.instanciateFromNib()
        choiceView.isEditor = self.isEditor
        choiceView.answer = question.answer
        choiceView.choice = choice
        choiceView.didDelete = Action(handler: { [weak self] (sender) in
            let index = question.choiceList.firstIndex { (c) -> Bool in
                return c.id == choice.id
            }
            if let removeIndex = index {
                question.choiceList.remove(at: removeIndex)
                choiceView.removeFromSuperview()
                self?.addStackView.isHidden = question.choiceList.count == FlashStyle.maxChoice
            }
        })
        if self.isEditor {//fieldButton hover all area
            choiceView.fieldButton.isHidden = true
            choiceView.checkButton.addTarget(self, action: #selector(self.choicePressed(_:)), for: .touchUpInside)
        } else {
            choiceView.fieldButton.addTarget(self, action: #selector(self.answerSelected(_:)), for: .touchUpInside)
            //let tap = TapGesture(target: self, action: #selector(self.answerSelected(_:)))
            //choiceView.isUserInteractionEnabled = true
            //choiceView.addGestureRecognizer(tap)
            choiceView.textView.isEditable = false
            choiceView.textView.isSelectable = false
        }
        
        return choiceView
    }
    
    @objc func answerSelected(_ sender: FLChoiceButton) {//Player
        guard let question = self.question else { return }
        guard let choice = sender.choice else { return }
        if question.answer == nil {
            let answer = FLAnswerResult(JSON: ["choice_id" : choice.id])
            answer?.value = choice.value
            question.answer = answer
            for v in self.choiceStackView.arrangedSubviews {
                if let choiceView = v as? FLChoiceView {
                    choiceView.answer = answer
                    choiceView.updateUI()
                    choiceView.isUserInteractionEnabled = false
                }
            }
            self.didSelectChoice?.handler(answer)
        }
        
    }
    
    @objc func choicePressed(_ sender: FLChoiceButton) {//Edit
        guard let question = self.question else { return }
        //reset select
        for i in 0..<question.choiceList.count {
            if let choiceView = self.choiceStackView.arrangedSubviews[i] as? FLChoiceView {
                let choice = question.choiceList[i]
                choice.isAnswer = false
                choiceView.choice = choice
            }
        }
        
        //update select and reupdate content
        let choice = sender.choice
        choice?.isAnswer = true
        sender.choiceView?.choice = choice
    }
    
    @IBAction func addChoicePressed(_ sender: UIButton) {
        guard let question = self.question else { return }
        //create new choice
        let order = self.choiceCount + 1
        let title = "Option \(order)"
        let choice = FLChoiceResult(JSON: ["id" : order, "value" : title])!
        let choiceView = self.createChoiceView(choice, question: question)
        self.choiceStackView.addArrangedSubview(choiceView)
        question.choiceList.append(choice)
        
        print("question.choiceList.count: \(question.choiceList.count)")
        self.addStackView.isHidden = question.choiceList.count == FlashStyle.maxChoice
        
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        self.didDelete?.handler(nil)
    }
    
    override func awakeFromNib() {
        self.deleteButton?.tintColor = .white
        self.titleLabel.textColor = .white
        self.questionTextView.delegate = self
        self.questionTextView.backgroundColor = .clear
        self.questionTextView.textColor = .white
        self.questionTextView.minHeight = 36
        
        self.addButton?.titleFont =  .font(.paragraph, .text)
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
        if textView.text.hasPrefix("Option") {
            textView.selectAll(self)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count  <= FlashStyle.maxCharQuestion {
            self.question?.value = textView.text
            self.questionTextView.updateLayout()
            ConsoleLog.show("question textViewDidChange: \(textView.text.count)")
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.questionTextView.isPastingContent {
            self.questionTextView.isPastingContent = false
            ConsoleLog.show("paste")
            DispatchQueue.main.async {
                self.questionTextView.updateLayout()
            }
            return true
        } else if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

