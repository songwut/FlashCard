//
//  FLSUserListView.swift
//  flash
//
//  Created by Songwut Maneefun on 6/10/2564 BE.
//

import SwiftUI

struct FLSUserListView: View {
    
    @State var list: [ContentResult]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true, content: {
            VStack(alignment: .center, spacing: 0, content: {
                ForEach(0 ..< list.count) { i in
                    let user = list[i]
                    FLSUserView(user: user)
                        .frame(width: .infinity, height: 44, alignment: .top)
                }
                Spacer()
            })
        })
    }
}

struct FLSUserListView_Previews: PreviewProvider {
    static var previews: some View {
        let list = [ContentResult(JSON: ["name" : "Tar"])!, ContentResult(JSON: ["name" : "Tar2"])!,ContentResult(JSON: ["name" : "Tar3"])!]
        FLSUserListView(list: list)
            .previewLayout(.fixed(width: 300, height: 100.0))
    }
}
