//
//  UIImageView.swift
//  flash
//
//  Created by Songwut Maneefun on 20/7/2564 BE.
//

import UIKit

extension UIImageView {
    
    func setTintWith(color: UIColor) {
        if let _ = self.image {
            self.image? = (self.image?.withRenderingMode(.alwaysTemplate))!
            self.tintColor = color
        }
    }
    
    public func imageFromUrl(_ urlString: String) {
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
    
}
