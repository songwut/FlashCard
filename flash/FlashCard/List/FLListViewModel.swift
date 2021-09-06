//
//  FLListViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation

class FLListViewModel: BaseViewModel {
    
    var flashId: Int = 2 //TODO: reset
    var listResult: FLListResult?
    var list = [FLBaseResult]()
    var lastItemIndex = 0
    
    override func callApi(completion: @escaping () -> ()) {
        
    }
    
    func callApiList(completion: @escaping () -> ()) {
        JSON.read("ugc-flash-card-id-card") { (object) in
            guard let JSON = object as? [String: Any] else { return completion() }
            self.listResult = FLListResult(JSON: JSON)
            if let listResult = self.listResult {
                self.list = listResult.list
                let new = FLNewResult(JSON: ["total": listResult.total])!
                self.list.append(new)
                self.lastItemIndex = self.list.count - 2
            }
            completion()
        }
        
        
        
//        let request = FLRequest()
//        request.flashId = self.flashId
//        request.endPoint = .ugcFlashList
//        request.apiMethod = .get
//        API.request(request) { (responseBody: ResponseBody?, listResult: FLListResult?, isCache, error) in
//            self.listResult = listResult
//            if let listResult = self.listResult {
//                self.list = listResult.list
//                let new = FLNewResult(JSON: ["total": listResult.total])!
//                self.list.append(new)
//            }
//            completion()
//        }
    }
    
    func callApiDelete(_ selectList:[Int],completion: @escaping () -> ()) {
        /*
        let request = FLRequest()
        request.flashId = 2//self.flashId
        request.endPoint = .ugcFlashList
        request.selectList = selectList
        request.method = .delete
        API.request(request) { (responseBody: ResponseBody?, listResult: FLListResult?, isCache, error) in
            self.listResult = listResult
            if let listResult = self.listResult {
                self.list = listResult.list
                let new = FLNewResult(JSON: ["total": listResult.total])!
                self.list.append(new)
            }
            completion()
        }
        */
    }
}
