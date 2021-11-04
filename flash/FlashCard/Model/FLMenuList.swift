//
//  FLMenuList.swift
//  flash
//
//  Created by Songwut Maneefun on 1/11/2564 BE.
//

import Foundation

enum FLSectionList {
    case total
    case contentItem
}

enum FLMenuList {
    case delete
    case duplicate
    case add
    case select
    
    func text() -> String {
        switch self {
        case .delete:
            return "delete"
        case .duplicate:
            return "duplicate"
        case .add:
            return "add_new"
        case .select:
            return "select"
        }
    }
    
    func iconName() -> String {
        switch self {
        case .delete:
            return "ic_v2_delete"
        case .duplicate:
            return "copy"
        case .add:
            return "ic_v2_create"
        case .select:
            return "ic_v2_check"
        }
    }
}
