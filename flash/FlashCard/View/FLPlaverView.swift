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
    private var playButtonBg = UIView()
    private var playButton = UIButton()
    private var isPlay = false
    
    func createVideo(url: URL) {
        self.backgroundColor = .background()
        mediaUrl = url
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer?.contentsGravity = .resizeAspectFill
        playerLayer?.backgroundColor = UIColor.purple.cgColor
        playerLayer?.frame = self.bounds
        layer.addSublayer(playerLayer!)
        
        playerItem = AVPlayerItem(url: mediaUrl)
        player.replaceCurrentItem(with: playerItem)
        
        playButtonBg.backgroundColor = .clear
        playButtonBg.bounds = CGRect(x: 0, y: 0, width: self.bounds.width - 20, height: self.bounds.height - 20)
        
        playButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        playButton.setImage(UIImage(named: "ic_v2_play"), for: .normal)
        playButton.tintColor = UIColor("222831")
        playButton.bounds = CGRect(x: 0, y: 0, width: 70, height: 70)
        playButton.cornerRadius = 70 / 2
        playButton.center = self.center
        playButton.alpha = 1.0
        playButton.addTarget(self, action: #selector(self.playPressed), for: .touchUpInside)
        playButtonBg.addSubview(playButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.playPressed))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    func playLoop() {
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
    
    @objc func playPressed() {
        if isPlay {
            isPlay = false
            playButton.alpha = 1.0
            player.pause()
            NotificationCenter.default.removeObserver(self)
        } else {
            isPlay = true
            playButton.alpha = 0.0
            player.play()
            playLoop()
        }
    }
    
    func updateUrl(url: URL) {
        mediaUrl = url
        playerItem = AVPlayerItem(url: mediaUrl)
        player.replaceCurrentItem(with: playerItem)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
        playButton.center = CGPoint(x: self.bounds.width / 2, y:  self.bounds.height / 2)
        playButtonBg.bounds = CGRect(x: 0, y: 0, width: self.bounds.width - 20, height: self.bounds.height - 20)
    }
}
