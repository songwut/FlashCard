//
//  FLUserView.swift
//  flash
//
//  Created by Songwut Maneefun on 29/9/2564 BE.
//

import SwiftUI

struct FLUserView: View {
    @State var user: UserAnswerResult
    
    var body: some View {
        HStack {
            Image("coverItem")
                .resizable()
                .frame(width: 50, height: 50)
            Text("name")
            Spacer()
        }
    }
}

struct FLUserView_Previews: PreviewProvider {
    static var previews: some View {
        FLUserView(user: UserAnswerResult(JSON: ["name" : "efefew fff"])!)
            .previewLayout(.fixed(width: 375, height: 200))
            .environment(\.sizeCategory, .small)
    }
}
