//
//  FLChoiceView.swift
//  flash
//
//  Created by Songwut Maneefun on 16/8/2564 BE.
//

import UIKit
import GrowingTextView

final class FLChoiceView: UIView {
    
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var checkButton: UIButton!
    
    var isCreate = false
    
    var choice: FLChoiceResult? {
        didSet {
            guard let choice = self.choice else { return }
            self.textView.text = choice.value
            self.textView.placeholder = choice.value
            self.updateStyle(choice.isAnswer ?? false)
            self.textView.delegate = self
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
        self.textView.placeholderColor = ColorHelper.text50()
        self.cornerRadius = 8
    }
    
    @IBAction func checkPressed(_ sender: UIButton) {
        guard let choice = self.choice else { return }
        if let isAnswer = choice.isAnswer {
            choice.isAnswer = !isAnswer
        } else {
            choice.isAnswer = true
        }
    }
    
    class func instanciateFromNib() -> FLChoiceView {
        return Bundle.main.loadNibNamed("FLChoiceView", owner: nil, options: nil)![0] as! FLChoiceView
    }
}

extension FLChoiceView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.choice?.value = textView.text
        self.textView.superview?.layoutIfNeeded()
    }
    
}
