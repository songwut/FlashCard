//
//  FLInfoView.swift
//  flash
//
//  Created by Songwut Maneefun on 1/9/2564 BE.
//

import SwiftUI

protocol FLInfoViewDelegate {
    func didOpenInfo()
}

struct FLInfoView: View {
    @State var detail: FLDetailResult?
    var delegate: FLInfoViewDelegate?
    var didOpenInfo: ((Any?) -> Void)? = nil
    
    var body: some View {
        self.contentView
            .padding(8)
            .background(UIColor.white.color)
    }
    
    private var contentView: some View {
        HStack(alignment: .center, spacing: nil, content: {
            
            Button(action: {
                
            }, label: {
                Image("ic_v2_flashcard")
            })
            .frame(width: 42, height: 42, alignment: .center)
            .foregroundColor(.white)
            .background(Color("4782DA"))
            .cornerRadius(8)
            
            VStack(alignment: .center, spacing: 0, content: {
                Text(detail?.name ?? "")
                    .foregroundColor(Color("222831"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                let name:String = detail?.owner?.name ?? "-"
                    Text("by \(name)")
                    .foregroundColor(Color("979797"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            
            Button(action: {
                didOpenInfo?(nil)
                delegate?.didOpenInfo()
            }, label: {
                Image("info")
                    .foregroundColor(Color.config_secondary50())
            })
            .frame(width: 42, height: 42, alignment: .center)
        })
    }
}

struct FLInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let detail = FLDetailResult(JSON: ["name" : "10 Figma Tricks I WishI Knew..."])!
        FLInfoView(detail: detail)
            .previewLayout(.fixed(width: 343, height: 60))
    }
}
