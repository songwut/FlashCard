//
//  FLToolViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import Foundation

struct FLToolViewSetup {
    var title: String?
    var tool: FLTool
    
}

class FLToolViewModel {
    var tool: FLTool = FLTool.menu
    
    func colorList(complete: (_ list: [String]) -> ()){
        JSON.read("flash-card-color") { (object) in
            guard let list = object as? [String] else {
                return complete([])
            }
            complete(list)
        }
    }
    
}
