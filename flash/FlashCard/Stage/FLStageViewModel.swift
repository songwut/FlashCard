//
//  FLStageViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import UIKit

class FLStageViewModel {
    var detail: FLDetailResult?
    var pageList = [FlashPageResult]()
    var flCard: FlCardResult?
    //var pageList: [FlashElement] = []()
    var pageIndex = 0
    var currentPage: FLPageDetailResult?
    var flashId = 16
    
    func prepareModel() {
        //mock data
        
        if self.pageList.count == 0 {
            //create new 1 + 1
            let page0 = FLPageDetailResult(JSON: ["id" : 1])!
            self.pageList.append(page0)
            let page1 = FLPageDetailResult(JSON: ["id" : 2])!
            self.pageList.append(page1)
            
            let page2 = FLPageDetailResult(JSON: ["id" : 3])!
            self.pageList.append(page2)
            let page3 = FLPageDetailResult(JSON: ["id" : 4])!
            self.pageList.append(page3)
            
            self.currentPage = page3
        } else {
            //read api
        }
        
    }
    
    func callAPIDetail(complete: @escaping () -> ()) {
//        let request = FLRequest()
//        request.endPoint = .ugcFlashCardDetail
//        request.arguments = ["\(self.flashId)"]
//        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLDetailResult?, isCache, error) in
//            self?.detail = result
//            complete()
//        }
        
        let fileName = "ugc-flash-card-id"
        JSON.read(fileName) { (object) in
            if let json = object as? [String : Any],
               let detail = FLDetailResult(JSON: json) {
                self.detail = detail
            }
            complete()
        }
    }
    
    func callAPIFlashCard(complete: @escaping (_ result: FlCardResult?) -> ()) {
//        let request = FLRequest()
//        request.endPoint = .ugcFlashCard
//        request.arguments = ["\(self.flashId)"]
//        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FlCardResult?, isCache, error) in
//            if let flCard = result {
//                self?.flCard = flCard
//                self?.pageList = flCard.list
//                complete(self?.flCard)
//            }
//        }

        let fileName = "ugc-flash-card-id-card"
        JSON.read(fileName) { (object) in
            if let json = object as? [String : Any],
               let flCard = FlCardResult(JSON: json) {
                self.flCard = flCard
                self.pageList = flCard.list
            }
            complete(self.flCard)
        }
    }
    
    func callAPICardList(cardId: Int ,complete: @escaping (_ page: FLPageDetailResult) -> ()) {
        
//        let request = FLRequest()
//        request.endPoint = .ugcCardList
//        request.arguments = ["\(self.flashId)", "\(cardId)"]
//        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FlashPageResult?, isCache, error) in
//            if let page = result {
//                complete(page)
//            }
//        }
        ///
        
        let fileName = "ugc-flash-card-id-card-id"
        JSON.read(fileName) { (object) in
            if let dict = object as? [String : Any] {
                let card = FLPageDetailResult(JSON: dict)!
                self.currentPage = card
                complete(card)
            }
        }
    }
    
    func save(element: FlashElement, at index: Int) {
        //TODO: save API by page
        // convert element to dict -> save api
        self.currentPage?.componentList.append(element)
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
