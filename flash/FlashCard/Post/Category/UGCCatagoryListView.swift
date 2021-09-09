//
//  UGCCatagoryListView.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import SwiftUI

struct UGCCatagoryListView: View {
    @State var items = [UGCCategory]()
    
    var body: some View {
        ScrollView {
            self.listView
        }
//        .foregroundColor(ColorHelper.primary().color)
//        .navigationBarTitle(Text("category".localized()))
//        .statusBar(hidden: false)
    }
    
    var listView: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            let countCat = items.count.textNumber(many: "category_unit")
            let total = "total".localized()
            Text("\(total) \(countCat)")
                .foregroundColor(ColorHelper.text75().color)
                .font(FontHelper.getFontSystem(.l, font: .text).font)
            
            ForEach(0..<items.count) { i in
                UGCCategoryRow(category: self.items[i])
            }
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

//struct UGCCatagoryListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UGCCatagoryListView(items: UGCData.categoryList())
//            .previewDevice("iPhone 8")
//    }
//}
