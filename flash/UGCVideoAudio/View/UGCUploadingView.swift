//
//  UGCUploadingView.swift
//  flash
//
//  Created by Songwut Maneefun on 8/3/2565 BE.
//

import SwiftUI

struct UGCUploadingView: View {
    @Binding var progress: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.5))
            
            VStack(alignment: .center, spacing: 20) {
                Text("Uploading \(Int(self.progress))%")
                    .foregroundColor(.white)
                    .font(.font(16, .medium))
                
                UGCProgressBar(progress: self.$progress)
                    .padding([.leading, .trailing], 32)
            }
            .frame(height: 80, alignment: .center)
            
        }
    }
}

#if DEBUG
struct UGCUploadingView_Previews: PreviewProvider {
    static var previews: some View {
        UGCUploadingView(progress: .constant(50))
            .previewLayout(.fixed(width: 343, height: 190))
            .environment(\.sizeCategory, .small)
    }
}
#endif
