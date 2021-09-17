//
//  UGCTagListView.swift
//  flash
//
//  Created by Songwut Maneefun on 7/9/2564 BE.
//

import SwiftUI

struct UGCTagListView: View {
    
    @State var tagList = [String]()
    
    var body: some View {
        let column = 2
        let row = Float(tagList.count / column)
        
        ScrollView(.vertical, showsIndicators: true, content: {
            ForEach(0..<Int(row.rounded(.up))) { i in
                HStack {
                    ForEach(0..<column) { j in
                        let tag = tagList[j]
                        UGCTagView(tag: tag, row: i, collumn: j)
                    }
                }
            }
        })
    }
}

struct UGCTagListView_Previews: PreviewProvider {
    static var previews: some View {
        let list = ["UX/UI","Figma","Soft Skill","Design","Release","Language","Fulltextsearch","Internalreleation", "Article", "Podcast"]
        UGCTagListView(tagList: list)
    }
}
