//
//  FLCoverView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import SwiftUI
import SwURL

struct FLCoverView: View {
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var image: UIImage = UIImage()
    var url: String
    @State private var isLoadedImage = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(self.image.averageColor?.color ?? .white)
                    .aspectRatio(1.0, contentMode: .fit)
                if isLoadedImage {
                    Image("flash-cover")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .onReceive(imageLoader.$image, perform: { image in
                        self.image = image
                        self.isLoadedImage = true
                    })
                    .onAppear(perform: {
                        imageLoader.loadImage(for: url)
                    })
                //Image("flash-cover")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct FLCoverView_Previews: PreviewProvider {
    static var previews: some View {
        let url = "https://png.pngtree.com/background/20210706/original/pngtree-blue-business-technology-products-tenders-album-cover-vector-background-material-picture-image_54688.jpg"
        FLCoverView(url: url)
            .previewLayout(.fixed(width: 200.0, height: 200))
            .environment(\.sizeCategory, .small)
    }
}
