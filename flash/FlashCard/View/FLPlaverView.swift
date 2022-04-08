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
    var player:AVPlayer?
    var playerItem: AVPlayerItem?
    
    var playerLayer: CALayer?
    var mediaUrl: URL!
    private var playButton = UIButton()
    private var isPlay = false
    
    func createVideo(url: URL) {
        self.backgroundColor = .background()
        mediaUrl = url
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer?.contentsGravity = .resizeAspectFill
        playerLayer?.backgroundColor = UIColor.black.cgColor
        playerLayer?.frame = self.bounds
        layer.addSublayer(playerLayer!)
        
        playerItem = AVPlayerItem(url: mediaUrl)
        player?.replaceCurrentItem(with: playerItem)
        
        playButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        playButton.setImage(UIImage(named: "ic_v2_play"), for: .normal)
        playButton.tintColor = UIColor("222831")
        playButton.bounds = CGRect(x: 0, y: 0, width: 70, height: 70)
        playButton.cornerRadius = 70 / 2
        playButton.center = self.center
        playButton.alpha = 1.0
        playButton.addTarget(self, action: #selector(self.playPressed), for: .touchUpInside)
        //TODO: will remove next phace
        //addSubview(playButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.playPressed))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    func playLoop() {
        guard let player = self.player else { return }
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func playPressed() {
        DispatchQueue.main.async {
            if self.isPlay {
                self.stop()
            } else {
                self.isPlay = true
                self.playButton.alpha = 0.0
                self.player?.play()
                self.playLoop()
            }
        }
    }
    
    func stop(isEditor: Bool = false) {
        DispatchQueue.main.async {
            self.isPlay = false
            self.player?.pause()
            if isEditor {
                self.playButton.alpha = 1.0
            } else {
                self.playButton.alpha = 0.0
            }
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func stopAndRemove() {
        DispatchQueue.main.async {
            self.isPlay = false
            self.player?.pause()
            self.playerLayer?.removeFromSuperlayer()
            self.player = nil
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func updateUrl(url: URL) {
        mediaUrl = url
        playerItem = AVPlayerItem(url: mediaUrl)
        player?.replaceCurrentItem(with: playerItem)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
        playButton.center = CGPoint(x: self.bounds.width / 2, y:  self.bounds.height / 2)
    }
}
