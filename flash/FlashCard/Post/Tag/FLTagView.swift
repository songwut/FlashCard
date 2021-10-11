//
//  TagView.swift
//  SwiftUIDemos
//
//  Created by Alex Hay on 23/11/2020.
//

import SwiftUI

/// A subview of a tag shown in a list. When tapped the tag will be removed from the array
struct FLTagView: View {
	
	var tag: String
	@Binding var tags: [String]
	
	var body: some View {
        let font = UIFont.font(10, font: .text)
		HStack {
			Text(tag.lowercased())
				.padding(.leading, 2)
			Image(systemName: "xmark.circle.fill")
				.opacity(0.4)
				.padding(.leading, -6)
		}
		.foregroundColor(UIColor.info().color)
        .font(font.font)
        .background(UIColor.info_10().color.cornerRadius(5))
		.padding(2)
		.onTapGesture {
			tags = tags.filter({ $0 != tag })
		}
	}
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        FLTagView(tag: "hello world", tags: .constant(["tag one", "tag two"]))
            .previewLayout(.fixed(width: 375, height: 150))
            .environment(\.sizeCategory, .small)
    }
}
