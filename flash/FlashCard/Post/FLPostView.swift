//
//  FLPostView.swift
//  flash
//
//  Created by Songwut Maneefun on 6/9/2564 BE.
//

import SwiftUI

struct FLPostView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8, content: {
            ZStack(content: {
                Image("flash-cover")
                    .frame(width: .infinity, height: .infinity, alignment: .center)
                    
                Button(action: {
                    
                }, label: {
                    Image(systemName: "camera.circle.fill")
                })
                .frame(width: 32, height: 32, alignment: .center)
            })
            .frame(width: 120, height: 120, alignment: .center)
        })
    }
}

struct FLPostView_Previews: PreviewProvider {
    static var previews: some View {
        FLPostView()
    }
}
