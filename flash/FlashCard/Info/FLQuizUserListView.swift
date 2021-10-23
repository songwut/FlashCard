//
//  FLQuizUserList.swift
//  flash
//
//  Created by Songwut Maneefun on 29/9/2564 BE.
//

import SwiftUI
import Combine

struct FLQuizUserListView: View {
    @State var items: [FLAnswerResult]
    @State var currentSize: Int = 5
    @State var isLoading: Bool = true
    @State var maxSize: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            ScrollView {
                ListView
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .background(UIColor.background().color)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    var ListView: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            ForEach(0..<currentSize) { i in
                let user = items[i]
                FLUserView(user: user)
                    .frame(width: .infinity, height: 60, alignment: .center)
            }
            Button("Load more...") {
                self.loadMore()
            }
            .onAppear {
                if currentSize < maxSize {
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) {
                        self.loadMore()
                    }
                }
            }
        })
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
    
    func loadMore() {
        print("Load more...")
        currentSize += currentSize
        if currentSize > maxSize {
            currentSize = maxSize
        }
        //self.range = 0..<self.range.upperBound + self.chunkSize
    }
}

//struct LoadingPlaceholder: View {
//    var text = "Loading..."
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: nil, content: {
//            if #available(iOS 14.0, *) {
//                ProgressView(self.text)
//            } else {
//                Text(self.text)
//            }
//        })
//    }
//}

struct FLQuizUserList_Previews: PreviewProvider {
    static var previews: some View {
        var items = [
            FLAnswerResult(JSON: ["name" : "wrrwer"])!,
            FLAnswerResult(JSON: ["name" : "ererwre"])!,
            FLAnswerResult(JSON: ["name" : "rgrggefsfs"])!,
            FLAnswerResult(JSON: ["name" : "ukyk"])!,
            FLAnswerResult(JSON: ["name" : "prgrto"])!,
            FLAnswerResult(JSON: ["name" : "trterm,"])!,
            FLAnswerResult(JSON: ["name" : "wrrwer"])!,
            FLAnswerResult(JSON: ["name" : "ererwre"])!,
            FLAnswerResult(JSON: ["name" : "rgrggefsfs"])!,
            FLAnswerResult(JSON: ["name" : "ukyk"])!
        ]
        FLQuizUserListView(items: items, maxSize: 50)
            .previewLayout(.fixed(width: 375, height: 300))
            .environment(\.sizeCategory, .small)
    }
}
