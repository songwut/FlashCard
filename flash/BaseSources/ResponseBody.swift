//
//  ResponseBody.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import Foundation

struct ResponseBody {
    var detail: String?
    var username: [String]?
    var password: [String]?
    var isRemember: Bool?
    var language: String?
    var urlResponse: HTTPURLResponse?
    var dict: [String: Any]?
    var dictList = [[String: Any]]()
    
    func getJSONString() -> String {
        if let jsonData = self.getJSONData() {
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            return jsonString
        }
        return ""
    }
    
    func getJSONData() -> Data? {
        if let dict = self.dict {
            let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            return jsonData
        }
        return nil
    }
}
