//
//  URL.swift
//  flash
//
//  Created by Songwut Maneefun on 7/4/2565 BE.
//

import Foundation

extension URL {
    subscript(param:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
