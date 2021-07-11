//
//  JSON.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 16/1/2564 BE.
//

import Foundation

class JSON {
    class func read(_ fileName:String, complete: (_ result: Any?) -> ()) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                complete(jsonObj)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
                complete(error)
            }
        } else {
            print("Invalid filename/path.")
            complete(nil)
        }
    }
    
}
