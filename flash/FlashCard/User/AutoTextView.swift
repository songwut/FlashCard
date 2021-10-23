//
//  AutoTextView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/10/2564 BE.
//

import SwiftUI

struct AutoTextView: View {
    var contentWidth: CGFloat = 200
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Some long text here that will span two lines dfgd fdg s dfgg fdgfgf df df gfgfgff gffgfggr g dfgf sgg dgdd")
                    .lineLimit(nil)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: geometry.size.width)
            .background(Color.orange)
        }
    }
}

struct AutoTextView_Previews: PreviewProvider {
    static var previews: some View {
        AutoTextView()
            .previewLayout(.fixed(width: 320, height: 300))
            .environment(\.sizeCategory, .small)
    }
}
