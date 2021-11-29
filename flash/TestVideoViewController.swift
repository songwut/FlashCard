//
//  TestVideoViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 16/6/2564 BE.
//

import UIKit
import AVKit

class TestVideoViewController: UIViewController {
    
    var importBtn:UIButton!
    var playerView: UIView!
    var gifView: UIView!
    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    
    var textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.playerView = UIView()
        self.playerView.frame = self.view.frame
        self.view.addSubview(self.playerView)
        
        self.gifView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.gifView.center = self.view.center
        let gif = GIF()
        gif.view = self.gifView
        //https://media.giphy.com/media/9aq5HD3izQNbDadBB1/giphy.gif
        //https://media.giphy.com/media/kEdI683LJtrGmTVVCM/giphy.gif
        let gifUrl = URL(string: "https://media.giphy.com/media/kEdI683LJtrGmTVVCM/giphy.gif")
        gif.startGifAnimation(with: gifUrl, in: self.gifView.layer)
        
        self.view.addSubview(self.gifView)
        //self.gifView.frame
        
        self.player = AVPlayer()
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerView!.layer.addSublayer(self.playerLayer!)
        
        self.importBtn = UIButton(type: .custom)
        self.importBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        self.importBtn.setTitle("import", for: .normal)
        self.importBtn.center = self.view.center
        self.importBtn.addTarget(self, action: #selector(self.importPressed), for: .touchUpInside)
        self.view.addSubview(self.importBtn)
        
        self.textView = UITextView()
        //self.textView.add
        self.textView.text = gifUrl?.absoluteString
        self.textView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        
    }
    
    func play(_ videoURL: URL) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.playerItem = AVPlayerItem(url: videoURL)
        self.player.replaceCurrentItem(with: self.playerItem)
        DispatchQueue.main.async {
            self.playerLayer!.frame = self.view!.bounds
        }
        self.player.play()
        
    }
    
    // Notification Handling
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        player.seek(to: CMTime.zero)
        player.play()
    }
    // Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func trimVideo(_ videoUrl: URL, complete:  @escaping (_ url: URL) -> Void) {
        let sourceURL =  videoUrl
        /*
        if let destinationURL = destinationUrl() {
            do {
                try time {
                    let asset = AVURLAsset(url: sourceURL)
                    let trimmedAsset = try asset.assetByTrimming(seconds: 1.0)
                    
                    try trimmedAsset.export(to: destinationURL) {
                        complete(destinationURL)
                    }
                }
            } catch let error {
                print("💩 \(error)")
            }
        }
        */
        
    }
    
    func destinationUrl() -> URL? {
        guard
          let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first
          else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: Date())
        let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mp4")
        return url
    }
    
    @objc @IBAction func importPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPresetHEVC1920x1080
        //picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func time(_ operation: () throws -> ()) rethrows {
        let start = Date()

        try operation()

        let end = Date().timeIntervalSince(start)
        print(end)
    }


}

extension TestVideoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let movieUrl = info[.mediaURL] as? URL else { return }
        self.trimVideo(movieUrl) { [weak self] (destinationURL) in
            self?.play(destinationURL)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
