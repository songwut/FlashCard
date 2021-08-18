//
//  FLStageViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import UIKit

class FLStageViewModel {
    
    var pageList = [FlashPageResult]()
    
    //var pageList: [FlashElement] = []()
    var pageIndex = 0
    var currentPage: FlashPageResult?
    
    func prepareModel() {
        //mock data
        
        if self.pageList.count == 0 {
            //create new 1 + 1
            let page0 = FlashPageResult(JSON: ["index" : 0])!
            self.pageList.append(page0)
            let page1 = FlashPageResult(JSON: ["index" : 1])!
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
    
    func createNewQuiz(completion: @escaping (_ q: FLQuestionResult?) -> ()) {
        let fileName = "flash-card-new-quiz"
        JSON.read(fileName) { (object) in
            if let json = object as? [String : Any],
               let question = FLQuestionResult(JSON: json) {
                completion(question)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    
}
