//
//  MyMaterialView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyMaterialView: View {
    @Binding var selectedItem: LMMaterialResult?
    @Binding var isPreviewItem: Bool
    @Binding var isEditItem: Bool
    
    @State var isEditor: Bool
    @State var item: LMMaterialResult
    @State var image: UIImage = UIImage()
    @State var imageColor = Color.white
    
    private let timeFont: Font = .font(10, .text)
    private let nameFont: Font = .font(14, .medium)
    private let statusFont: Font = .font(12, .medium)
    private let placeholder = defaultImage ?? UIImage()
    
    var body: some View {
        VStack {
            self.contentView
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("EEEEEE"), lineWidth: 1.0)
                )
            
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            HStack(spacing:0) {
                VStack(spacing: 0) {
                    ImageView
                        .frame(
                            width: UIDevice.isIpad() ? 150 : 120,
                            height: FlashStyle.flashItemHeight,
                            alignment: .center
                        )
                        .background(imageColor)
                }
                
                VStack(spacing: 0) {
                    InfoView
                        .frame(maxHeight: FlashStyle.flashItemHeight, alignment: .leading)
                }
            }
            .background(Color.clear)
        })
        .background(Color.clear)
        .cornerRadius(20)
        .onAppear(perform: {
            if let hexBgColor = item.hexBgColor {
                imageColor = Color(hexBgColor)
            } else {
                let uiColor = placeholder.averageColor ?? . white
                imageColor = uiColor.color
                item.hexBgColor = uiColor.hexString()
            }
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
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                
                Divider()
                    .foregroundColor(Color("EEEEEE"))
                
                if self.item.isShowPreview() {
                    self.previewIcon
                        .frame(width: 32)
                    
                    Divider()
                        .foregroundColor(Color("EEEEEE"))
                }
                
                if isEditor {
                    self.editIcon
                        .frame(width: 32)
                }
            }
            .frame(height: 32)
            .padding([.trailing], 8)
            
            Divider()
                .foregroundColor(Color("EEEEEE"))
            
            Text(self.item.editedDatetime())
                .font(.font(10, .regular))
                .foregroundColor(Color("A9A9A9"))
                .lineLimit(1)
                .padding([.leading], 8)
            /*
            HStack(spacing: 4) {
                Image("outline")
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(Color("A9A9A9"))
                
                Text(item.datetimeAgo)
                    .font(timeFont)
                    .foregroundColor(.black)
            }
            .frame(height: 20)
            .padding([.leading], 8)
            */
            
            Text(item.nameContent)
                .font(nameFont)
                .foregroundColor(.black)
                .lineLimit(2)
                .padding([.leading], 8)
            
            PublicStatusView
                .frame(height: 20)
                .padding([.leading], 8)
            
            if item.requestStatus != .none {
                RequestStatusView
                    .frame(height: 20)
                    .padding([.leading], 8)
            }
            Spacer()
        }
    }
    
    var PublicStatusView: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(item.displayStatus.color().color)
                .frame(width: 7, height: 7)
            Text("\("status".localized()): \(item.displayStatus.title())")
                .font(.font(10, .medium))
                .foregroundColor(.black)
        }
    }
    
    var RequestStatusView: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(item.requestStatus.color().color)
                .frame(width: 7, height: 7)
            Text("\("request_status".localized()): \(item.requestStatus.title() ?? "")")
                .font(.font(10, .medium))
                .foregroundColor(.black)
        }
    }
    
    var RequestStatusViewOld: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: nil, content: {
                let textColor = item.requestStatus.color().color
                let bgColor = item.requestStatus.bgColor().color
                ZStack(alignment: .center, content: {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(bgColor)
                        .frame(height: 24)
                    
                    Text(item.requestStatus.title() ?? "")
                        .font(.font(10, .medium))
                        .foregroundColor(textColor)
                        .padding(.all, 8)
                })
            })
            .fixedSize()
            
            Spacer()
        }
    }
    
    var editIcon: some View {
        Button {
            self.selectedItem = self.item
            self.isEditItem.toggle()
        } label: {
            Image("edit")
                .resizable()
                .frame(width: 14, height: 14, alignment: .center)
                .foregroundColor(Color("A9A9A9"))
        }
        .frame(width: 32, height: 32, alignment: .center)
    }
    
    var previewIcon: some View {
        Button {
            self.selectedItem = self.item
            self.isPreviewItem.toggle()
        } label: {
            Image("ic_v2_preview")
                .resizable()
                .frame(width: 16, height: 16, alignment: .center)
                .foregroundColor(Color("A9A9A9"))
        }
        .frame(width: 32, height: 32, alignment: .center)
    }
}

struct MyMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        MyMaterialView(selectedItem: .constant(nil),
                       isPreviewItem: .constant(false),
                       isEditItem: .constant(false),
                       isEditor: true,
                       item: MockObject.materialFlash)
            .previewLayout(.fixed(width: 300, height: 200))
            .environment(\.sizeCategory, .small)
    }
}
