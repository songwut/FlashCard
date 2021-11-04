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
    
    var item: Any? {
        didSet {
            if let _ = self.item as? FLNewResult  {
                self.addNewUI()
                
            } else if let flItem = self.item as? FLCardPageResult {
                self.imageView.imageUrl(flItem.image)
                self.imageView.isHidden = false
                self.cardView.isHidden = true
                print("self.imageView:\(self.imageView.frame.size)")
                self.selectView.isHidden = !self.isSelected
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
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.image = defaultImage
        self.addLabel.text = "+ Add Card"
        self.addLabel.font = .font(14, .medium)
        self.addLabel.textColor = .text75()
        self.imageView.cornerRadius = 8
        self.imageView.clipsToBounds = true
        self.imageView.backgroundColor = .white
        
        self.cardView.cornerRadius = 8
        self.cardView.clipsToBounds = true
        self.cardView.backgroundColor = .clear
        self.cardView.dashColor = UIColor("7D7D7D")
        self.cardView.lineDash = [8, 8]
        self.cardView.dashBorderWidth = 1
        
        self.selectView.borderColor = UIColor("E7000A")
        self.selectView.borderWidth = 2
        self.selectView.cornerRadius = 8
        self.selectView.backgroundColor = .clear
    }

}
