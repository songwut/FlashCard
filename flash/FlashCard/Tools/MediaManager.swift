//
//  MediaManager.swift
//  flash
//
//  Created by Songwut Maneefun on 19/7/2564 BE.
//

import AVKit

struct MediaManager {
    
    static func time(_ operation: () throws -> ()) rethrows {
        let start = Date()

        try operation()

        let end = Date().timeIntervalSince(start)
        print(end)
    }
    
    static func trimVideo(_ videoUrl: URL, complete:  @escaping (_ url: URL) -> Void) {
        let sourceURL =  videoUrl
        
        if let destinationURL = MediaManager.destinationUrl() {
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
        
    }
    
    static func destinationUrl() -> URL? {
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
}


