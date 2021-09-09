//
//  UGCCategoryRow.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import SwiftUI

struct UGCCategoryRow: View {
    @State var isChecked: Bool = false
    @State var isExpaned: Bool = false
    @State var category: CategoryResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            
            self.contentView
            
            let childList = self.category.childList
            if childList.count >= 1 {
                if self.isExpaned {
                    ForEach(0..<childList.count) { i in
                        UGCCategoryRow(category: childList[i])
                            .padding(.leading, 16)
                    }
                }
            }
            
        })
    }
    
    var contentView: some View {
        HStack {
            //arrow
            let iconName = self.isExpaned ? "ic_v2_chevron-down" : "ic_v2_chevron-right"
            if self.category.childList.count >= 1 {
                Button(action: {
                    self.isExpaned = !self.isExpaned
                }, label: {
                    Image(iconName)
                        .foregroundColor(ColorHelper.secondary50().color)
                        .frame(width: 16, height: 16, alignment: .center)
                })
            } else {
                Spacer()
                    .frame(width: 24)
            }
            
            //check
            let bgColor: Color = self.isChecked ? ColorHelper.primary().color : .white
            let borderColor: Color = self.isChecked ? ColorHelper.primary().color : .gray
            Button(action: {
                self.isChecked = !self.isChecked
            }, label: {
                if isChecked {
                    Image("ic_v2_check")
                        .resizable()
                        .padding(0)
                        .frame(width: 12.0, height: 12.0)
                    
                } else {
                    Image(systemName: "square")
                }
                
            })
            .frame(width: 18, height: 18, alignment: .center)
            .foregroundColor(.white)
            .background(bgColor)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(borderColor, lineWidth: 1)
            )
            
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .foregroundColor(.black)
                    .font(FontHelper.getFontSystem(.paragraph, font: .text).font)
            }
            Spacer()
        }
    }
}

struct UGCCategoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        let name = "Cat name sdf  sfsd fdsf sedfsafsfdssf fd fsf sdf  dsf dsfcdfdfdsfs ds dsfdfdfsf dfs"
        let chlidList = "{\"id\":92,\"name\":\"Category Course LC1\",\"child_list\":[{\"id\":93,\"name\":\"Category Course LC2\",\"child_list\":[{\"id\":94,\"name\":\"Category Course LC3\",\"child_list\":[{\"id\":95,\"name\":\"Category Course LC4\",\"child_list\":null}]}]}]}"
        let c = UGCCategory(JSON: ["name1" : name, "child_list": chlidList])!
        UGCCategoryRow(category: c)
            .previewLayout(.fixed(width: 300.0, height: 60))
            .environment(\.sizeCategory, .small)
    }
}
