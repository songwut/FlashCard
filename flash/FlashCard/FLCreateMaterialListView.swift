//
//  FLCreateMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 22/9/2564 BE.
//

import SwiftUI

struct FLCreateItem {
    var coverName: String
    var title: String
    var isReady: Bool
}

struct FLCreateMaterialListView: View {
    
    var list: [FLCreateItem]
    
    let column = UIDevice.isIpad() ? 3 : 2
    let margin: CGFloat = 16
    
    var body: some View {
        ContentView
    }
    
    var ContentView: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: true, content: {
                
                let superW = geometry.frame(in: .global).width
                let hWidth = superW - (margin * CGFloat(column))
                let cellWidth = CGFloat(hWidth / CGFloat(column))
                let cellHeight = CGFloat(cellWidth * (200 / 164))
                let row = Float(list.count / column)
                
                ForEach(0..<Int(row.rounded(.up))) { i in
                    VStack(alignment: .center, spacing: margin, content: {
                        HStack(alignment: .center, spacing: margin, content: {
                            ForEach(0..<column) { j in
                                let item = list[j]
                                NavigationLink(destination: FLFlashEditorView(createStatus: .new)) {
                                    CreatetFlashCardView(item: item)
                                        .frame(maxWidth: cellWidth, maxHeight: cellHeight)
                                }
                               
                            }
                        })
                        .padding(.bottom, margin)
                        .frame(maxWidth: .infinity, maxHeight: cellHeight, alignment: .leading)
                    })
                }
            })
            .padding(.all, margin)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
    
}

struct FLCreateMaterialListView_Previews: PreviewProvider {
    static var previews: some View {
        FLCreateMaterialListView(list: [FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true), FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true),FLCreateItem(coverName: "flash-create-cover", title: "Flash Card", isReady: true)])
            //.previewDevice("iPad Pro (11-inch) (2nd generation)")
    }
}
