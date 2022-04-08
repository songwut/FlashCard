//
//  UGCCategoryRow.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import SwiftUI

struct UGCCategoryRow: View {
    @State var category: UGCCategory
    @State var isFirst: Bool = false
    @State var parentId: Int = -1
    @Binding var selectedCategory: UGCCategory
    
    @State private var isChecked: Bool = false
    @State private var refresh: Bool = false
    @State private var isExpaned: Bool = false
    
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
                            UGCCategoryRow(category: c,
                                           parentId: category.id ,
                                           selectedCategory: $selectedCategory)
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
    
    private var ContentView: some View {
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
                self.isChecked.toggle()
                self.category.isChecked = self.isChecked
                
                if isChecked {
                    ConsoleLog.show("categorySelected: \(self.category.name)")
                    self.selectedCategory = self.category
                }
                
                refresh.toggle()
            }, label: {
                Image("ic_v2_check")
                    .resizable()
                    .padding(.all, 2)
                    .frame(width: 18, height: 18, alignment: .center)
            })
            .buttonStyle(
                ButtonCheckBox(isChecked: self.setChecked(category: category))
            )
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .foregroundColor(.black)
                    .font(FontHelper.getFontSystem(.paragraph, font: .text).font)
            }
            Spacer()
        }
    }
    
    func setChecked(category: UGCCategory) -> Bool {
        //loop for check on parent UI need to improve
        ConsoleLog.show("category: \(category.name) \(category.isChecked)")
        let selectedId = self.selectedCategory.id
        var isSelect = false
        
        if category.id == selectedId {
            //category.isChecked = self.isChecked
            isSelect = category.isChecked
        } else {
            //isChecked : clild click
            //case childList improve next phace
            
            for c1 in category.childList {//Level 1
                ConsoleLog.show("c1: \(c1.name)")
                if c1.id == selectedId {
                    category.isChecked = c1.isChecked
                    ConsoleLog.show("category: \(c1.isChecked)")
                    isSelect = c1.isChecked
                }
                
                for c2 in c1.childList {//Level 2
                    ConsoleLog.show("c2: \(c2.name)")
                    if c2.id == selectedId {
                        category.isChecked = c2.isChecked
                        c1.isChecked = c2.isChecked
                        ConsoleLog.show("category: \(c2.isChecked)")
                        isSelect = c2.isChecked
                    }
                    
                    for c3 in c2.childList {//Level 3
                        ConsoleLog.show("c3: \(c3.name)")
                        if c3.id == selectedId {
                            category.isChecked = c3.isChecked
                            c1.isChecked = c3.isChecked
                            c2.isChecked = c3.isChecked
                            ConsoleLog.show("category: \(c3.isChecked)")
                            isSelect = c3.isChecked
                        }
                        
                        for c4 in c3.childList {//Level 4
                            ConsoleLog.show("c4: \(c4.name)")
                            if c4.id == selectedId {
                                category.isChecked = c4.isChecked
                                c1.isChecked = c4.isChecked
                                c2.isChecked = c4.isChecked
                                c3.isChecked = c4.isChecked
                                ConsoleLog.show("category: \(c4.isChecked)")
                                isSelect = c4.isChecked
                            }
                        }
                    }
                }
            }
        }
        category.isChecked = isSelect
        return isSelect
    }
    
    func checkAllchild(_ childList: [CategoryResult]) {
        for caregory in childList {
            if caregory.isChecked {
                caregory.isChecked = false
                clearCheckAllchild(caregory.childList)
            }
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
        
        UGCCategoryRow(category: c, parentId: -1, selectedCategory: .constant(c))
        .previewLayout(.fixed(width: 300.0, height: 60))
        .environment(\.sizeCategory, .small)
    }
}
