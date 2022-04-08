//
//  MediaPreview.swift
//  flash
//
//  Created by Songwut Maneefun on 8/3/2565 BE.
//

import SwiftUI
import AVKit

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    
    init(frame: CGRect, player:AVPlayer) {
      super.init(frame: frame)
      
      playerLayer.player = player
      layer.addSublayer(playerLayer)
    }
                    
    required init?(coder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
    }
                    
    override func layoutSubviews() {
      super.layoutSubviews()
      playerLayer.frame = bounds
    }
}

struct PlayerControlsView : View {
  @State var playerPaused = true
  @State var seekPos = 0.0
  let player: AVPlayer
  var body: some View {
    HStack {
      Button(action: {
        self.playerPaused.toggle()
        if self.playerPaused {
          self.player.pause()
        }
        else {
          self.player.play()
        }
      }) {
        Image(systemName: playerPaused ? "ic_v2_play" : "ic_v2_pause")
          .padding(.leading, 20)
          .padding(.trailing, 20)
      }
        Slider(value: $seekPos, in: 0.0...1.0) {
            
        } minimumValueLabel: {
            
        } maximumValueLabel: {
            
        } onEditingChanged: { isChange in
            guard let item = self.player.currentItem else { return}
            let targetTime = self.seekPos * item.duration.seconds
            self.player.seek(to: CMTime(seconds: targetTime, preferredTimescale: 600))
        }
        .padding(.trailing, 20)
    }
  }
}

struct MediaPreview: View {
    var url: URL?
    var body: some View {
        MediaPreviewVCRep(url: self.url)
    }
}


struct MediaPreviewVCRep: UIViewControllerRepresentable {
    
    var url: URL?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIStoryboard(name: "LivePlayer", bundle: nil).instantiateViewController(withIdentifier: "PlayerNormalFullScreenViewController") as! PlayerNormalFullScreenViewController
        guard let url = self.url else { return PlayerNormalFullScreenViewController() }
        let player = CustomAVPlayer()
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: item)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
