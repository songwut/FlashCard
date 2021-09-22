//
//  MyNewMaterialView.swift
//  flash
//
//  Created by Songwut Maneefun on 22/9/2564 BE.
//

import SwiftUI

struct MyNewMaterialView: View {
    var content: MaterialFlashPageResult
    var createPressed: () -> ()
    var itemPressed: () -> ()
    
    var body: some View {
        ScrollView {
            self.listView
        }
        .background(Color.clear)
        .navigationBarTitle("My Material", displayMode: .automatic)
    }
    
    var listView: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            let items = content.list
            let limit = 3
            if items.count == 0 {
                FLCreateMaterialView()
                    .frame(height: 122)
                    .padding(.bottom, 8)
                    .onTapGesture {
                        createPressed()
                    }
            } else {
                ForEach(0..<items.count) { i in
                    if i < limit {
                        let item = items[i]
                        FLMaterialView(isEditor: false, flash: item)
                            .frame(maxWidth: .infinity, maxHeight: 124, alignment: .center)
                    }
                }
            }
        })
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
}

struct MyNewMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        let item = MaterialFlashPageResult(JSON: ["count" : 3])!
        MyNewMaterialView(content: item) {
            print("createPressed")
        } itemPressed: {
            print("itemPressed")
        }

    }
}
