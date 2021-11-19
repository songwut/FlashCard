//
//  MyMaterialView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI

//== LearningMaterialResult // == MaterialFlashResult

struct MyMaterialView: View {
    @State var isEditor: Bool
    @State var item: LMMaterialResult
    @State var image: UIImage = UIImage()
    @State var imageColor = Color.white
    @ObservedObject var imageLoader = ImageLoaderService()
    
    private let timeFont: Font = .font(10, .text)
    private let nameFont: Font = .font(14, .medium)
    private let statusFont: Font = .font(12, .medium)
    private let placeholder = defaultImage ?? UIImage()
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            HStack(spacing:8) {
                //WebImage(url: URL(string: item.image))
                ImageView
                    .frame(maxWidth: FlashStyle.flashItemHeight, maxHeight: .infinity, alignment: .leading)
                    .background(imageColor)
                    .clipped()
                    .cornerRadius(8)
                    
                //.frame(width: FlashStyle.flashItemHeight)
                    //.onSuccess
//                ImageView(url: item.image)
//                    .frame(width: FlashStyle.flashItemHeight)
//                    .clipped()
//                    .cornerRadius(8)
                
                InfoView
                Spacer()
                VStack(spacing: 0) {
                    if isEditor {
                        EditButton
                    } else {
                        IconView
                    }
                    Spacer()
                }
                .frame(width: 25)
            }
            .background(Color.clear)
        })
        .background(Color.clear)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .onAppear(perform: {
            imageColor =  placeholder.averageColor?.color ?? .white
        })
    }
    
    var ImageView: some View {
        VStack(alignment: .leading, spacing: 0) {
            WebImage(url: URL(string: item.image))
                .onSuccess { image, cacheType, _  in
                    DispatchQueue.main.async {
                        self.image = image
                        self.imageColor = self.image.averageColor?.color ?? .white
                    }
                }
                .placeholder(
                    Image(uiImage: placeholder)
                        .resizable()
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    var InfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack(spacing: 4) {
                Image("outline")
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(Color("A9A9A9"))
                let timeText = item.datetimeCreate.dateTimeAgo()
                Text(timeText)
                    .font(timeFont)
                    .foregroundColor(.black)
            }
            .frame(height: 20)
            
            Text(item.nameContent)
                .font(nameFont)
                .foregroundColor(.black)
            
            if let owner = item.owner {
                Text("\("by".localized()) \(owner.name)")
                    .font(timeFont)
                    .foregroundColor(.black)
                    .frame(height: 20)
            }
            
            
            PublicStatusView
                .frame(height: 20)
            
            if item.requestStatus != .none {
                RequestStatusView
                    .frame(height: 20)
            }
            Spacer()
        }
        .padding(.top, 8)
    }
    
    var PublicStatusView: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(item.displayStatus.color().color)
                .frame(width: 7, height: 7)
            Text(item.displayStatus.title())
                .font(statusFont)
                .foregroundColor(.black)
        }
    }
    
    var RequestStatusView: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: nil, content: {
                let textColor = item.requestStatus.color().color
                let bgColor = item.requestStatus.bgColor().color
                Text(item.requestStatus.title())
                    .font(statusFont)
                    .foregroundColor(textColor)
                    .background(bgColor)
            })
            Spacer()
        }
    }
    
    var EditButton: some View {
        Button(action: {
            
        }, label: {
            Image("edit")
                .resizable()
                .padding(.all, 2)
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(Color("A9A9A9"))
            
        })
    }
    
    var IconView: some View {
        ZStack(alignment: .center, content: {
            Circle()
                .fill(Color("4782DA"))
            Image("ic_v2_flashcard")
                .resizable()
                .frame(width: 11, height: 11, alignment: .center)
                .foregroundColor(.white)
        })
        .frame(width: 20, height: 20, alignment: .center)
    }
}

struct MyMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        MyMaterialView(isEditor: true, item: MockObject.materialFlash)
            .previewLayout(.fixed(width: 300, height: 120))
            .environment(\.sizeCategory, .small)
    }
}
