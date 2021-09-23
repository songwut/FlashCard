//
//  MyMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI

struct MyMaterialListView: View {
    var myMaterialFlash: MaterialFlashPageResult
    
    var body: some View {
        ScrollView {
            self.listView
        }
        .background(Color.clear)
        .navigationBarTitle("My Material", displayMode: .automatic)
    }
    
    
    var listView: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            let items = myMaterialFlash.list
            let count =  items.count
            let total = "total".localized()
            let totalText =  count.textNumber(many: "learning_material".localized())
            Text("\(total) \(totalText)")
                .frame(height: 40)
                .foregroundColor(UIColor.text75().color)
                .font(FontHelper.getFontSystem(.l, font: .text).font)
            
            let createList = [
                FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),
                FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),
                FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true)
            ]
            NavigationLink(destination: FLCreateMaterialListView(list: createList)) {
                FLCreateMaterialView()
                    .frame(height: 122)
                    .padding(.bottom, 8)
            }
            
            ForEach(0..<items.count) { i in
                let item = items[i]
                FLMaterialView(isEditor: true, flash: item)
                    .frame(maxWidth: .infinity, maxHeight: 124, alignment: .center)
            }
        })
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
}

struct MyMaterialListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let item = MaterialFlashPageResult(JSON: ["count" : 3])!
        MyMaterialListView(myMaterialFlash: item)
    }
}
