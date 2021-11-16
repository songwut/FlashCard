//
//  NewMaterialView.swift
//  flash
//
//  Created by Songwut Maneefun on 22/9/2564 BE.
//

import SwiftUI

struct NewMaterialView: View {
    
    @State var item: LMCreateItem
    let placeholder = defaultImage ?? UIImage()
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .center, content: {
                VStack(alignment: .center, spacing: nil, content: {
                    ImageView(url: item.image,
                              mode: .fill,
                              placeholder: placeholder)
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .leading)
                })
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .leading)
                
                Text(item.name.localized())
                    .foregroundColor(.white)
                    .font(.font(16, .medium))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding([.leading, .bottom], 8)
                
                if !item.isReady {
                    OverlayView
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                
            })
            .clipped()
            .frame(maxWidth: geometry.size.width,
                   maxHeight: geometry.size.height,
                   alignment: .center)
            .background(Color.clear)
            .cornerRadius(8)
        })
        
    }
    
    var OverlayView: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            ZStack(alignment: .center, content: {
                Rectangle()
                    .foregroundColor(Color("222831").opacity(0.9))
                Text("Coming Soon...")
                    .font(.font(16, .medium))
                    .foregroundColor(.white)
            })
        })
    }
    
    var ContentView: some View {
        VStack(alignment: .leading, spacing: nil, content: {
//            if item.isReady {
//                Button(action: {
//
//                }, label: {
//                    Image("ic_v2_check")
//                        .resizable()
//                        .padding(.all, 2)
//                        .frame(width: 18, height: 18, alignment: .center)
//                })
//                .buttonStyle(
//                    ButtonCheckBox(isChecked: true)
//                )
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                .padding([.leading, .top], 8)
//            }
            
            
            Text(item.name.localized())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding([.leading, .bottom], 8)
        })
    }
}

struct NewMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        NewMaterialView(item: MockObject.createList.first!)
            .previewLayout(.fixed(width: 164, height: 200))
            .environment(\.sizeCategory, .small)
    }
}
