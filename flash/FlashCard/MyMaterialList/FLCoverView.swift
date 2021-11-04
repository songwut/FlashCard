//
//  FLCoverView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import SwiftUI

struct FLCoverView: View {
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var image: UIImage = defaultImage ?? UIImage()
    var url: String
    @State private var isLoadedImage = false
    //@State var img: Image
    
    var body: some View {
        GeometryReader(content: { geometry in
            //Image("flash-cover")
            ImageView(url: url)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
                /*
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onReceive(imageLoader.$image, perform: { image in
                    self.image = image
                    self.isLoadedImage = true
                })
                .onAppear(perform: {
                    imageLoader.loadImage(for: url)
                })
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
            */
        })
    }
    
    var ContentImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(self.image.averageColor?.color ?? .white)
                .aspectRatio(1.0, contentMode: .fit)
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onReceive(imageLoader.$image, perform: { image in
                    self.image = image
                    self.isLoadedImage = true
                })
                .onAppear(perform: {
                    imageLoader.loadImage(for: url)
                })
            if isLoadedImage {
//                    Image("flash-cover")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct FLCoverView_Previews: PreviewProvider {
    static var previews: some View {
        let url = "https://png.pngtree.com/background/20210706/original/pngtree-blue-business-technology-products-tenders-album-cover-vector-background-material-picture-image_54688.jpg"
        FLCoverView(url: url)
            .previewLayout(.fixed(width: 200.0, height: 300))
            .environment(\.sizeCategory, .small)
    }
}
