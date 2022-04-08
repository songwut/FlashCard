//
//  UGCPlayerViewModel.swift
//  UGC
//
//  Created by Songwut Maneefun on 10/3/2565 BE.
//

import AVFoundation
import Combine

final class UGCPlayerViewModel: ObservableObject {
    var player = AVPlayer()
    @Published var isInPipMode: Bool = false
    @Published var isPlaying = false
    
    @Published var isEditingCurrentTime = false
    @Published var currentTime: Double = .zero
    @Published var duration: Double?
    
    @Published var isFullscreen: Bool = false
    @Published var isReciveFullscreen: Bool = false
    @Published var isPlayerEnd: Bool = false
    
    var isPlayerReady: Bool = false
    
    private var subscriptions: Set<AnyCancellable> = []
    private var timeObserver: Any?
    
    deinit {
        if let timeObserver = timeObserver {
            self.player.removeTimeObserver(timeObserver)
        }
    }
    
    init() {
        $isEditingCurrentTime
            .dropFirst()
            .filter({ $0 == false })
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.player.seek(to: CMTime(seconds: self.currentTime, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                if self.player.rate != 0 {
                    self.player.play()
                }
                print("")
            })
            .store(in: &subscriptions)
        
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
        .sink { [weak self] _ in
            //self?.player.seek(to: CMTime.zero)//if need auto replay
            self?.isPlayerEnd = true
        }
        .store(in: &subscriptions)
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if self.isEditingCurrentTime == false {
                self.currentTime = time.seconds
            }
        }
    }
    
    func setCurrentItem(_ item: AVPlayerItem) {
        self.currentTime = .zero
        self.duration = nil
        self.player.replaceCurrentItem(with: item)
        self.isPlayerReady = true
        
        item.publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .sink(receiveValue: { [weak self] _ in
                self?.duration = item.asset.duration.seconds
            })
            .store(in: &subscriptions)
    }
    
    func setUrl(_ urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }
        let item = AVPlayerItem(url: url)
        self.currentTime = .zero
        self.duration = nil
        self.player.replaceCurrentItem(with: item)
        self.isPlayerReady = true
        
        item.publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .sink(receiveValue: { [weak self] _ in
                self?.duration = item.asset.duration.seconds
            })
            .store(in: &subscriptions)
    }
    
    var currentTimeText:String {
        let secs = Int(self.currentTime)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        let timeLeft = self.duration(hrs: hours, mins: minutes, secs: seconds)
        return timeLeft
        
    }
    
    private func duration(hrs: Int, mins: Int, secs: Int) -> String {
        if hrs >= 1 {
            return String(format:"%02i:%02i:%02i", hrs, mins, secs)
        } else {
            return String(format:"%02i:%02i", mins, secs)
        }
    }
}

