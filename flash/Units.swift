//
//  Units.swift
//  flash
//
//  Created by Songwut Maneefun on 20/7/2564 BE.
//

import Foundation

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
    let bcf = ByteCountFormatter()
    bcf.allowedUnits = [.useMB]
    bcf.countStyle = .file
    let string = bcf.string(fromByteCount: bytes)
    return string
  }
}
