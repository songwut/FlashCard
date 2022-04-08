//
//  CustomAVPlayer.swift
//  LEGO
//
//  Created by Apinun on 7/7/2564 BE.
//  Copyright © 2564 BE conicle. All rights reserved.
//

import Foundation
import AVKit

class CustomAVPlayer: AVPlayer {
    
    var isReadySendAction = true
    var didSeek: DidAction?
    var didPlay: DidAction?
    var didPause: DidAction?
    var isNonSkip: Bool = true
    
    override func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: @escaping (Bool) -> Void) {
        super.seek(to: time,
                   toleranceBefore: toleranceBefore,
                   toleranceAfter: toleranceAfter,
                   completionHandler: completionHandler)
        self.didSeek?.handler(time)
    }
    
    var isPlaying: Bool {
        return self.timeControlStatus == .playing
    }
    
    func didSkipNext(durationSkip: Double) {
        guard let duration = self.currentItem?.duration else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(self.currentTime())
        let newTime = playerCurrentTime + durationSkip
        if newTime < (CMTimeGetSeconds(duration)) {
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            self.seek(to: time2, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    func didSkipPrev(durationSkip: Double) {
        let playerCurrentTime = CMTimeGetSeconds(self.currentTime())
            var newTime = playerCurrentTime - durationSkip

            if newTime < 0 {
                newTime = 0
            }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        self.seek(to: time2, toleranceBefore: .zero, toleranceAfter: .zero)
    }
}
