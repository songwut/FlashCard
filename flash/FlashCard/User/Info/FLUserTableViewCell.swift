//
//  FLUserTableViewCell.swift
//  flash
//
//  Created by Songwut Maneefun on 29/9/2564 BE.
//

import UIKit

class FLUserTableViewCell: UITableViewCell {
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    class func height() -> CGFloat {
        return FlashStyle.quiz.userMinHeight + FlashStyle.quiz.userSpacing
    }

    var user: UserAnswerResult? {
        didSet {
            self.cellHeight.constant = FlashStyle.quiz.userMinHeight
            self.userImageView.updateLayout()
            self.userImageView.cornerRadius = self.userImageView.frame.width / 2
            self.userImageView.clipsToBounds = true
            self.userImageView.layer.masksToBounds = true
            guard let user = self.user else {  return }
            self.userImageView.setImage(user.image, placeholderImage: defaultUserImage)
            self.titleLabel.text = user.name
            if let ans = user.answer {
                self.descLabel.text = ans.value
            } else {
                self.descLabel.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.masksToBounds = true
        let w = FlashStyle.quiz.userMinHeight - FlashStyle.quiz.userSpacing
        self.userImageView.cornerRadius = w / 2
        self.titleLabel.font = .font(UIDevice.isIpad() ? 22 : 12, font: .medium)
        self.descLabel.font = .font(UIDevice.isIpad() ? 18 : 10, font: .text)
        self.titleLabel.textColor = UIColor("222831")
        self.descLabel.textColor = .text50()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
