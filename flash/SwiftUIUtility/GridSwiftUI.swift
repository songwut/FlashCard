//
//  GridSwiftUI.swift
//  flash
//
//  Created by Songwut Maneefun on 7/4/2565 BE.
//
//https://www.swiftpal.io/articles/how-to-create-a-grid-view-in-swiftui-for-ios-13

import SwiftUI

//GridSwiftUI for iOS 13 | iOS 14 going to use LazyVGrid and LazyHGrid
struct GridSwiftUI<Content: View, T: GridItem>: View {
    private let style: GridConfig
    private let columns: Int
    private var list: [[T]] = []
    private let content: (T) -> Content
    
    init(style: GridConfig ,
         columns: Int,
         list: [T],
         @ViewBuilder content:@escaping (T) -> Content) {
        self.style = style
        self.columns = columns
        self.content = content
        self.setupList(list)
    }
    
    private mutating func setupList(_ list: [T]) {
        var column = 0
        var columnIndex = 0
        
        for object in list {
            if columnIndex < self.columns {
                if columnIndex == 0 {
                    self.list.insert([object], at: column)
                    columnIndex += 1
                }else {
                    self.list[column].append(object)
                    columnIndex += 1
                }
            }else {
                column += 1
                self.list.insert([object], at: column)
                columnIndex = 1
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: self.style.vSpacing) {
                ForEach(0 ..< self.list.count, id: \.self) { i  in
                    HStack(alignment: .top,
                           spacing: self.style.hSpacing) {
                        ForEach(self.list[i], id: \.self.uuid) { object in
                                self.content(object)
                                
                                //.frame(width: proxy.size.width / CGFloat(self.columns))
                        }
                    }
                }
            }
            .frame(width: proxy.size.width)
        }
    }
    
//    private var calWidth(width: CGFloat) -> CGFloat {
//        let marginAll =
//        let cellWidth = width / CGFloat(self.columns)
//    }
}

protocol GridItem {
    var uuid: UUID { get }
}

struct GridConfig {
    let vSpacing: CGFloat
    let hSpacing: CGFloat
}

//struct GridSwiftUI_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollView() {
//            GridSwiftUI(style: GridConfig(vSpacing: 8, hSpacing: 8),
//                   columns: 2,
//                   list: ["😀", "🤩", "😘"]) { emoji in
//                
//                Text(emoji)
//                    .font(.largeTitle)
//            }
//            
//        }
//    }
//}

