//
//  UIImageView.swift
//  flash
//
//  Created by Songwut Maneefun on 20/7/2564 BE.
//

import UIKit
import Alamofire
import SDWebImage

extension UIImageView {
    
    func setTintWith(color: UIColor) {
        if let _ = self.image {
            self.image? = (self.image?.withRenderingMode(.alwaysTemplate))!
            self.tintColor = color
        }
    }
    
    public func imageUrl(_ urlString: String, placeholderImage: UIImage? = nil) {
        self.image = placeholderImage
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            task.resume()
        }
    }
    
    func setImage(_ urlString: String, placeholderImage: UIImage?, completion :((_ image: UIImage) -> Void)? = nil) {
        
        guard let url = URL(string: urlString) else {
            self.image = placeholderImage
            return
        }
        
        self.sd_setImage(with: url, placeholderImage: placeholderImage, progress: { (receivedSize, expectedSize, url) in
            
        }) { (image, error, type, url) in
            if let img = image {
                completion?(img)
            }
        }
    }
    
}
