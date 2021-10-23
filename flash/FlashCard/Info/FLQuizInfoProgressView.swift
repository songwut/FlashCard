//
//  FLQuizInfoSheetView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/9/2564 BE.
//

import SwiftUI
import Combine

protocol FLQuizProgressBarDelegate: AnyObject {
    func didUpdateHeight(_ size: CGSize)
}

struct FLQuizInfoProgressView: View {
    var delegate: FLQuizProgressBarDelegate? = nil
    @State var contentSize: CGSize = .zero
    @State var userAnswerPage: UserAnswerPageResult
    var width: CGFloat = 100
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 8, content: {
                let choiceList = userAnswerPage.choiceList
                ForEach(0..<choiceList.count) { i in
                    let c = choiceList[i]
                    FLQuizProgressBar(choice: c, width: geometry.size.width)
                        .frame(minHeight: FlashStyle.quiz.choiceMinHeight)
                }
            })
            .background(Color.clear)
            .readSize { newSize in
                print("The new child size is: \(newSize)")
                self.delegate?.didUpdateHeight(newSize)
            }
        }
    }
}

struct FLQuizInfoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let userAnswerPage = UserAnswerPageResult(JSON: ["value" : "quiz name", "choice" : [["value" : "ฮอกไกโด dsd dfdfdf ddf dfdsf dsddsdf dsfsfdfd fdfdfd fd dffdgdg dfg fdg fg fg fg", "is_answer":true, "percent": 70], ["value" : "เขาใหญ่", "percent": 30]]])!
        FLQuizInfoProgressView(userAnswerPage: userAnswerPage)
            .previewLayout(.fixed(width: 380, height: 468))
            .environment(\.sizeCategory, .small)
    }
}
