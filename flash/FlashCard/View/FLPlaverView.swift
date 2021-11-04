//
//  FLPlaverView.swift
//  LEGO
//
//  Created by Songwut Maneefun on 1/11/2564 BE.
//  Copyright © 2564 BE conicle. All rights reserved.
//

import UIKit
import AVKit

class FLPlaverView: UIView {
    var player = AVPlayer()
    var playerItem: AVPlayerItem?
    
    var playerLayer: CALayer?
    var mediaUrl: URL!
    
    func createVideo(url: URL) {
        self.backgroundColor = .black
        mediaUrl = url
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer?.contentsGravity = .resizeAspectFill
        playerLayer?.backgroundColor = UIColor.purple.cgColor
        playerLayer?.frame = self.bounds
        layer.addSublayer(playerLayer!)
        
        
        
        playerItem = AVPlayerItem(url: mediaUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem,
                                               queue: .main) { [weak self] _ in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateUrl(url: URL) {
        mediaUrl = url
        playerItem = AVPlayerItem(url: mediaUrl)
        player.replaceCurrentItem(with: playerItem)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
    }
}
