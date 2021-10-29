//
//  TitleCollectionViewCell.swift
//  LEGO
//
//  Created by Songwut Maneefun on 10/20/17.
//  Copyright © 2017 Conicle. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet var textLabel: UILabel!
    @IBOutlet var contentWidth: NSLayoutConstraint?
    @IBOutlet var contentHeight: NSLayoutConstraint?
    
    var totalText: String! {
        didSet {
            if let totalText = self.totalText {
                self.textLabel.text = totalText
                self.textLabel.numberOfLines = 1
                self.textLabel.textColor = .gray
                self.textLabel.font = FontHelper.getFontSystem(14, font: .regular)
            }
        }
    }
    
    override class func size() -> CGSize {
        return CGSize(width: 375, height: 30)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel.text = ""
    }

}
