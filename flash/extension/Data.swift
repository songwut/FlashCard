//
//  Data.swift
//  flash
//
//  Created by Songwut Maneefun on 3/3/2565 BE.
//

import Foundation

extension Data {
    
    var hexString: String {
        //073e0d4edd88ebcae27c04a53d41e88c3ca11dcf15e6c0951a292115dcb038ac
        return map { String(format: "%02hhx", arguments: [$0]) }.joined()
    }
    
    func getHexString() -> String {
        //073E0D4EDD88EBCAE27C04A53D41E88C3CA11DCF15E6C0951A292115DCB038AC
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}
