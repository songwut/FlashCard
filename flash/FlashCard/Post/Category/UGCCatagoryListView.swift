//
//  UGCCatagoryListView.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import SwiftUI

protocol UGCCatagoryListViewDelegate {
    func didSelectCategory(_ categoryId: Int)
}

struct UGCCatagoryListView: View {
    @State var items = [UGCCategory]()
    
    var delegate: UGCCatagoryListViewDelegate?
    @State var selectedCategoryId: Int = 0
    
    var didSelectCategory: (_ category: CategoryResult) -> ()
    
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            ScrollView {
                self.listView
            }
            .background(ColorHelper.background().color)
            //.frame(width: .infinity, height: .infinity)
            
            self.footerView
                .frame(height: 80)
                .background(Color.white)
        })
        
        
        
        //        .foregroundColor(ColorHelper.primary().color)
        //        .navigationBarTitle(Text("category".localized()))
        //        .statusBar(hidden: false)
    }
    
    var listView: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            let countCat = items.count.textNumber(many: "category_unit")
            let total = "total".localized()
            Text("\(total) \(countCat)")
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .foregroundColor(ColorHelper.text75().color)
                .font(FontHelper.getFontSystem(.l, font: .text).font)
            
            ForEach(0..<items.count) { i in
                let category = self.items[i]
                UGCCategoryRow(category: category) { selectedCategory in
                    print("createPressed:\(selectedCategory.name)")
                    selectedCategoryId = selectedCategory.id
                    return didSelectCategory(selectedCategory)
                }
            }
        })
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
    
    var footerView: some View {
        HStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Button(action: {
                self.delegate?.didSelectCategory(selectedCategoryId)
            }, label: {
                Text("done".localized().uppercased())
                    .font(FontHelper.getFontSystem(16, font: .medium).font)
                    .frame(maxWidth: .infinity, maxHeight: 42, alignment: .center)
            })
            .buttonStyle(ButtonFill(color: ColorHelper.primary().color))
        })
        .padding(.all, 16)
    }
}

struct GroupedListModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 14, *) {
                AnyView(
                    content
                        .listStyle(DefaultListStyle())
                )
            } else {
                content
                    .listStyle(DefaultListStyle())
                    .environment(\.horizontalSizeClass, .regular)
            }
        }
    }
}

struct UGCCatagoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let list = [
            UGCCategory(JSON: ["name" : "1"])!,
            UGCCategory(JSON: ["name" : "2"])!
        ]
        UGCCatagoryListView(items: list) { category in
            print("UGCCatagoryListView: select: \(category.name)")
        }
            .previewDevice("iPhone 8")
    }
}
