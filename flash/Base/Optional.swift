//
//  Optional.swift
//  flash
//
//  Created by Songwut Maneefun on 3/8/2564 BE.
//

import Foundation

extension Optional {
    func `let`<T>(_ transform: (Wrapped) -> T?) -> T? {
        if case .some(let value) = self {
            return transform(value)
        }
        return nil
    }
}
