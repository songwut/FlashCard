//
//  ActivityIndicator.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import SwiftUI

/// Wrapper around `UIActivityIndicator`
public struct ActivityIndicator: UIViewRepresentable {
    /// Determines if the activity indicator is animating
    @Binding public var isAnimating: Bool
    
    /// Color of the activity indicator
    public let color: UIColor?
    
    /// Style of the activity indicator
    public let style: UIActivityIndicatorView.Style
    
    // MARK: - Initialization
    
    public init(isAnimating: Binding<Bool>, color: UIColor? = nil, style: UIActivityIndicatorView.Style = .medium) {
        self._isAnimating = isAnimating
        self.color = color
        self.style = style
    }
    
    // MARK: - UIViewRepresentable
    
    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = color
        return view
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityIndicator(isAnimating: .constant(true))
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Default")
            ActivityIndicator(isAnimating: .constant(true), color: .red)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Color")
            ActivityIndicator(isAnimating: .constant(true), style: .large)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Large")
            ActivityIndicator(isAnimating: .constant(true), color: .red, style: .large)
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Large with color")
        }
    }
}
