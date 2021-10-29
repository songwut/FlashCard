//
//  FLImageElementView.swift
//  flash
//
//  Created by Songwut Maneefun on 29/10/2564 BE.
//

import SwiftUI

struct FLImageElementView: View {
    var element: FlashElement
    
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var image: UIImage = UIImage()
    
    @State private var isLoadedImage = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack(spacing: 0) {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .onReceive(imageLoader.$image, perform: { image in
                            self.image = image
                            self.isLoadedImage = true
                        })
                        .onAppear(perform: {
                            if let urlStr = element.src {
                                imageLoader.loadImage(for: urlStr)
                            }
                            
                        })
                }
            }
        })
    }
    
}

struct FLSticker: ViewModifier {
    var element: FlashElement
    var stageSize: CGSize
    
    func body(content: Content) -> some View {
        content
            .position(
                x: element.offsetX(on: stageSize.width),
                y: element.offsetY(on: stageSize.height)
            )
            .frame(width: element.width(on: stageSize.width), height: element.height(on: stageSize.height), alignment: .center)
            .rotationEffect(.degrees(element.rotation?.doubleValue ?? 0))
    }
}

struct FLImageElementView_Previews: PreviewProvider {
    static var previews: some View {
        FLImageElementView(element: MockObject.stickerElement)
            .previewLayout(.fixed(width: 200, height: 200))
            .environment(\.sizeCategory, .small)
    }
}
