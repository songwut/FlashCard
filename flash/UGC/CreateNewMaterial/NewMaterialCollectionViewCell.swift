//
//  NewMaterialCollectionViewCell.swift
//  flash
//
//  Created by Songwut Maneefun on 29/11/2564 BE.
//

import UIKit
import SwiftUI

class NewMaterialCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var shadowLabel: UILabel!
    
    @IBOutlet weak var contentWidth: NSLayoutConstraint!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    private var newMaterialView: NewMaterialView?
    
    var cellSize:CGSize = .zero {
        didSet {
            self.contentWidth.constant = cellSize.width
            self.contentHeight.constant = cellSize.height
        }
    }
    
    var item: LMCreateItem? {
        didSet {
            self.contentView.updateLayout()
            self.contentView.cornerRadius = 8
            self.contentView.clipsToBounds = true
            
            if let item = self.item {
                
                self.titleLabel.text = item.name.localized()
                self.imageView.setImage(item.image, placeholderImage: defaultImage)
                self.shadowView.isHidden = item.isReady
                
                print("contentView.frame: \(self.contentView.frame)")
//                self.newMaterialView = NewMaterialView(item: item)
//                let childView = UIHostingController(rootView: self.newMaterialView!)
                
//                childView.view.bounds = CGRect(x: 0, y: 0, width: self.cellSize.width, height: self.cellSize.height)
//                childView.view.translatesAutoresizingMaskIntoConstraints = false
//               self.stackView.addArrangedSubview(childView.view)
                //self.contentView.addConstrained(childView.view)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.updateLayout()
        self.shadowView.backgroundColor = UIColor("222831").withAlphaComponent(0.9)
        self.titleLabel.font = .font(16, .medium)
        self.shadowLabel.font = .font(16, .medium)
        self.titleLabel.textColor = .white
        self.shadowLabel.textColor = .white
        self.shadowLabel.text = "Coming Soon..."
    }

}
