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
        Text("ddd")
        
        
//        ScrollView {
//            ForEach(0..<tagList.count) { tag in
//                HStack {
//                    ForEach(0..<3) { tag in
//                        let tag = tagList[tag]
//                        UGCTagView(tag: tag)
//                            .scaledToFit()
//                    }
//                }
//            }
//        }
    }
}

struct UGCTagListView_Previews: PreviewProvider {
    static var previews: some View {
        let list = ["UX/UI","Figma","Soft Skill","Design","Release","Language","Fulltextsearch","Internalreleation", "Article", "Podcast"]
        UGCTagListView(tagList: list)
    }
}
