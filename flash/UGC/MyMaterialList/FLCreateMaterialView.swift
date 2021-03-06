//
//  FLCreateMaterialView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI

struct FLCreateMaterialView: View {
    var body: some View {
        let color = UIColor.config_primary().color
        ZStack {
            let sStyle = StrokeStyle(lineWidth: 1, dash: [5])
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(UIColor.config_primary_10().color)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(color, style: sStyle)
            VStack {
                let font:Font = .font(14, .text)
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
    }
    
}

struct FLCreateMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        FLCreateMaterialView()
            .previewLayout(.fixed(width: 500.0, height: 124))
            .environment(\.sizeCategory, .small)
    }
}
