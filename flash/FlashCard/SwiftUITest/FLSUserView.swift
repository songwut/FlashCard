//
//  FLSUserView.swift
//  flash
//
//  Created by Songwut Maneefun on 6/10/2564 BE.
//

import SwiftUI

struct FLSUserView: View {
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var user: ContentResult
    @State var image: UIImage = UIImage()
    
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            HStack(alignment: .center, spacing: 8, content: {
                Image(uiImage: self.image)
                    .resizable()
                    .padding(.all, 0)
                    .frame(maxWidth: 32, maxHeight: 32, alignment: .center)
                    .cornerRadius(16)
                    .onReceive(imageLoader.$image, perform: { image in
                        self.image = image
                    })
                    .onAppear(perform: {
                        imageLoader.loadImage(for: user.image)
                    })
                
                Text(user.name)
                    .font(.getFontSystem(13, font: .text))
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding([.leading], 16)
        })
        
    }
}

struct FLSUserView_Previews: PreviewProvider {
    static var previews: some View {
        let user = ContentResult(JSON: ["name" : "Tar", "image": "https://cdn-icons-png.flaticon.com/512/149/149071.png"])!
        FLSUserView(user: user)
            .previewLayout(.fixed(width: 250, height: 44))
            .environment(\.sizeCategory, .small)
    }
}
