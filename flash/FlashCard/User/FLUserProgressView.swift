//
//  SegmentedProgressView.swift
//  segment-progress
//
//  Created by Songwut Maneefun on 1/9/2564 BE.
//

import SwiftUI

struct AmountModel {
   var amount: Int
   var cost: Double
}
class FLProgressViewModel: ObservableObject {
    @Published var value: Int = 1
}

struct FLProgressView: View {
    @EnvironmentObject var viewModel: FLProgressViewModel
    @State var maximum: Int = 1
    var height: CGFloat = UIDevice.isIpad() ? 5 : 2
    var spacing: CGFloat = 2
    var selectedColor: Color = .config_primary()
    var unselectedColor: Color = .disable()
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0 ..< maximum) { index in
                Rectangle()
                    .clipShape(Capsule())
                    .foregroundColor(index < viewModel.value ? self.selectedColor : self.unselectedColor)
            }
        }
        .frame(maxHeight: height)
        .clipShape(Capsule())
    }
}

struct FLUserProgressView: View {
    var isShowButton = false
    @EnvironmentObject var viewModel: FLProgressViewModel
    @State var maximum: Int = 01
    var body: some View {
        VStack(alignment: .leading) {
            FLProgressView(viewModel: _viewModel)
                .animation(.default)
                .padding(.vertical)
            if self.isShowButton {
                Button(action: {
                    viewModel.value = (viewModel.value + 1) % (maximum + 1)
                }) {
                    Text("Increment value:\(viewModel.value)")
                        .foregroundColor(.blue)
                }
            }
            
        }
        .foregroundColor(.clear)
        //.padding()
    }
}


struct FLUserProgressView_Previews: PreviewProvider {
    static var previews: some View {
        FLUserProgressView()
            .previewLayout(.fixed(width: 343, height: 60))
            .environment(\.sizeCategory, .small)
    }
}

