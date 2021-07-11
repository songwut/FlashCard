//
//  FLColorCell.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import UIKit

final class FLColorCell: UICollectionViewCell {

    @IBOutlet private weak var colorView: UIView!
    
    var colorHex: String? {
        didSet {
            guard let colorHex = self.colorHex else { return }
            self.colorView.backgroundColor = UIColor(colorHex)
            self.colorView.updateLayout()
            let width = self.colorView.bounds.width
            self.colorView.cornerRadius = width / 2
            self.colorView.borderWidth = 1
            self.colorView.borderColor = UIColor("A9A9A9")
                
            self.contentView.updateLayout()
            let cellWidth = self.contentView.bounds.width
            self.contentView.cornerRadius = cellWidth / 2
            self.contentView.borderWidth = self.isSelected ? 2 : 0
            self.contentView.borderColor = .black
            self.colorView.clipsToBounds = true
        }
    }

}
