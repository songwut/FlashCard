//
//  FLMaterialView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI

struct FLMaterialView: View {
    @State var isEditor: Bool
    @State var flash: MaterialFlashResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            HStack(spacing:8) {
                coverView
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
    
    var coverView: some View {
        VStack(spacing: 0) {
            ZStack {
                let img = UIImage(named: "coverItem")
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(img?.averageColor?.color ?? .black)
                    .aspectRatio(1.0, contentMode: .fit)
                Image(uiImage: img ?? UIImage())
                    //.frame(height: .infinity, alignment: .center)
            }
        }
        .clipped()
    }
    
    var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            let timeFont = FontHelper.getFontSystem(10, font: .text).font
            let nameFont = FontHelper.getFontSystem(14, font: .medium).font
            let statusFont = FontHelper.getFontSystem(12, font: .medium).font
            HStack(spacing: 4) {
                Image("outline")
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(Color("A9A9A9"))
                Text("2 mins ago")
                    .font(timeFont)
            }
            Text(flash.name)
                .font(nameFont)
            if let owner = flash.owner {
                Text("\("by".localized()) \(owner.name)")
                    .font(timeFont)
            }
            HStack(spacing: 4) {
                Circle()
                    .fill(flash.status.color().color)
                    .frame(width: 7, height: 7)
                Text(flash.status.title())
                    .font(statusFont)
            }
            Spacer()
        }
        .padding(.top, 8)
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
        let flash = MaterialFlashResult(JSON: ["name": "10 Figma Tricks I Wish I Knew Earlier"])!
        FLMaterialView(isEditor: true, flash: flash)
            .previewLayout(.fixed(width: 400.0, height: 124))
            .environment(\.sizeCategory, .small)
    }
}
