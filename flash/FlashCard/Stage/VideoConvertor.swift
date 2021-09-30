//
//  VideoConvertor.swift
//  flash
//
//  Created by Songwut Maneefun on 20/9/2564 BE.
//

import Foundation
import AVKit

class VideoConvertor {
    init(videoURL: URL) {
        self.videoURL = videoURL
    }
    
    var videoURL: URL
    var assetExport: AVAssetExportSession!
    var timeInterval: Timer?
    
    func endTime() {
        self.timeInterval?.invalidate()
        self.timeInterval = nil
    }
    
    func encodeVideo( progressing: @escaping ((Float) -> Void), completion: @escaping ((URL?, Error?) -> Void))  {
        let avAsset = AVURLAsset(url: self.videoURL, options: nil)
            
        let startDate = Date()
            
        //Create Export session
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
            completion(nil, nil)
            return
        }
        
        self.assetExport = exportSession
        
        self.timeInterval = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            let progress = Float(exportSession.progress)
            print("progress:\(progress)")
                if (progress < 0.99) {
                    progressing(progress)
                } else if progress == 1.0 {
                    progressing(progress)
                    self.endTime()
                }
        })
            
        //Creating temp path to save the converted video
        let name = self.videoURL.deletingPathExtension().lastPathComponent//videoURL.pathExtension
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsDirectory.appendingPathComponent("\(name).mp4")
            
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                completion(nil, error)
            }
        }
            
        exportSession.outputURL = filePath
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
            
        exportSession.exportAsynchronously(completionHandler: {() -> Void in
            
            switch exportSession.status {
            case .failed:
                print(exportSession.error ?? "NO ERROR")
                completion(nil, exportSession.error)
            case .cancelled:
                print("Export canceled")
                completion(nil, nil)
            case .completed:
                //Video conversion finished
                let endDate = Date()
                    
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful!")
                print(exportSession.outputURL ?? "NO OUTPUT URL")
                completion(exportSession.outputURL, nil)
                    
                default: break
            }
                
        })
    }
    
    
}
