//
//  ActivityLoadingView.swift
//  flash
//
//  Created by Songwut Maneefun on 19/11/2564 BE.
//

import SwiftUI

struct ActivityLoadingView: View {
    @State var isLoading = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            Spacer()
            ActivityIndicator(isAnimating: .constant(isLoading),
                              color: .black,
                              style: .medium)
                .fixedSize(horizontal: true, vertical: false)
            Spacer()
        })
        .background(Color.clear)
    }
}

struct ActivityLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityLoadingView(isLoading: true)
            .previewLayout(.fixed(width: 300, height: 120))
            .environment(\.sizeCategory, .small)
    }
}
