//
//  ImageView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var image: UIImage = UIImage()
    var url: String
    var placeholder: UIImage = defaultImage ?? UIImage()
    
    var body: some View {
        GeometryReader(content: { geometry in
             VStack(alignment: .center, spacing: nil, content: {
                Image(uiImage: self.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                    .onReceive(imageLoader.$image, perform: { image in
                        self.image = image
                    })
                    .onAppear(perform: {
                        imageLoader.loadImage(for: url)
                    })
             })
        })
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        let urlString = "https://develop.conicle.co/media/flash_card/2021/10/4eaf90d4-528.png"
        ImageView(url: urlString, placeholder: defaultImage!)
            .previewLayout(.fixed(width: 200.0, height: 300))
            .environment(\.sizeCategory, .small)
    }
}
