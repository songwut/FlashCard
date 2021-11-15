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
    
    var body: some View {
        GeometryReader(content: { geometry in
            ImageView(url: url, placeholder: defaultImage ?? UIImage())
                .frame(width: geometry.size.width)
                //.frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
        })
    }
}

struct FLCoverView_Previews: PreviewProvider {
    static var previews: some View {
        let url = "https://develop.conicle.co/media/flash_card/2021/11/af816fb9-2ed.png"
        FLCoverView(url: url)
            .previewLayout(.fixed(width: 200.0, height: 300))
            .environment(\.sizeCategory, .small)
    }
}
