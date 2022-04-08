//
//  CustomControlsView.swift
//  UGC
//
//  Created by Songwut Maneefun on 10/3/2565 BE.
//


import SwiftUI

struct CustomControlsView: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var playerVM: UGCPlayerViewModel
    private let iconColor: Color = .white
    private let buttonWidth: CGFloat = UIDevice.isIpad() ? 35 : 24
    @State var isNeedMargin = false
    
    var body: some View {
        HStack {
            if playerVM.isPlaying == false {
                Button(action: {
                    playerVM.player.play()
                }, label: {
                    Image("ic_v2_play")
                        .resizable()
                        .padding(4)
                        .frame(width: buttonWidth, height: buttonWidth)
                        .foregroundColor(self.iconColor)
                })
                    .frame(width: buttonWidth, height: buttonWidth)
            } else {
                Button(action: {
                    playerVM.player.pause()
                }, label: {
                    Image("ic_v2_pause")
                        .resizable()
                        .padding(4)
                        .frame(width: buttonWidth, height: buttonWidth)
                        .foregroundColor(self.iconColor)
                })
                    .frame(width: buttonWidth, height: buttonWidth)
            }
            
            if let duration = playerVM.duration {
                Slider(value: $playerVM.currentTime, in: 0...duration) {
                    Text("")
                } minimumValueLabel: {
                    Text("")
                } maximumValueLabel: {
                    Text("\(playerVM.currentTimeText)")
                        .font(.font(UIDevice.isIpad() ? 18 : 10, .medium))
                        .foregroundColor(.white)
                } onEditingChanged: { isEditing in
                    playerVM.isEditingCurrentTime = isEditing
                }
            } else {
                Spacer()
            }
            
            Button(action: {
                if self.playerVM.isFullscreen {
                    self.presentation.wrappedValue.dismiss()//uikit
                }
                self.playerVM.isReciveFullscreen.toggle()
                
            }, label: {
                Image("ic_v2_expand")
                    .resizable()
                    .padding(4)
                    .frame(width: buttonWidth, height: buttonWidth)
                    .foregroundColor(self.iconColor)
            })
                .frame(width: buttonWidth, height: buttonWidth)
            
        }
        .padding(self.isNeedMargin ? 20 : 8)
    }
}
