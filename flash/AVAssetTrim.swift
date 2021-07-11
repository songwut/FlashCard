import AVFoundation
import Foundation

extension FileManager {
    func removeFileIfNecessary(at url: URL) throws {
        guard fileExists(atPath: url.path) else {
            return
        }

        do {
            try removeItem(at: url)
        }
        catch let error {
            throw TrimError("Couldn't remove existing destination file: \(error)")
        }
    }
}

struct TrimError: Error {
    let description: String
    let underlyingError: Error?

    init(_ description: String, underlyingError: Error? = nil) {
        self.description = "TrimVideo: " + description
        self.underlyingError = underlyingError
    }
}

extension AVMutableComposition {
    convenience init(asset: AVAsset) {
        self.init()
        
        for track in asset.tracks {
            addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
        }
    }
    
    func trim(timeOffStart: Double) {
        let duration = CMTime(seconds: timeOffStart, preferredTimescale: 1)
        let timeRange = CMTimeRange(start: CMTime.zero, duration: duration)
        
        for track in tracks {
            track.removeTimeRange(timeRange)
        }
        
        removeTimeRange(timeRange)
    }
}

extension AVAsset {
    func assetByTrimming(seconds: Double) throws -> AVAsset {
        let duration = CMTime(seconds: seconds, preferredTimescale: 1)
        let timeRange = CMTimeRange(start: CMTime.zero, duration: duration)

        let composition = AVMutableComposition()
        
        for track in tracks {
            print("mediaType: \(track.mediaType.rawValue)")
            print("timeRange: \(timeRange.start) - \(timeRange.end)")
            let compositionTrack = composition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
            try compositionTrack?.insertTimeRange(timeRange, of: track, at: CMTime.zero)
        }

        return composition
    }

    func export(to destination: URL, complete: @escaping () -> Void) throws {
        guard let exportSession = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetPassthrough) else {
            throw TrimError("Could not create an export session")
        }
        
        exportSession.outputURL = destination
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        let group = DispatchGroup()
        
        group.enter()
        
        try FileManager.default.removeFileIfNecessary(at: destination)
        
        exportSession.exportAsynchronously {
            group.leave()
            complete()
        }
        
        group.wait()
        
        if let error = exportSession.error {
            throw TrimError("error during export", underlyingError: error)
        }
    }
}


