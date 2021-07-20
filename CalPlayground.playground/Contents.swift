//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
public struct Units {
  
  public let bytes: Int64
  
  public var kilobytes: Double {
    return Double(bytes) / 1_024
  }
  
  public var megabytes: Double {
    return kilobytes / 1_024
  }
  
  public var gigabytes: Double {
    return megabytes / 1_024
  }
  
  public init(bytes: Int64) {
    self.bytes = bytes
  }
  
  public func getReadableUnit() -> String {
    
    switch bytes {
    case 0..<1_024:
      return "\(bytes) bytes"
    case 1_024..<(1_024 * 1_024):
      return "\(String(format: "%.2f", kilobytes)) kb"
    case 1_024..<(1_024 * 1_024 * 1_024):
      return "\(String(format: "%.2f", megabytes)) mb"
    case (1_024 * 1_024 * 1_024)...Int64.max:
      return "\(String(format: "%.2f", gigabytes)) gb"
    default:
      return "\(bytes) bytes"
    }
  }
}
class MyViewController : UIViewController {
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    override func loadView() {
        let oneMB:Int64 = 1_024 * 1_024
        let mb = Units(bytes:oneMB * 6).megabytes
        print(mb)
        
        print(-0.666656494140625 * -1)
        print(self.deg2rad(45))
        print(self.deg2rad(-33.690065508446814))
        print(self.deg2rad(-180))
        
        
        
        
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()


