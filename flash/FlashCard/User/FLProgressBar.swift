//
//  FLProgressBar.swift
//  flash
//
//  Created by Songwut Maneefun on 24/9/2564 BE.
//

import SwiftUI

struct FLQuizProgressBar: View {
    @State var choice: FLChoiceResult
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color("F5F5F5"))
                
                Rectangle()
                    .frame(width: min(CGFloat(choice.progressValue)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(choice.infoProgressColor().color)
                    .animation(.linear)
                
                if let isAnswer = choice.isAnswer, isAnswer {
                    HStack(spacing: nil, content: {
                        ZStack(alignment: .leading) {
                            Circle()
                                .fill(Color.white)
                            Image("ic_v2_check")
                                .resizable()
                                .padding(.all, 2)
                                .frame(width: 18, height: 18, alignment: .center)
                                .foregroundColor(UIColor.success().color)
                        }
                        .frame(width: 20, height: 20)
                        .padding([.leading], 8)
                        
                        Text(choice.value)
                            .font(.font(12, font: .medium))
                            .foregroundColor(.white)
                    })
                } else {
                    Text(choice.value)
                        .font(.font(12, font: .medium))
                        .foregroundColor(Color("222831"))
                        .padding([.leading], 16)
                }
                
                if let percent = choice.percent {
                    let text = percent.stringValue + " %"
                    Text(text)
                        .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .trailing)
                        .padding(.trailing, 40)
                        .font(.font(12, font: .bold))
                        .foregroundColor(.black)
                }
                
                
            }.cornerRadius(45.0)
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
            .previewLayout(.fixed(width: 320, height: 300))
            .environment(\.sizeCategory, .small)
    }
}
