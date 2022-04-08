//
//  UGCPlayerFullScreenViewController.swift
//  LEGO
//
//  Created by Songwut Maneefun on 11/3/2565 BE.
//  Copyright © 2565 BE conicle. All rights reserved.
//

import UIKit
import AVKit
import IQKeyboardManagerSwift

class UGCPlayerFullScreenViewController: UIViewController, AVPlayerViewControllerDelegate {

    @IBOutlet weak var closeFullscreenButton: UIButton!
    @IBOutlet weak var imageView: UIImageView! // FOR AUDIO
    @IBOutlet weak var videoView: UIView! // FOR VIDEO
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var footerBGView: GradientView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var progressRerunView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeSlider: PlayerSlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var pipButton: UIButton!
    
    var playerVM: UGCPlayerViewModel!
    var isShowMediaControl = false
    var isUserSlidingUI = false
    var player: AVPlayer = AVPlayer()
    var playerViewController: AVPlayerViewController!
    var playerTimer: Timer?
    var typeVideo: TypeVideo?
    var contentCode: ContentCode = .video
    
    var didDismiss: DidAction?
    var didPip: DidAction?
    
    var viewModel: UGCPlayerFullScreenViewModel! {
        didSet {
            self.contentCode = self.viewModel.contentCode
            
            guard let mediaUrl = self.viewModel?.mediaUrl else { return }
            if let playerVM = self.playerVM {
                self.currentTime = playerVM.currentTime
                self.player = playerVM.player
                self.playerVM.player.play()
                
            } else {
                self.playerVM = UGCPlayerViewModel()
                self.playerVM.setUrl(mediaUrl.absoluteString)
                self.player = self.playerVM.player
                self.playerVM.player.play()
            }
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, preferredTimescale: 1)
            player.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (completed) in
                //do some update
            }
        }
    }

//    var playerAction: SendPlayerAction! {
//        didSet {
//            if let playerAction = self.playerAction {
//                UserManager.shared.playerAction = playerAction
//            }
//        }
//    }
    
    private var lastCurrentTime:Double = 0.0
    private var currentMaxTime:CMTime!
    private var playerParamModel = UGCPlayerParamModel()//may use in 5.0
    private var timeObserverToken: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        IQKeyboardManager.shared.enable = false
        
        self.view.backgroundColor = .black
        self.view.updateLayout()
        self.showMediaControl()
        self.controlView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showMediaControl)))
        self.showMediaControl()
        self.videoView.isHidden = false
        self.imageView.isHidden = false
        self.checkStatusVideoOrAudio()
        
        self.videoView.updateLayout()
        self.footerBGView.updateLayout()
        self.controlView.updateLayout()

        self.playButton.tintColor = .white
        self.currentTimeLabel.font = FontHelper.getFont(.regular, size: .tiny)
        self.currentTimeLabel.textColor = .white
        
        self.footerBGView.startLocation = 0.0
        self.footerBGView.endLocation = 1.0
        self.footerBGView.startColor = UIColor.black.withAlphaComponent(0.0)
        self.footerBGView.endColor = UIColor.black.withAlphaComponent(1.0)
        
        self.playButton.addTarget(self, action: #selector(self.playMedia), for: .touchUpInside)
        
        self.playerViewController = AVPlayerViewController()
        self.playerViewController.allowsPictureInPicturePlayback = true
        self.playerViewController.player = self.player
        self.updatePlayer(self.player)
        self.playerViewController.modalPresentationStyle = .fullScreen
        self.playerViewController.modalTransitionStyle = .crossDissolve
        self.playerViewController.view.frame = self.view.bounds
        
        self.footerView.isHidden = false
        
        self.playerViewController.showsPlaybackControls = false
        self.videoView.updateLayout()
        self.videoView.addSubview(self.playerViewController.view)
        self.playerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadPlayer), userInfo: nil, repeats: true)
        self.progressRerunView.isHidden = false
        
        self.timeSlider.addTarget(self, action: #selector(self.timeSliderDidChange(_:)), for: .valueChanged)
        self.timeSlider.translatesAutoresizingMaskIntoConstraints = true
        self.timeSlider.autoresizingMask = .flexibleWidth
        self.timeSlider.addTarget(self, action: #selector(self.didEndSeek), for: [.touchUpInside , .touchUpOutside])
        self.timeSlider.setValue(Float(self.currentTime), animated: true)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        } catch let error {
            print("Error in AVAudio Session\(error.localizedDescription)")
        }
        self.setupPlayerPeriodicTimeObserver(player: self.player)
        self.playerViewController.player?.play()
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.setPlaybackProgress()
        }
    }
    
    private func setupPlayerPeriodicTimeObserver(player: AVPlayer) {
        guard timeObserverToken == nil else { return }
        
        let time = CMTimeMake(value: 1, timescale: 1)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) {
            [weak self] time in
            self?.setTimeSliderValue(Float(CMTimeGetSeconds(time)))
        } as AnyObject?
    }
    
    func setTimeSliderValue(_ value: Float) {
        print("setTimeSliderValue: \(value)")
        self.timeSlider.value = value
        let newRate = self.player.rate
        let iconImage = newRate == 0.0 ? "ic_v2_play" : "ic_v2_pause"
        
        if let icon = UIImage(named: iconImage) {
            self.playButton.setImage(icon, for: .normal)
            self.playButton.tintColor = .white
        }
    }
    
    @objc func setPlaybackProgress() {
        if let currentItem = self.player.currentItem {
            let current = currentItem.currentTime()
            let duration = currentItem.duration
            let floatTime = Float(CMTimeGetSeconds(current))
            self.currentMaxTime = duration
            self.currentTimeLabel.text = current.readableText
            self.timeSlider.value = floatTime
            
            print("floatTime: \(floatTime)")
            
            self.timeSlider.minimumValue = 0.0
            self.timeSlider.maximumValue = duration.seconds.isNaN ? 0.0 : Float(CMTimeGetSeconds(duration))
        }
    }

    @objc func didEndSeek() {
        self.isUserSlidingUI = false
        if let currentItem = self.player.currentItem {
            let current = currentItem.currentTime()
            self.lastCurrentTime = Double(CMTimeGetSeconds(self.player.currentTime()))
            self.getDurationParameter(duration: current.parameterInt)
        }
        //self.playerAction = .seek
    }

    @objc func timeSliderDidChange(_ sender: UISlider) {
        self.isUserSlidingUI = true
        self.currentTime = Double(sender.value)
    }
    
    func getDurationParameter(duration: Int) {
        
        self.playerParamModel.durationInt = duration
        if self.playerParamModel.durationMax != nil {
            self.playerParamModel.durationMax = duration
        }
    }
    
    func updatePlayer(_ player: AVPlayer) {
        self.playerViewController.player = player
    }
    
    @objc func reloadPlayer() {
        if self.player.timeControlStatus != .playing {
            self.updatePlayer(self.player)
            DispatchQueue.main.async {
                self.playerViewController.player?.play()
            }
            
            ConsoleLog.show("Reload fullscreen player: \(self.player.timeControlStatus.rawValue), Reason: \(String(describing: self.player.reasonForWaitingToPlay))")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" && (change?[NSKeyValueChangeKey.newKey] as? Float) == 0 {
            ConsoleLog.show("stop")
        } else if keyPath == "rate" && (change?[NSKeyValueChangeKey.newKey] as? Float) == 1 {
            ConsoleLog.show("play")
        } else {
            ConsoleLog.show("keyPath:\(String(describing: keyPath))")
        }
    }
    
    @objc func playMedia() {
        if self.player.rate != 1.0 {
            self.player.play()
            if self.playerTimer == nil {
                self.playerTimer = Timer.scheduledTimer(timeInterval: 1,
                                                  target:self,
                                                  selector: #selector(self.reloadPlayer),
                                                  userInfo: nil,
                                                  repeats: true)
            }
        } else {
            self.playerStop()
        }
    }
    
    @objc func playerStop() {
        self.player.pause()
        if playerTimer != nil {
            self.playerTimer?.invalidate()
            self.playerTimer = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playerTimer?.invalidate()
        self.playerTimer = nil
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        AppUtilityCustom.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    func checkStatusVideoOrAudio() {
        if self.contentCode == .audio {
            self.videoView.isHidden = true
            self.imageView.isHidden = false
            self.pipButton.isHidden = true
            self.imageView.setImage(self.viewModel.coverImage, placeholderImage: self.contentCode.getDefaultImage())
        } else {
            self.pipButton.isHidden = true
            /* open if need implement
            if #available(iOS 14.0, *), AVPictureInPictureController.isPictureInPictureSupported() {
                self.pipButton.isHidden = false
            } else {
                self.pipButton.isHidden = true
            }
            */
            self.videoView.isHidden = false
            self.imageView.isHidden = true
        }
    }
    
    @objc func showMediaControl() {
        self.pipButton?.alpha = self.isShowMediaControl ? 1.0 : 0.0
        self.closeFullscreenButton.alpha = self.isShowMediaControl ? 1.0 : 0.0
        self.currentTimeLabel.alpha = self.isShowMediaControl ? 1.0 : 0.0
        self.timeSlider.alpha = self.isShowMediaControl ? 1.0 : 0.0
        self.playButton.alpha = self.isShowMediaControl ? 1.0 : 0.0
        self.isShowMediaControl = !self.isShowMediaControl
        
        if !self.isUserSlidingUI {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if self.isShowMediaControl == false {
                    self.isShowMediaControl = false
                    self.showMediaControl()
                }
            }
        }
    }
    
    @IBAction func closeFullscreenButton(_ sender: Any) {
        if self.viewModel.isNeedStopWhenClose {
            self.playerStop()
        }
        self.dismiss(animated: true, completion: nil)
        self.didDismiss?.handler(true)
    }
    
    @IBAction func pipButton(_ sender: Any) {
        self.dismiss(animated: true) {
            self.didPip?.handler(nil)
        }
    }
}
