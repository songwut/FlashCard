//
//  UGCCategoryRow.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import SwiftUI

protocol UGCCategoryRowDelegate: AnyObject {
    func didSelectCategory(_ category: CategoryResult)
}

//extension UGCCategoryRow {
//
//    func foo(action: @escaping () -> Void ) -> Self {
//         var copy = self
//         copy.selectCategory = action
//         return copy
//     }
//}

struct UGCCategoryRow: View {
    @State var isChecked: Bool = false
    @State var isExpaned: Bool = false
    @State var category: CategoryResult
    
    var isFirst: Bool = true
    
    var delegate: UGCCatagoryListViewDelegate?
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            
            ZStack {
                if isFirst, isExpaned {
                    Rectangle()
                        .fill(ColorHelper.secondary10().color)
                }
                self.contentView
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                
            }
            .frame(height: 42, alignment: .leading)
            
            let childList = self.category.childList
            if childList.count >= 1 {
                if self.isExpaned {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(0..<childList.count) { i in
                            let c = childList[i]
                            UGCCategoryRow(category: c, isFirst: false, delegate: self.delegate)
                                .padding(.leading, 16)
                        }
                    }
                }
            }
            
        })
        .frame(minHeight: 42, alignment: .leading)
    }
    
    var contentView: some View {
        HStack {
            //arrow
            let iconName = self.isExpaned ? "ic_v2_chevron-down" : "ic_v2_chevron-right"
            if self.category.childList.count >= 1 {
                Button(action: {
                    self.isExpaned.toggle()
                }, label: {
                    Image(iconName)
                        .foregroundColor(ColorHelper.secondary50().color)
                        .frame(width: 16, height: 16, alignment: .center)
                })
            } else {
                Spacer()
                    .frame(width: 24)
            }
            
            
            Button(action: {
                self.isChecked.toggle()
                self.delegate?.didSelectCategory(self.category)
            }, label: {
                Image("ic_v2_check")
                    .resizable()
                    .padding(.all, 2)
                    .frame(width: 18, height: 18, alignment: .center)
            })
            .buttonStyle(
                ButtonCheckBox(isChecked: self.isChecked)
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
        let c = UGCCategory(JSON: ["name" : name, "child_list": chlidList])!
        UGCCategoryRow(category: c)
            .previewLayout(.fixed(width: 300.0, height: 60))
            .environment(\.sizeCategory, .small)
    }
}
