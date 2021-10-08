//
//  Dictionary.swift
//  flash
//
//  Created by Songwut Maneefun on 8/10/2564 BE.
//

import Foundation
extension Dictionary {
    
    var json: String {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                return String(bytes: jsonData, encoding: .utf8) ?? ""
            } catch {
                return ""
            }
        }
    
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}
