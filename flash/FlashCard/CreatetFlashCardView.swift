//
//  CreatetFlashCardView.swift
//  flash
//
//  Created by Songwut Maneefun on 22/9/2564 BE.
//

import SwiftUI

struct CreatetFlashCardView: View {
    
    @State var item: FLCreateItem
    
    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color("4782DA"))
            VStack(alignment: .center, spacing: nil, content: {
                Image(item.coverName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            })
            
            OverlayView
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        })
        .clipped()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.clear)
    }
    
    var OverlayView: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            if item.isReady {
                Button(action: {
                    
                }, label: {
                    Image("ic_v2_check")
                        .resizable()
                        .padding(.all, 2)
                        .frame(width: 18, height: 18, alignment: .center)
                })
                .buttonStyle(
                    ButtonCheckBox(isChecked: true)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding([.leading, .top], 8)
            }
            
            
            Text(item.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding([.leading, .bottom], 8)
        })
    }
}

struct CreatetFlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        let item = FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true)
        CreatetFlashCardView(item: item)
            .previewLayout(.fixed(width: 164, height: 200))
            .environment(\.sizeCategory, .small)
    }
}
