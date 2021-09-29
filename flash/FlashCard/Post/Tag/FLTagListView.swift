//
//  TagListView.swift
//  SwiftUIDemos
//
//  Created by Alex Hay on 23/11/2020.
//

import SwiftUI

/// A subview containing a list of all tags that are in the array. Tags flow onto the next line when wider than the view's width
struct FLTagListView: View {
	
	@Binding var tags: [String]
	
	var body: some View {
		GeometryReader { geo in
			generateTags(in: geo)
			.padding(.top)
		}
	}

	/// Adds a tag view for each tag in the array. Populates from left to right and then on to new rows when too wide for the screen
	private func generateTags(in geo: GeometryProxy) -> some View {
		var width: CGFloat = 0
		var height: CGFloat = 0

		return ZStack(alignment: .topLeading) {
			ForEach(tags, id: \.self) { tag in
				FLTagView(tag: tag, tags: $tags)
				.alignmentGuide(.leading, computeValue: { tagSize in
					if (abs(width - tagSize.width) > geo.size.width) {
						width = 0
						height -= tagSize.height
					}
					let offset = width
					if tag == tags.last ?? "" {
						width = 0
					} else {
						width -= tagSize.width
					}
					return offset
				})
				.alignmentGuide(.top, computeValue: { tagSize in
					let offset = height
					if tag == tags.last ?? "" {
						height = 0
					}
					return offset
				})
			}
		}
	}
}
struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
		FLTagListView(tags: .constant(["tag one", "tag two"]))
			.padding()
            .previewLayout(.fixed(width: 375, height: 150))
            .environment(\.sizeCategory, .small)
    }
}
