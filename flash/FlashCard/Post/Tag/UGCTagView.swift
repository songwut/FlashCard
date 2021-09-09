//
//  UGCTagView.swift
//  flash
//
//  Created by Songwut Maneefun on 7/9/2564 BE.
//

import SwiftUI

extension String {
    func limit(_ limit: Int) -> String {
        if self.count <= limit {
            return self
        } else {
            return self.prefix(limit) + "..."
        }
    }
    
}

struct UGCTagView: View {
    @State var tag: String
    
    var body: some View {
        Text(tag.limit(20))
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .frame(width: .infinity, height: 32, alignment: .leading)
    }
}

struct UGCTagView_Previews: PreviewProvider {
    static var previews: some View {
        UGCTagView(tag: "Fulltextsearcwws dsasd sdddsffs f sfdss dsf  sfdsfdf")
            .previewLayout(.fixed(width: 300.0, height: 60))
            .environment(\.sizeCategory, .small)
    }
}
