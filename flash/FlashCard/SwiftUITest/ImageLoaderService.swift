//
//  ImageLoaderService.swift
//  flash
//
//  Created by Songwut Maneefun on 6/10/2564 BE.
//

import SwiftUI

class ImageLoaderService: ObservableObject {
    @Published var image = UIImage()

    convenience init(url: String) {
        self.init()
        loadImage(for: url)
    }

    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data) ?? UIImage()
            }
        }
        task.resume()
    }
}
