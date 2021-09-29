//
//  FLQuizInfoSheetView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/9/2564 BE.
//

import SwiftUI
import Combine

struct FLQuizInfoProgressView: View {
    @State var userAnswerPage: UserAnswerPageResult
    
    var body: some View {
        ContentView
    }
    
    var ContentView: some View {
        VStack(spacing: 8, content: {
            let choiceList = userAnswerPage.choiceList
            ForEach(0..<choiceList.count) { i in
                let c = choiceList[i]
                FLQuizProgressBar(choice:c)
                    .frame(height: 36)
            }
            
            Spacer()
        })
        .padding(.top, 0)
        .padding([.leading, .trailing], 16)
        .frame(width: .infinity, height: .infinity, alignment: .top)
        
    }
}

struct FLQuizInfoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let userAnswerPage = UserAnswerPageResult(JSON: ["value" : "quiz name", "choice" : [["value" : "ฮอกไกโด", "is_answer":true, "percent": 70], ["value" : "เขาใหญ่", "percent": 30]]])!
        FLQuizInfoProgressView(userAnswerPage: userAnswerPage)
            .previewLayout(.fixed(width: 375, height: 286))
            .environment(\.sizeCategory, .small)
    }
}
