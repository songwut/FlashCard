//
//  FLImageCell.swift
//  flash
//
//  Created by Songwut Maneefun on 6/8/2564 BE.
//

import UIKit

final class FLImageCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    var imageBase64: String? {
        didSet {
            guard let base64Str = self.imageBase64 else { return }
            if let date = Data(base64Encoded: base64Str) {
                self.imageView.image = UIImage(data: date)
            }
            
        }
    }

}
