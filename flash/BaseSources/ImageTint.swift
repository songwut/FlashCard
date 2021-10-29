//
//  ImageTint.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import UIKit

class ImageTint {

    var image: UIImage?
    var tintColor: UIColor?
    var size:CGFloat = 60
    
    init(image: UIImage?, color: UIColor) {
        self.image = image
        self.tintColor = color
    }
}
