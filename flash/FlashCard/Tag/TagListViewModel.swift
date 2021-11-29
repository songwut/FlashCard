//
//  TagListViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 13/11/2564 BE.
//

import Foundation

class TagListViewModel: BaseViewModel {
    var selectTagId = [Int]()
    var tagList = [UGCTagResult]()
    var newTagList = [UGCTagResult]()
    var isLoadNextPage = false
    var nextPage: Int?
    var isFirstPage = true
    
    
    func callAPITagList(complete: @escaping (_ list: [UGCTagResult]) -> ()) {
        if !self.isFirstPage, self.nextPage == nil {
            //max of items in page
            complete(self.tagList)
        } else {
            let request = FLRequest()
            request.apiMethod = .get
            request.endPoint = .tagSelectList
            
            var endpointDict = [String: Any]()
            endpointDict["page_size"] = 100
            if self.isLoadNextPage, let next = self.nextPage {
                endpointDict["page"] = next
            }
            
            request.endPointParam = EndPointParam(dict: endpointDict)
            
            API.request(request) { (response: ResponseBody?, result: UGCTagPageResult?, isCache, error) in
                if let page = result {
                    self.nextPage = page.next
                    
                    if self.isFirstPage {
                        self.newTagList = page.list
                        self.tagList = page.list
                    } else {
                        self.newTagList = page.list
                        self.tagList.append(contentsOf: page.list)
                    }
                    
                    self.isFirstPage = false
                }
                print("error:\(error?.localizedDescription)")
                complete(self.tagList)
            }
        }
    }
}
