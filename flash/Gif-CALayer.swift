import AVFoundation
import UIKit

class GIF {
    var view:UIView?
    var center = CGPoint.zero
    var size:CGSize?
    typealias completeSize = (_ size:CGSize) -> Void
    
    func startGifAnimation(with url: URL?, in layer: CALayer?) {
            let animation: CAKeyframeAnimation? = animationForGif(with: url)
            if let animation = animation {
                layer?.add(animation, forKey: "contents")
            }
        }
        
    func animationForGif(with url: URL?) -> CAKeyframeAnimation? {

        let animation = CAKeyframeAnimation(keyPath: "contents")

        var frames = [CGImage]()
        var delayTimes = [NSNumber]()

        var totalTime: Float = 0.0
    //        var gifWidth: Float
    //        var gifHeight: Float

        let gifSource = CGImageSourceCreateWithURL(url! as CFURL, nil)
        // get frame count
        let frameCount = CGImageSourceGetCount(gifSource!)
        for i in 0..<frameCount {
            // get each frame
            let frame = CGImageSourceCreateImageAtIndex(gifSource!, i, nil)
            if let frame = frame {
                
                frames.append(frame)
            }
            
            // get gif info with each frame
            var dict = CGImageSourceCopyPropertiesAtIndex(gifSource!, i, nil) as? [CFString: AnyObject]

            // get gif size
            let gifWidth = (dict?[kCGImagePropertyPixelWidth] as? NSNumber)?.floatValue ?? 0.0
            let gifHeight = (dict?[kCGImagePropertyPixelHeight] as? NSNumber)?.floatValue ?? 0.0

            if self.size == nil {
                self.size = CGSize(width: CGFloat(gifWidth), height: CGFloat(gifHeight))
                self.center = self.view?.center ?? .zero
                self.view?.frame = CGRect(x: 0, y: 0, width: CGFloat(gifWidth), height: CGFloat(gifHeight))
                self.view?.center = self.center
            }
            
            let gifDict = dict?[kCGImagePropertyGIFDictionary]
            if let value = gifDict?[kCGImagePropertyGIFDelayTime] as? NSNumber {
                delayTimes.append(value)
            }

            totalTime = totalTime + (((gifDict?[kCGImagePropertyGIFDelayTime] as? NSNumber)?.floatValue)!)

        }

        var times = [AnyHashable](repeating: 0, count: 3)
        var currentTime: Float = 0
        let count: Int = delayTimes.count
        for i in 0..<count {
            times.append(NSNumber(value: Float((currentTime / totalTime))))
            currentTime += Float(delayTimes[i])
        }

        var images = [AnyHashable](repeating: 0, count: 3)
        for i in 0..<count {
            images.append(frames[i])
        }

        animation.keyTimes = times as? [NSNumber]
        animation.values = images
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = CFTimeInterval(totalTime)
        animation.repeatCount = Float.infinity

        animation.beginTime = AVCoreAnimationBeginTimeAtZero
        animation.isRemovedOnCompletion = false

        return animation

    }
}


