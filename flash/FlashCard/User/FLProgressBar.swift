//
//  FLProgressBar.swift
//  flash
//
//  Created by Songwut Maneefun on 24/9/2564 BE.
//

import SwiftUI

struct FLQuizProgressBar: View {
    @State var choice: FLChoiceResult
    private let titleFont: Font = .font(UIDevice.isIpad() ? 24 : 12, font: .medium)
    var width:CGFloat = 200
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(maxWidth: width, maxHeight: .infinity)
                .foregroundColor(Color("D3D3D3"))
            
            Rectangle()
                .cornerRadius(8.0)
                .frame(maxWidth: min(CGFloat(choice.progressValue) * width, width), maxHeight: .infinity)
                .foregroundColor(choice.infoProgressColor().color)
                .animation(.linear)
            
            if let isAnswer = choice.isAnswer, isAnswer {
                let iconW: CGFloat = UIDevice.isIpad() ? 44 : 20
                let imageW = iconW * 0.9
                let padding = (iconW - imageW) / 2
                let leading: CGFloat = UIDevice.isIpad() ? 16 : 8
                HStack(spacing: nil, content: {
                    ZStack(alignment: .leading) {
                        Circle()
                            .fill(Color.white)
                        Image("ic_v2_check")
                            .resizable()
                            .padding([.leading], padding)
                            .frame(width: imageW, height: imageW, alignment: .center)
                            .foregroundColor(UIColor.success().color)
                    }
                    .frame(width: iconW, height: iconW)
                    .padding([.leading], leading)
                    
                    Text(choice.value)
                        .font(titleFont)
                        .foregroundColor(.white)
                        .lineLimit(nil)
                })
            } else {
                Text(choice.value)
                    .font(titleFont)
                    .foregroundColor(Color("222831"))
                    .lineLimit(nil)
                    .padding([.leading], 16)
            }
            
            if let percent = choice.percent {
                let text = percent.stringValue + " %"
                Text(text)
                    .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .trailing)
                    .padding(.trailing, 25)
                    .font(titleFont)
                    .foregroundColor(.black)
            }
        }
        .cornerRadius(8.0)
        .frame(maxWidth: width, minHeight: FlashStyle.quiz.choiceMinHeight)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct FLProgressContentView: View {
    @State var choice: FLChoiceResult
    
    var body: some View {
        GeometryReader { geometry in
            FLQuizProgressBar(choice:choice, width: geometry.size.width)
                //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
        }
        
    }
    
    func startProgressBar() {
        for _ in 0...80 {
            choice.progressValue += 0.015
        }
    }
    
    func resetProgressBar() {
        choice.progressValue = 0.0
    }
}

struct FLProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        let c = FLChoiceResult(JSON: ["value" : "ฮอกไกโด fgdd ffdg f ds gdf fgffd gd fdfdfdfdf dfg dgfgf dff ffd gff gfg", "is_answer":true, "percent": 70])!
        FLProgressContentView(choice: c)
            .previewDevice("iPad (8th generation)")
            .previewLayout(.fixed(width: 620, height: 500))
            .environment(\.sizeCategory, .small)
    }
}
