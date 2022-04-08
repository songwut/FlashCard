//
//  UGCProgressBar.swift
//  flash
//
//  Created by Songwut Maneefun on 8/3/2565 BE.
//

import SwiftUI

struct UGCProgressBar: View {
 
    @State var isShowing = false
    @Binding var progress: CGFloat
 
    private let heightBar: CGFloat = 8
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.config_secondary())
                    .opacity(0.3)
                    .frame(width: geometry.size.width, height: 8.0)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Rectangle()
                    .foregroundColor(.config_primary())
                    .frame(width: self.isShowing ? geometry.size.width * (self.progress / 100.0) : 0.0, height: 8.0)
                    .animation(.linear(duration: 0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .onAppear {
                self.isShowing = true
            }
            .cornerRadius(4.0)
        }
            
    }
}
 
#if DEBUG
struct UGCProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        UGCProgressBar(progress: .constant(25.0))
            .previewLayout(.fixed(width: 128, height: 76))
            .environment(\.sizeCategory, .small)
    }
}
#endif
