//
//  UGCCoverItemView.swift
//  UGC
//
//  Created by Songwut Maneefun on 2/3/2565 BE.
//

import SwiftUI

struct UGCCoverItemView: View {
    //var isSelected = false
    @State var item: UGCCoverModel
    
    var body: some View {
        if let imageStr = self.item.image {
            ZStack {
                ImageView(url: imageStr,
                          mode: .fill, placeholder: defaultImage!)
                
                if self.item.isSelected {
                    selectedView
                        .position(x: 16, y: 16)
                }
            }
               
        } else if let uiimage = self.item.uiimage {
            ZStack {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                selectedView
                    .position(x: 16, y: 16)
            }
               
        } else {
            ZStack {
                Rectangle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(Color("A9A9A9"))
                    .background(Color("EEEEEE"))
                    .cornerRadius(8)
                VStack {
                    Image(systemName: "photo")
                        .foregroundColor(Color("A9A9A9"))
                        .frame(width: 16, height: 16)
                    Text("Upload Cover")
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                }
                
                if self.item.isSelected {
                    selectedView
                        .position(x: 16, y: 16)
                }
            }

        }
    }
    
    var selectedView: some View {
        HStack(alignment: .top, spacing: 0) {
            Image("check")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 14, height: 14)
                .padding(.all, 2)
                
        }
        .background(Color("E7000A"))
        .clipShape(Circle())
        
    }
}

struct UGCCoverItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        UGCCoverItemView(item: UGCCoverModel(id: nil))
            .previewLayout(.fixed(width: 128, height: 76))
            .environment(\.sizeCategory, .small)
        
        UGCCoverItemView(item: UGCCoverModel(id: nil, image: nil, uiimage: UIImage(named:"IMG Placeholder")))
            .previewLayout(.fixed(width: 128, height: 76))
            .environment(\.sizeCategory, .small)
        
        UGCCoverItemView(item: UGCCoverModel(id: nil, image: "https://release.conicle.co/media/image_video/2022/3/233f259e-a493-4096-b18b-63d63ed01270.jpg"))
            .previewLayout(.fixed(width: 128, height: 76))
            .environment(\.sizeCategory, .small)
    }
}
