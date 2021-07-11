//
//  FLStageViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import UIKit

class FLStageViewModel {
    
    var pageList: [Int] = []
    var colorList = [String]()
    
    func prepareModel() {
        for i in 0 ... 8 {
            self.pageList.append(i)
        }
        
    }
    
    
}
