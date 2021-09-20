//
//  VideoConvertor.swift
//  flash
//
//  Created by Songwut Maneefun on 20/9/2564 BE.
//

import Foundation
import AVKit

struct VideoConvertor {
    let videoURL: URL
    
    func encodeVideo(videoURL: URL)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)

        var startDate = Date()

        //Create Export session
        var exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)

        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        //Creating temp path to save the converted video

        let name = videoURL.pathExtension
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("\(name).mp4").absoluteString
        let url = URL(fileURLWithPath: myDocumentPath)

        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let filePath = documentsDirectory2.appendingPathComponent("rendered-Video.mp4")
        deleteFile(filePath: filePath)

        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath)
            }
            catch let error {
                print(error)
            }
        }

        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileType.mp4
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession!.timeRange = range

        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession!.status {
            case .failed:
                print("%@",exportSession?.error as Any)
            case .cancelled:
                print("Export canceled")
            case .completed:
                //Video conversion finished
                var endDate = Date()

                var time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful!")
                print(exportSession?.outputURL)

            default:
                break
            }

        })


    }

    func deleteFile(filePath: URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }

        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error)")
        }
    }
}
