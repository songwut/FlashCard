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
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color("F5F5F5"))
                
                Rectangle()
                    .cornerRadius(8.0)
                    .frame(width: min(CGFloat(choice.progressValue)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(choice.infoProgressColor().color)
                    .animation(.linear)
                
                if let isAnswer = choice.isAnswer, isAnswer {
                    let iconW = geometry.size.height * 0.6
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
                    })
                } else {
                    Text(choice.value)
                        .font(titleFont)
                        .foregroundColor(Color("222831"))
                        .padding([.leading], 16)
                }
                
                if let percent = choice.percent {
                    let text = percent.stringValue + " %"
                    Text(text)
                        .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .trailing)
                        .padding(.trailing, 40)
                        .font(titleFont)
                        .foregroundColor(.black)
                }
                
                
            }.cornerRadius(8.0)
        }
    }
}

struct FLProgressContentView: View {
    @State var choice: FLChoiceResult
    
    var body: some View {
        VStack {
            FLQuizProgressBar(choice:choice)
                .frame(height: 36)
            
            Button(action: {
                startProgressBar()
            }) {
                Text("Start Progress")
            }.padding()
            
            Button(action: {
                resetProgressBar()
            }) {
                Text("Reset")
            }
            
            Spacer()
        }.padding()
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
        let c = FLChoiceResult(JSON: ["value" : "ฮอกไกโด", "is_answer":true, "percent": 70])!
        FLProgressContentView(choice: c)
            .previewDevice("iPad (8th generation)")
            .previewLayout(.fixed(width: 320, height: 300))
            .environment(\.sizeCategory, .small)
    }
}
