//
//  UGCCategoryRow.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import SwiftUI

struct UGCCategoryRow: View {
    @State var refresh: Bool = false
    @State var isChecked: Bool = false
    @State var isExpaned: Bool = false
    @State var category: CategoryResult
    
    var isFirst: Bool = true
    
    var checkPressed: ( _ category: CategoryResult) -> ()?
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            ZStack {
                if isFirst, isExpaned {
                    Rectangle()
                        .fill(Color.config_secondary10())
                }
                ContentView
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
            }
            .frame(height: 42, alignment: .leading)
            
            let childList = category.childList
            if childList.count >= 1 {
                if isExpaned {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(0..<childList.count) { i in
                            let c = childList[i]
                            UGCCategoryRow(category: c, isFirst: false) { c in
                                print("createPressed")
                                self.isChecked = c.isChecked
                                category.isChecked = c.isChecked
                                return checkPressed(category)
                            }
                            .padding(.leading, 16)
                        }
                    }
                }
            }
        })
        .frame(minHeight: 42, alignment: .leading)
        .onAppear(perform: {
            isChecked = category.isChecked
        })
    }
    
    var ContentView: some View {
        HStack {
            //arrow
            let iconName = isExpaned ? "ic_v2_chevron-down" : "ic_v2_chevron-right"
            if category.childList.count >= 1 {
                Button(action: {
                    isExpaned.toggle()
                }, label: {
                    Image(iconName)
                        .foregroundColor(.config_secondary50())
                        .frame(width: 16, height: 16, alignment: .center)
                })
            } else {
                Spacer()
                    .frame(width: 24)
            }
            
            
            Button(action: {
                isChecked.toggle()
                if !isChecked {
                    self.clearCheckAllchild(category.childList)
                }
                category.isChecked = isChecked
                checkPressed(category)
                
                refresh.toggle()
            }, label: {
                Image("ic_v2_check")
                    .resizable()
                    .padding(.all, 2)
                    .frame(width: 18, height: 18, alignment: .center)
            })
            .buttonStyle(
                ButtonCheckBox(isChecked: isChecked)
            )
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .foregroundColor(.black)
                    .font(FontHelper.getFontSystem(.paragraph, font: .text).font)
            }
            Spacer()
        }
    }
    
    func clearCheckAllchild(_ childList: [CategoryResult]) {
        for caregory in childList {
            if caregory.isChecked {
                caregory.isChecked = false
                clearCheckAllchild(caregory.childList)
            }
        }
    }
}

struct UGCCategoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        let name = "Cat name sdf  sfsd fdsf sedfsafsfdssf fd fsf sdf  dsf dsfcdfdfdsfs ds dsfdfdfsf dfs"
        let chlidList = "{\"id\":92,\"name\":\"Category Course LC1\",\"child_list\":[{\"id\":93,\"name\":\"Category Course LC2\",\"child_list\":[{\"id\":94,\"name\":\"Category Course LC3\",\"child_list\":[{\"id\":95,\"name\":\"Category Course LC4\",\"child_list\":null}]}]}]}"
        let c = UGCCategory(JSON: ["name" : name, "child_list": chlidList])!
        UGCCategoryRow(category: c) { isChecked in
            
        }
        .previewLayout(.fixed(width: 300.0, height: 60))
        .environment(\.sizeCategory, .small)
    }
}
