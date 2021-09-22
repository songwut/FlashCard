//
//  FLCreateMaterialView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI

struct FLCreateMaterialView: View {
    var body: some View {
        let color = UIColor.colorConfig.primary().color
        ZStack {
            let sStyle = StrokeStyle(lineWidth: 1, dash: [5])
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(color, style: sStyle)
            VStack {
                let font = FontHelper.getFontSystem(14, font: .text).font
                Image("ic_v2_create")
                    .resizable()
                    .padding(.all, 2)
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(color)
                Text("create_material".localized())
                    .foregroundColor(color)
                    .font(font)
                    .padding(.top, -8)
            }
            
        }
        .background(UIColor.colorConfig.primary10().color)
        
    }
    
}

struct FLCreateMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        FLCreateMaterialView()
            .previewLayout(.fixed(width: 500.0, height: 124))
            .environment(\.sizeCategory, .small)
    }
}
