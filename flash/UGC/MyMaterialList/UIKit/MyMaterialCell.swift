//
//  MyMaterialCell.swift
//  flash
//
//  Created by Songwut Maneefun on 1/12/2564 BE.
//

import UIKit
import SwiftUI

class MyMaterialCell: BaseCollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var previewButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    
    @IBOutlet private weak var statusPublicView: UIView!
    @IBOutlet private weak var statusPublicLabel: UILabel!
    @IBOutlet private weak var statusPublicIcon: UIImageView!
    
    @IBOutlet private weak var statusRequestView: UIView!
    @IBOutlet private weak var statusRequestLabel: UILabel!
    @IBOutlet private weak var statusRequestIcon: UIImageView!
    
    @IBOutlet private weak var constraintWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var materialView: UIView!
    
    private var myMaterialView: MyMaterialView?
    
    var didPreview: Action?
    var didEdit: Action?
    var size: CGSize = .zero {
        didSet {
            self.constraintWidth.constant = self.size.width
            self.constraintHeight.constant = self.size.height
        }
    }
    
    override func setData(_ data: Any?) {
        if let item = data as? LMMaterialResult {
            self.dateLabel.text = "edited".localized() + ": " + item.datetimeAgo
            self.titleLabel.text = item.nameContent
            self.previewButton.isHidden = !item.isShowPreview()
            self.statusPublicIcon.backgroundColor = item.displayStatus.color()
            self.statusRequestIcon.backgroundColor = item.requestStatus.color()
            self.statusPublicLabel .text = "status".localized() + ": " + item.displayStatus.title()
            if let requestStatusText = item.requestStatus.title() {
                self.statusRequestLabel.text = "request_status".localized() + ": " + requestStatusText
                self.statusRequestView.isHidden = false
            } else {
                self.statusRequestView.isHidden = true
            }
            
            self.imageView.setImage(item.image, placeholderImage: defaultImage) { img in
                if let hexBgColor = item.hexBgColor {
                    self.imageView.backgroundColor = UIColor(hexBgColor)
                } else {
                    DispatchQueue.main.async {
                        let imageColor = img.averageColor ?? UIColor("FFFFFF")
                        self.imageView.backgroundColor = imageColor
                        item.hexBgColor = imageColor.hexString()
                    }
                    
                }
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.previewButton.imageView?.contentMode = .scaleAspectFit
        self.editButton.imageView?.contentMode = .scaleAspectFit
        self.previewButton.setTitle("", for: .normal)
        self.editButton.setTitle("", for: .normal)
        self.previewButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.editButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.editPressed))
        self.materialView.addGestureRecognizer(tap)
        
        let lineColor = UIColor("EEEEEE")
        self.previewButton.layer.addBorder(edge: [.left], color: lineColor, weight: 1)
        self.editButton.layer.addBorder(edge: [.left], color: lineColor, weight: 1)
        self.previewButton.addTarget(self, action: #selector(self.previewPressed), for: .touchUpInside)
        self.editButton.addTarget(self, action: #selector(self.editPressed), for: .touchUpInside)
        
        self.dateLabel.textColor = UIColor("A9A9A9")
        self.titleLabel.textColor = .black
        self.titleLabel.font = .font(12, .medium)
        self.dateLabel.font = .font(10, .regular)
        self.statusPublicLabel.font = .font(10, .regular)
        self.statusRequestLabel.font = .font(10, .regular)
    }
    
    @objc func previewPressed() {
        self.didPreview?.handler(nil)
    }
    
    @objc func editPressed() {
        self.didEdit?.handler(nil)
    }

}
