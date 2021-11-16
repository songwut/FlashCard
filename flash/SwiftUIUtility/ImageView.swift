//
//  ImageView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var image: UIImage = UIImage()
    var url: String
    var mode: ContentMode = .fit
    var placeholder: UIImage = defaultImage ?? UIImage()
    
    var body: some View {
        GeometryReader(content: { geometry in
             VStack(alignment: .center, spacing: nil, content: {
                WebImage(url: URL(string: url))
                    .placeholder(
                        Image(uiImage: placeholder)
                            .resizable()
                    )
                    .resizable()
                    .aspectRatio(contentMode: mode)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                
                /*
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                    .onReceive(imageLoader.$image, perform: { image in
                        self.image = image
                    })
                    .onAppear(perform: {
                        //loading image need improve
                        imageLoader.loadImage(for: url)
                    })
                */
             })
        })
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        let urlString = "https://develop.conicle.co/media/flash_card/2021/11/af816fb9-2ed.png"
        ImageView(url: urlString, placeholder: defaultImage!)
            .previewLayout(.fixed(width: 200.0, height: 300))
            .environment(\.sizeCategory, .small)
    }
}
