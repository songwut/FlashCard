//
//  FLMaterialView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI
import SwURL

struct FLMaterialView: View {
    @State var isEditor: Bool
    @State var flash: MaterialFlashResult
    @State var image: UIImage?
    @ObservedObject var imageLoader = ImageLoaderService()
    
    private let timeFont: Font = .font(10, font: .text)
    private let nameFont: Font = .font(14, font: .medium)
    private let statusFont: Font = .font(12, font: .medium)
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            HStack(spacing:8) {
                
                FLCoverView(url: flash.image)
                    .frame(width: FlashStyle.flashItemHeight)
                    .clipped()
                
                infoView
                Spacer()
                VStack(spacing: 0) {
                    if isEditor {
                        editButton
                    } else {
                        iconView
                    }
                    Spacer()
                }
                .frame(width: 25)
            }
            .background(Color.clear)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack(spacing: 4) {
                Image("outline")
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(Color("A9A9A9"))
                let timeText = flash.datetimeCreate.dateTimeAgo()
                Text(timeText)
                    .font(timeFont)
                    .foregroundColor(.black)
            }
            .frame(height: 20)
            
            Text(flash.name)
                .font(nameFont)
                .foregroundColor(.black)
            
            if let owner = flash.owner {
                Text("\("by".localized()) \(owner.name)")
                    .font(timeFont)
                    .foregroundColor(.black)
                    .frame(height: 20)
            }
            
            
            PublicStatusView
                .frame(height: 20)
            
            if flash.requestStatus != .none {
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
                .fill(flash.status.color().color)
                .frame(width: 7, height: 7)
            Text(flash.status.title())
                .font(statusFont)
                .foregroundColor(.black)
        }
    }
    
    var RequestStatusView: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: nil, content: {
                let textColor = flash.requestStatus.color().color
                let bgColor = flash.requestStatus.bgColor().color
                Text(flash.requestStatus.title())
                    .font(statusFont)
                    .foregroundColor(textColor)
                    .background(bgColor)
            })
            Spacer()
        }
    }
    
    var editButton: some View {
        Button(action: {
            
        }, label: {
            Image("edit")
                .resizable()
                .padding(.all, 2)
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(Color("A9A9A9"))
            
        })
    }
    
    var iconView: some View {
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

struct FLMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        FLMaterialView(isEditor: true, flash: MockObject.materialFlash)
            .previewLayout(.fixed(width: 400.0, height: 124))
            .environment(\.sizeCategory, .small)
    }
}
