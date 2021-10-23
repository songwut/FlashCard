//
//  FLChoiceView.swift
//  flash
//
//  Created by Songwut Maneefun on 16/8/2564 BE.
//

import UIKit
import GrowingTextView

class FLChoiceButton: UIButton {
    var choice: FLChoiceResult?
    var choiceView: FLChoiceView?
}

final class FLChoiceView: UIView {
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var checkButton: FLChoiceButton!
    @IBOutlet weak var fieldButton: FLChoiceButton!
    
    var isEditor = false
    var index = 0
    var didDelete: Action?
    var height: CGFloat = 36
    
    var answer: FLAnswerResult?
    
    var choice: FLChoiceResult? {
        didSet {
            guard let choice = self.choice else { return }
            self.checkButton.choice = choice
            self.checkButton.choiceView = self
            self.fieldButton.choice = choice
            self.fieldButton.choiceView = self
            self.textView.text = choice.value
            
            //self.textView.placeholder = choice.value
            self.updateUI()
            
        }
    }
    
    func updateUI() {
        guard let choice = self.choice else { return }
        if self.isEditor {
            self.updateStyleEdit(choice.isAnswer)
        } else {
            self.updateStyleUser(self.answer, choice: choice)
        }
    }
    
    func updateStyleFalse() {
        self.backgroundColor = .error()
        self.checkButton.setImage(UIImage(named: "ic_v2_close"), for: .normal)
        self.checkButton.tintColor = .error()
        self.checkButton.backgroundColor = .light()
        self.textView.textColor = .white
    }
    
    func updateStyleTrue() {
        self.backgroundColor = .success()
        self.checkButton.setImage(UIImage(named: "ic_v2_check"), for: .normal)
        self.checkButton.tintColor = .success()
        self.checkButton.backgroundColor = .light()
        self.textView.textColor = .white
    }
    
    func updateStyleNone() {
        self.backgroundColor = UIColor("F8F8F8")
        self.checkButton.setImage(nil, for: .normal)
        self.checkButton.tintColor = UIColor("F8F8F8")
        self.checkButton.backgroundColor = .disable()
        self.textView.textColor = .text50()
    }
    
    func updateStyleUser(_ answer: FLAnswerResult?, choice: FLChoiceResult) {
        if let userAnswer = answer {
            if choice.isAnswer {
                self.updateStyleTrue()
            } else {
                print("choice: \(choice.id)")
                //not ans isAnswer == false
                if userAnswer.choiceId == choice.id {
                    self.updateStyleFalse()
                } else {
                    self.updateStyleNone()
                }
            }
            self.isUserInteractionEnabled = false
        } else {//no ans
            self.updateStyleNone()
        }
        
    }
    
    func updateStyleEdit(_ isAnswer: Bool) {
        if isAnswer {
            self.updateStyleTrue()
        } else {
            self.updateStyleNone()
        }
    }
    
    @IBAction func checkPressed(_ sender: UIButton) {
        guard let choice = self.choice else { return }
        if self.isEditor {
            if !choice.isAnswer {
                choice.isAnswer = true
            }
        }
    }
    
    override func awakeFromNib() {
        self.cornerRadius = 8
        self.textView.maxHeight = 60
        self.textView.maxLength = FlashStyle.maxCharChoice
        self.textView.minHeight = self.contentHeight.constant//36
        self.textView.placeholderColor = .text50()
        self.textView.text = ""
    }
    
    class func instanciateFromNib() -> FLChoiceView {
        return Bundle.main.loadNibNamed("FLChoiceView", owner: nil, options: nil)![0] as! FLChoiceView
    }
}

extension FLChoiceView: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        ConsoleLog.show("FLChoiceView GrowingTextView height:\(height)")
        self.contentHeight.constant = height
        self.height = height
        self.checkButton.updateLayout()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        ConsoleLog.show("FLChoiceView textViewDidBeginEditing")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        ConsoleLog.show("FLChoiceView textViewDidBeginEditing")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count <= FlashStyle.maxCharChoice {
            self.choice?.value = textView.text
            self.textView.updateLayout()
            ConsoleLog.show("FLChoiceView textViewDidChange: \(textView.text.count)")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.textView.isPastingContent {
            self.textView.isPastingContent = false
            ConsoleLog.show("paste")
            DispatchQueue.main.async {
                self.textView.updateLayout()
            }
            return true
        } else if text == "\n" {
            textView.resignFirstResponder()
            return false
            
        } else if text == "", textView.text.isEmpty {
            textView.resignFirstResponder()
            self.didDelete?.handler(self)
            return false
        }
        return true
    }
    
}
