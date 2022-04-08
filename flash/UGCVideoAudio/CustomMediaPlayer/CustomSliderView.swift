//
//  CustomSliderView.swift
//  flash
//
//  Created by Songwut Maneefun on 10/3/2565 BE.
//https://betterprogramming.pub/reusable-components-in-swiftui-custom-sliders-8c115914b856

import SwiftUI

struct CustomSliderComponents {
    let barLeft: CustomSliderModifier
    let barRight: CustomSliderModifier
    let knob: CustomSliderModifier
}

struct CustomSliderModifier: ViewModifier {
    enum Name {
        case barLeft
        case barRight
        case knob
    }
    let name: Name
    let size: CGSize
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
        .frame(width: size.width)
        .position(x: size.width*0.5, y: size.height*0.5)
        .offset(x: offset)
    }
}

struct CustomSlider<Component: View>: View {

    @Binding var value: Double
    var range: (Double, Double)
    var knobWidth: CGFloat?
    let viewBuilder: (CustomSliderComponents) -> Component

    init(value: Binding<Double>, range: (Double, Double), knobWidth: CGFloat? = nil,
         _ viewBuilder: @escaping (CustomSliderComponents) -> Component
    ) {
        _value = value
        self.range = range
        self.viewBuilder = viewBuilder
        self.knobWidth = knobWidth
    }
    
    var body: some View {
      return GeometryReader { geometry in
        self.view(geometry: geometry) // function below
      }
    }

    private func view(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .global)
        let drag = DragGesture(minimumDistance: 0).onChanged({ drag in
          self.onDragChange(drag, frame) }
        )
        let offsetX = self.getOffsetX(frame: frame)

        let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
        let barLeftSize = CGSize(width: CGFloat(offsetX + knobSize.width * 0.5), height:  frame.height)
        let barRightSize = CGSize(width: frame.width - barLeftSize.width, height: frame.height)

        let modifiers = CustomSliderComponents(
            barLeft: CustomSliderModifier(name: .barLeft, size: barLeftSize, offset: 0),
            barRight: CustomSliderModifier(name: .barRight, size: barRightSize, offset: barLeftSize.width),
            knob: CustomSliderModifier(name: .knob, size: knobSize, offset: offsetX))

        return ZStack { viewBuilder(modifiers).gesture(drag) }
          
    }
    
    private func onDragChange(_ drag: DragGesture.Value,_ frame: CGRect) {
        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xrange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width) // knob center x
        value -= 0.5*width.knob // offset from center to leading edge of knob
        value = value > xrange.max ? xrange.max : value // limit to leading edge
        value = value < xrange.min ? xrange.min : value // limit to trailing edge
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: range)
        self.value = value
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
        let result = self.value.convert(fromRange: range, toRange: xrange)
        return CGFloat(result)
    }
}


struct CustomSliderView: View {
 
    @State var isShowing = false
    @Binding var progress: Double
 
    private let heightBar: CGFloat = 8
    var body: some View {
        CustomSlider(value: $progress, range: (0, 100), knobWidth: 100) { modifiers in
          ZStack {
            Group {
              
              Color.white.frame(height: 5)
                .modifier(modifiers.barLeft)
              
              Color.white.opacity(0.2).frame(height: 5)
                .modifier(modifiers.barRight)
              
            }.cornerRadius(2.5)
            Group {
                Circle().fill(Color.white.opacity(0.0))
              Image("ic_v2_thumb")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
            }
            .frame(width: 30, height: 30)
            .modifier(modifiers.knob)
          }

        }.frame(height: 50)
    }
}


#if DEBUG
struct CustomSliderView_Previews: PreviewProvider {
  static var previews: some View {
      CustomSliderView(isShowing: true, progress: .constant(0.5))
          .background(Color.black)
          .previewLayout(.fixed(width: 128, height: 76))
          .environment(\.sizeCategory, .small)
  }
}
#endif
