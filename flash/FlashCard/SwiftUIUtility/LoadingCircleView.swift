//
//  LoadingCircleView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import SwiftUI

struct LoadingCircleView: View {
    @State private var isCircleRotating = true
    @State private var animateStart = false
    @State private var animateEnd = true
    @State var tintColor: Color
    @State var lineWidth: CGFloat = 10
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Circle()
                    .stroke(lineWidth: lineWidth)
                    .fill(Color.init(red: 0.96, green: 0.96, blue: 0.96))
                    .frame(width: geometry.size.width - lineWidth, height: geometry.size.height - lineWidth)
                
                Circle()
                    .trim(from: animateStart ? 1/3 : 1/9, to: animateEnd ? 2/5 : 1)
                    .stroke(lineWidth: 10)
                    .rotationEffect(.degrees(isCircleRotating ? 360 : 0))
                    .frame(width: geometry.size.width - lineWidth, height: geometry.size.height - lineWidth)
                    .foregroundColor(tintColor)
                    .onAppear() {
                        withAnimation(Animation
                                        .linear(duration: 1)
                                        .repeatForever(autoreverses: false)) {
                            self.isCircleRotating.toggle()
                        }
                        withAnimation(Animation
                                        .linear(duration: 1)
                                        .delay(0.5)
                                        .repeatForever(autoreverses: true)) {
                            self.animateStart.toggle()
                        }
                        withAnimation(Animation
                                        .linear(duration: 1)
                                        .delay(1)
                                        .repeatForever(autoreverses: true)) {
                            self.animateEnd.toggle()
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
    }
}

struct LoadingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCircleView(tintColor: .pink)
            .previewLayout(.fixed(width: 300.0, height: 300))
            .environment(\.sizeCategory, .small)
    }
}
