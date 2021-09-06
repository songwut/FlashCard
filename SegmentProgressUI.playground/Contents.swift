//: A UIKit based Playground for presenting user interface
  
import SwiftUI
import PlaygroundSupport

struct SegmentedProgressView: View {
  var value: Int
  var maximum: Int = 7
  var height: CGFloat = 10
  var spacing: CGFloat = 2
  var selectedColor: Color = .accentColor
  var unselectedColor: Color = Color.secondary.opacity(0.3)

  var body: some View {
    HStack(spacing: spacing) {
      ForEach(0 ..< maximum) { index in
        Rectangle()
          .foregroundColor(index < self.value ? self.selectedColor : self.unselectedColor)
      }
    }
    .frame(maxHeight: height)
    .clipShape(Capsule())
  }
}

struct ExampleOfProgress: View {
  @State var value = 0
  var maximum = 10

  var body: some View {
    VStack(alignment: .leading) {
      Text("SegmentedProgressView example")
        .font(.headline)
      Text("Current value is \(value) out of \(maximum)")
        .font(.body)
      SegmentedProgressView(value: value, maximum: maximum)
        .animation(.default)
        .padding(.vertical)
      Button(action: {
        self.value = (self.value + 1) % (self.maximum + 1)
      }) {
        Text("Increment value")
      }
    }
    .padding()
  }
}

PlaygroundPage.current.liveView = UIHostingController(rootView: ExampleOfProgress())

