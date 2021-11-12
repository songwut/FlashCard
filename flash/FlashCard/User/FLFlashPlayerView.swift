//
//  FLFlashPlayerView.swift
//  flash
//
//  Created by Songwut Maneefun on 27/10/2564 BE.
//

import SwiftUI

struct FLFlashPlayerView: View {//need to fix many things
    @ObservedObject var viewModel: FLFlashCardObser
    //@State var detail: FLDetailResult
    //@State var list: [FLCardPageResult]
    var vm:FLFlashCardViewModel
    var playerState: FLPlayerState = .user
    var dismiss: ((Any?) -> Void)? = nil
    @State private var isLoading = false
   
    @Environment(\.presentationMode) var presentationMode
    let buttonBorderColor = Color("525252")
    
    var body: some View {
        ContainerView
            .onAppear(perform: {
                //prepare parame here
            })
            .onAppear {
                if !isLoading {
                    viewModel.prepareFirstCard()
                }
            }
    }
    
    var ContainerView: some View {
        ZStack {
            GeometryReader(content: { geometry in
                VStack(alignment: .center, content: {
                    if self.playerState == .user {
                        TopView
                            .frame(height: 50)
                            .padding([.leading, .trailing], 16)
                    }
                    //self.footerMargin.constant = UIDevice.isIpad() ? 60.0 : 16.0
                    //self.leftButton.tintColor = UIColor.config_secondary()
                    //self.rightButton.tintColor = UIColor.config_secondary()
                    
                    FLUserProgressView()
                        .frame(height: 50)
                        .padding([.leading, .trailing], 16)
                    
                    let stageWidth = geometry.size.width * FlashStyle.pageCardWidthRatio
                    let stageHidth = stageWidth * FlashStyle.pageCardRatio
                   
                    let stageSize = CGSize(width: stageWidth, height: stageHidth)
                    
                    VStack(alignment: .center, spacing: nil, content: {
                        if viewModel.cardDeck.activeCard != nil {
                            CardSwipeLoopView(deck: viewModel.cardDeck, cardSize: stageSize, flCreator: FLCreator(isEditor: false), viewModel: vm)
                        } else {
                            Rectangle()
                                .background(Color.clear)
                        }
                    })
                    .frame(height: .infinity)
                    
                    ButtonControlView
                        .frame(height: geometry.size.height * 0.1)
                        .padding([.leading, .trailing], 16)
                    
                    FLInfoView(detail: viewModel.detail) {_ in
                        print("FLInfoView info")
                    }
                    .border(Color("D0D3D6"), width: 1)
                    .padding([.leading, .trailing], 16)
                    .cornerRadius(8)
                    
    //                FLInfoView(detail: detail)
    //                    .cornerRadius(8)
    //                    .border(Color("D0D3D6"), width: 1)
    //                    .padding([.leading, .trailing], 16)
                    
                    Rectangle()
                        .frame(height: UIDevice.isIpad() ? 60.0 : 16.0, alignment: .center)
                    
                    //Spacer(minLength: )
                })
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .background(Color.background())
                
            })
        }
        .background(Color.white)
        .preferredColorScheme(.light)
    }
    
    var TopView: some View {
        VStack(alignment: .center, spacing: nil, content: {
            HStack(alignment: .center, spacing: nil, content: {
                Text(viewModel.detail?.name ?? "")
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    dismiss?(nil)//from UIKit
                    presentationMode.wrappedValue.dismiss()//from SwiftUI
                }, label: {
                    Image("ic_v2_close")
                })
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundColor(.black)
                .background(Color.clear)
            })
        })
    }
    
    var ButtonControlView: some View {
        VStack(alignment: .center, spacing: nil, content: {
            HStack(alignment: .center, spacing: nil, content: {
                
                Button(action: {
                    
                }, label: {
                    Image("ic_v2_chevron-left")
                        .foregroundColor(.black)
                        .frame(width: 60, height: 60, alignment: .center)
                
                })
                .frame(width: 60, height: 60, alignment: .center)
                .buttonStyle(
                    ButtonBorderCircle(
                        color: buttonBorderColor,
                        lineWidth: 2)
                )
                
                Spacer()
                Text(viewModel.detail?.name ?? "")
                    .foregroundColor(.black)
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image("ic_v2_chevron-right")
                        .foregroundColor(.black)
                        .frame(width: 60, height: 60, alignment: .center)
                
                })
                .frame(width: 60, height: 60, alignment: .center)
                .buttonStyle(
                    ButtonBorderCircle(
                        color: buttonBorderColor,
                        lineWidth: 2)
                )
            })
            .frame(width: 216, alignment: .center)
        })
    }
}

struct FLFlashPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        FLFlashPlayerView(viewModel: FLFlashCardObser(flashId: 6), vm: FLFlashCardViewModel(flashId: 6))
    }
}
