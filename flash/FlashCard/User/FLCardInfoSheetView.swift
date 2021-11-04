//
//  FLCardInfoSheetView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/9/2564 BE.
//

import SwiftUI

protocol FLCardInfoSheetViewDelegate {
    func cardInfoSheetViewLoaded(_ view: FLCardInfoSheetView)
    func cardInfoSheetViewGetSize(_ size: CGSize)
    func cardInfoSheetViewOpenQuiz(_ view: FLCardInfoSheetView)
}

struct FLCardInfoSheetView: View {
    var delegate: FLCardInfoSheetViewDelegate?
    @State var isQuiz: Bool
    @State var tags = ["UX/UI","Figma","Soft Skill","Design","Release","Language","Fulltextsearch","Internalreleation", "Article", "Podcast"]
    
    var body: some View {
        GeometryReader { geometry in
            ContentView
            .frame(minWidth: 0, maxWidth: .infinity ,minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(.all, 8)
                .onAppear(perform: {
                    delegate?.cardInfoSheetViewGetSize(geometry.size)
                })
                .onLoad {
                    delegate?.cardInfoSheetViewLoaded(self)
                }
        }
    }
    
    var ContentView: some View {
        ZStack {
            VStack(spacing: 8, content: {
                TopView
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                
                HStack(alignment: .top, spacing: 8, content: {
                    VStack {
                        LeftView
                            .frame(maxWidth: 80, maxHeight: .infinity, alignment: .leading)
                            .clipped()
                        Spacer()
                    }
                    
                    VStack {
                        RightView
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    }
                    .background(Color.pink)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                Divider()
                
                FootertView
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .bottom)
            })
            
        }
    }
    
    var TopView: some View {
        HStack(spacing: 8, content: {
            Button(action: {
                
            }, label: {
                Image("ic_v2_chevron-down")
                    .foregroundColor(.black)
            })
            .padding(.leading, 8)
            .frame(maxWidth: 24, maxHeight: 24, alignment: .leading)
            
            Spacer()
            Text("card-info-cover")
                .frame(maxWidth: .infinity ,maxHeight: 50, alignment: .center)
            
        })
    }
    
    var LeftView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                let img = UIImage(named: "coverItem")
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(img?.averageColor?.color ?? .black)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 80, height: 80, alignment: .center)
                Image(uiImage: img ?? UIImage())
                    .cornerRadius(8)
            }
            .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
            .padding(.top, 8)
            .clipped()
            
            Spacer()
                .frame(height: 100)
        }
        .frame(maxWidth: 80, maxHeight: 80, alignment: .leading)
    }
    
    var RightView: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            let titleFont = UIFont.font(14, .medium)
            let font = UIFont.font(10, .text)
            Text("10 Figma Tricks I Wish I Knew Earlier")
                .font(titleFont.font)
            Text("Instructor: Nof Chanwit")
                .font(font.font)
            Text("Content Provider: ConicleX")
                .font(font.font)
            Text("Category: Design")
                .font(font.font)
            Text("I’m consistently impressed by all the useful features Figma has baked into their app. What used to be a workaround in Sketch is now a thought out feature in Figma — a breath of fresh air.")
                .font(font.font)
            
            FLTagListView(tags: $tags)
            
            Spacer()
        })
        .background(Color.white)
    }
    
    var FootertView: some View {
        HStack(spacing: 30, content: {
            Button(action: {
                //view tap
            }, label: {
                HStack(spacing: 8, content: {
                    Image("ic_v2_view")
                        .resizable()
                        .padding(.all, 2)
                        .frame(width: 18, height: 18, alignment: .center)
                    Text("9,999")
                })
                
            })
            
            if isQuiz {
                Button(action: {
                    //quiz
                }, label: {
                    HStack(spacing: 8, content: {
                        Image("message-circle")
                            .resizable()
                            .padding(.all, 2)
                            .frame(width: 18, height: 18, alignment: .center)
                        Text("quiz".localized())
                    })
                    
                })
            }
            
            Spacer()
        })
    }
    
}

struct FLCardInfoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FLCardInfoSheetView(isQuiz: true)
            .previewLayout(.fixed(width: 375, height: 286))
            .environment(\.sizeCategory, .small)
    }
}
