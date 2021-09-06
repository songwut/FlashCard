//
//  FLChoiceView.swift
//  flash
//
//  Created by Songwut Maneefun on 16/8/2564 BE.
//

import UIKit
import GrowingTextView

final class FLChoiceView: UIView {
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var checkButton: UIButton!
    
    var isCreate = false
    var index = 0
    var didDelete:DidAction?
    
    var choice: FLChoiceResult? {
        didSet {
            guard let choice = self.choice else { return }
            self.textView.text = choice.value
            //self.textView.placeholder = choice.value
            self.updateStyle(choice.isAnswer ?? false)
        }
    }
    
    func updateStyle(_ isAnswer: Bool) {
        let bgColor: UIColor = isAnswer ? ColorHelper.success() : UIColor("F8F8F8")
        self.backgroundColor = bgColor
        let icon: UIImage? = isAnswer ? UIImage(named: "ic_v2_check") : nil
        let iconBgColor = isAnswer ? ColorHelper.light() : ColorHelper.disable()
        let textColor = isAnswer ?.white : ColorHelper.text50()
        self.checkButton.setImage(icon, for: .normal)
        self.checkButton.tintColor = bgColor
        self.checkButton.backgroundColor = iconBgColor
        self.textView.textColor = textColor
        
    }
    
    @IBAction func checkPressed(_ sender: UIButton) {
        guard let choice = self.choice else { return }
        if let isAnswer = choice.isAnswer {
            choice.isAnswer = !isAnswer
        } else {
            choice.isAnswer = true
        }
    }
    
    override func awakeFromNib() {
        self.cornerRadius = 8
        self.textView.maxHeight = 60
        self.textView.maxLength = FlashStyle.maxCharChoice
        self.textView.minHeight = self.contentHeight.constant//36
        self.textView.placeholderColor = ColorHelper.text50()
        self.textView.text = ""
    }
    
    class func instanciateFromNib() -> FLChoiceView {
        return Bundle.main.loadNibNamed("FLChoiceView", owner: nil, options: nil)![0] as! FLChoiceView
    }
}

extension FLChoiceView: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        ConsoleLog.show("FLChoiceView GrowingTextView height:\(height)")
        //self.textView.superview?.layoutIfNeeded()
        self.contentHeight.constant = height
        self.checkButton.updateLayout()
        //ConsoleLog.show("GrowingTextView height:\(self.vie)")
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
        if text == "\n" {
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
