//
//  UGCCatagoryListView.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import SwiftUI

protocol UGCCatagoryListViewDelegate {
    func didSelectCategory(_ category: CategoryResult)
}



private class UGCCatagoryListViewModel: ObservableObject {
    
    @State private var isLoaded = false
    @Published var items = [UGCCategory]()
    @Published var selectedCategory: UGCCategory = MockObject.category
}

struct UGCCatagoryListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject fileprivate var viewModel = UGCCatagoryListViewModel()
    
    @State var items = [UGCCategory]()
    @State var selectedCategory: CategoryResult?
    var delegate: UGCCatagoryListViewDelegate?
    
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            
            ScrollView {
                ListView
            }
            .background(UIColor.background().color)
            
            FooterView
                .frame(height: 80)
                .background(Color.white)
        })
        .background(UIColor.background().color)
    }
    
    var TotalView: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            let countCat = items.count.textNumber(many: "category_unit")
            let total = "total".localized()
            Text("\(total) \(countCat)")
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .foregroundColor(UIColor.text75().color)
                .font(FontHelper.getFontSystem(.l, font: .text).font)
        })
    }
    
    var ListView: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            TotalView
            //ForEach(0..<self.items.count, id: \.self) { category in
            ForEach(self.items) { category in
                UGCCategoryRow(category: category,
                               isFirst: true,
                               parentId: -1,
                               selectedCategory: $viewModel.selectedCategory)
            }
        })
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
    
    var FooterView: some View {
        HStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Button(action: {
                guard let c = self.viewModel.selectedCategory as? CategoryResult else { return }
                delegate?.didSelectCategory(c)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("done".localized().uppercased())
                    .font(FontHelper.getFontSystem(16, font: .medium).font)
                    .frame(maxWidth: .infinity, maxHeight: 42, alignment: .center)
            })
            .buttonStyle(ButtonFill(color: .config_primary()))
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
        UGCCatagoryListView(items: list)
            .previewDevice("iPhone 8")
    }
}
