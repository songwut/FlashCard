//
//  SegmentedProgressView.swift
//  segment-progress
//
//  Created by Songwut Maneefun on 1/9/2564 BE.
//

import SwiftUI

protocol FLUserProgressViewDelegate {
    func segmentSelected(_ index: Int)
}


struct FLProgressView: View {
    var value: Int
    var maximum: Int = 7
    var height: CGFloat = UIDevice.isIpad() ? 5 : 2
    var spacing: CGFloat = 2
    var selectedColor: Color = ColorHelper.primary().color
    var unselectedColor: Color = ColorHelper.disable().color
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0 ..< maximum) { index in
                Rectangle()
                    .clipShape(Capsule())
                    .foregroundColor(index < self.value ? self.selectedColor : self.unselectedColor)
            }
        }
        .frame(maxHeight: height)
        .clipShape(Capsule())
    }
}

struct FLUserProgressView: View {
    @State var value = 1
    var isShowButton = false
    var maximum = 10
    var delegate: FLUserProgressViewDelegate?
    
    var body: some View {
        VStack(alignment: .leading) {
            FLProgressView(value: value, maximum: maximum)
                .animation(.default)
                .padding(.vertical)
            if self.isShowButton {
                Button(action: {
                    self.value = (self.value + 1) % (self.maximum + 1)
                    //TODO: pless until self.value == 0
                    self.delegate?.segmentSelected(self.value)
                }) {
                    Text("Increment value:\(self.value)")
                        .foregroundColor(.blue)
                }
            }
            
        }
        .foregroundColor(.clear)
        //.padding()
    }
}




