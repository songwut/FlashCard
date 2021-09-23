//
//  FLItemCollectionViewCell.swift
//  flash
//
//  Created by Songwut Maneefun on 3/7/2564 BE.
//

import UIKit

class FLItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardView: DashBorderView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var addLabel: UILabel!
    
    var isEmpty: Bool = false {
        didSet {
            self.imageView.isHidden = self.isEmpty
        }
    }
    
    var item: FLBaseResult? {
        didSet {
            if let flItem = self.item as? FLItemResult {
                self.imageView.imageUrl(flItem.image)
                self.imageView.isHidden = false
                self.cardView.isHidden = true
                
                self.selectView.isHidden = !self.isSelected
            } else if let _ = self.item as? FLNewResult  {
                self.addNewUI()
            }
            
        }
    }
    
    private func addNewUI() {
        self.cardView.updateLayout()
        print(self.cardView.frame)
        self.selectView.isHidden = true
        self.imageView.isHidden = true
        self.cardView.isHidden = false
    }
    
    override func layoutSubviews() {
        self.cardView.updateLayout()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addLabel.text = "+ Add Card"
        self.addLabel.font = FontHelper.getFontSystem(18, font: .text)
        self.addLabel.textColor = .text75()
        self.imageView.cornerRadius = 8
        self.imageView.clipsToBounds = true
        self.imageView.backgroundColor = .white
        
        self.cardView.cornerRadius = 8
        self.cardView.clipsToBounds = true
        self.cardView.backgroundColor = .clear
        self.cardView.dashColor = UIColor("7D7D7D")
        self.cardView.dashBorderWidth = 1
        
        self.selectView.borderColor = UIColor("E7000A")
        self.selectView.borderWidth = 2
        self.selectView.cornerRadius = 8
        self.selectView.backgroundColor = .clear
    }

}
