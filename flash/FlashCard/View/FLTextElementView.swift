//
//  FLTextElementView.swift
//  flash
//
//  Created by Songwut Maneefun on 29/10/2564 BE.
//

import SwiftUI

struct FLTextElementView: View {
    var element: FlashElement
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack(spacing: 0) {
                ZStack {
                    Text(element.text)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }//.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .position(
                x: element.offsetX(on: geometry.size.width),
                y: element.offsetY(on: geometry.size.height)
            )
            .frame(width: element.width(on: geometry.size.width), height: element.height(on: geometry.size.height), alignment: .center)
            .rotationEffect(.degrees(element.rotation?.doubleValue ?? 0))
        })
    }
    
}

struct FLTextElementView_Previews: PreviewProvider {
    static var previews: some View {
        FLTextElementView(element: MockObject.textElement)
    }
}
