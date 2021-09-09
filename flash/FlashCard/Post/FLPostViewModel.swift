//
//  FLPostViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 8/9/2564 BE.
//

import Foundation

struct FLPostViewModel {
    
    var detail: FLDetailResult
    
    init(_ detail: FLDetailResult) {
        self.detail = detail
    }
    
    mutating func callAPIDetail(_ method:APIMethod ,status: FLStatus ,complete: @escaping () -> ()) {
        let id = self.detail.id
        let request = FLRequest()
        request.endPoint = .ugcFlashCardDetail
        request.arguments = ["\(id)"]
//        API.request(request) { (responseBody: ResponseBody?, result: FLDetailResult?, isCache, error) in
//            self.detail = result
//            complete()
//        }
        
        //TODO: param for submit, calcle
        print("callAPIDetail\n\(request.url)")
        
        let fileName = "ugc-flash-card-id"
        JSON.read(fileName) { (object) in
            if let json = object as? [String : Any],
               let detail = FLDetailResult(JSON: json) {
                self.detail = detail
            }
            complete()
        }
    }
}
