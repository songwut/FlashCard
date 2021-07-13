//
//  FLStageViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import UIKit

class FLStageViewModel {
    
    var pageList = [FlashPage]()
    
    //var pageList: [FlashElement] = []()
    var pageIndex = 0
    var currentPage: FlashPage?
    
    func prepareModel() {
        //mock data
        
        if self.pageList.count == 0 {
            //create new 1 + 1
            let page0 = FlashPage()
            self.pageList.append(page0)
            let page1 = FlashPage()
            self.pageList.append(page1)
            
//            let page2 = FlashPage()
//            self.pageList.append(page2)
//            let page3 = FlashPage()
//            self.pageList.append(page3)
            
            self.currentPage = self.pageList.first
        } else {
            //read api
        }
        
    }
    
    func save(element: FlashElement, at index: Int) {
        self.pageList[index].componentList.append(element)
    }
    
    func genJSON() {
        
    }
    
    
}