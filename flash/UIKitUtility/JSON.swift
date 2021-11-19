//
//  JSON.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 16/1/2564 BE.
//

import Foundation
import ObjectMapper
import Combine

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
    
    
    class func loadItem<T: Mappable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            //let jsonObj = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
            let JSONString = String(decoding: data, as: UTF8.self)
            return Mapper<T>().map(JSONString: JSONString)!
            
            //let decoder = JSONDecoder()
            //return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    class func loadItemList<T: Mappable>(_ filename: String) -> [T] {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let JSONString = String(decoding: data, as: UTF8.self)
            return Mapper<T>().mapArray(JSONString: JSONString)!
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}



