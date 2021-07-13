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
    var iView: InteractView?
    
}

class FLToolViewModel {
    var tool: FLTool = FLTool.menu
    var iView: InteractView?
    private var colorList = [String]()
    
    func colorList(complete: (_ list: [String]) -> ()){
        JSON.read("flash-card-color") { (object) in
            guard let list = object as? [String] else {
                return complete([])
            }
            self.colorList = list
            complete(list)
        }
    }
    
}
