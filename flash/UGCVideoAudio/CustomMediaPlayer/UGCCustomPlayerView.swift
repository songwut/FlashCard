//
//  UGCCustomPlayerView.swift
//  flash
//
//  Created by Songwut Maneefun on 10/3/2565 BE.
//https://www.createwithswift.com/custom-video-player-with-avkit-and-swiftui-supporting-picture-in-picture/

import SwiftUI
import AVFoundation

struct UGCCustomPlayerView: View {
    @EnvironmentObject private var viewModel: UGCCreateMediaViewModel
    @StateObject var playerVM: UGCPlayerViewModel
    @State var isNeedMargin = false
    
    func initAVAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                CustomVideoPlayer(playerVM: self.playerVM)
                    .overlay(
                        CustomControlsView(playerVM: self.playerVM, isNeedMargin: self.isNeedMargin)
                             , alignment: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
        .onAppear {
            self.initAVAudioSession()
            self.playerVM.setUrl(self.viewModel.detail.url)
            self.playerVM.player.play()
        }
        .onDisappear {
            self.playerVM.player.pause()
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct UGCCustomPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        UGCCustomPlayerView(playerVM: UGCPlayerViewModel(), isNeedMargin: false)
    }
}
