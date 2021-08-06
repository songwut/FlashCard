//
//  FLListViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import Foundation

class FLListViewModel: BaseViewModel {
    
    var flashId: Int = 0
    var listResult: FLListResult?
    
    override func callApi(completion: @escaping () -> ()) {
        
    }
    
    func callApiList(completion: @escaping () -> ()) {
        let request = FLRequest()
        request.flashId = self.flashId
        request.endPoint = .ugcFlashList
        request.method = .get
        API.request(request) { (responseBody: ResponseBody?, listResult: FLListResult?, isCache, error) in
            self.listResult = listResult
            completion()
        }
    }
}
