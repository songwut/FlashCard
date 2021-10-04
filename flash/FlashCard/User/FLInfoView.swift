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
    
    var delegate: FLInfoViewDelegate?
    
    var body: some View {
        self.box
            .background(UIColor.white.color)
            .cornerRadius(8)
            .border(UIColor("D0D3D6").color, width: 1)
    }
    
    var box: some View {
        self.contentView
            .padding(8)
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
                Text("10 Figma Tricks I WishI Knew...")
                    .foregroundColor(Color("222831"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("by username")
                    .foregroundColor(Color("979797"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            
            Button(action: {
                delegate?.didOpenInfo()
            }, label: {
                Image("info")
                    .foregroundColor(Color(UIColor.config.secondary50()))
            })
            .frame(width: 42, height: 42, alignment: .center)
        })
    }
}

struct FLInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FLInfoView()
            .previewLayout(.fixed(width: 343, height: 60))
    }
}
