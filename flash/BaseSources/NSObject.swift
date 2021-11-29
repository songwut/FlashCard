//
//  NSObject.swift
//  flash
//
//  Created by Songwut Maneefun on 28/11/2564 BE.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class  var  className: String {
        return String(describing: self)
    }
}
