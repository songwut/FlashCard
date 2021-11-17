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
            
            if self.isLoadNextPage, let next = self.nextPage {
                request.parameter = ["page": next]
                //request.parameter = ["page_size": 100, "page": next]
            } else {
                //let pageSize: [String: Any] = ["page_size": 50]
                //request.parameter = ["page_size": 50]
                //return nil
            }
            
            API.request(request) { (response: ResponseBody?, result: UGCTagPageResult?, isCache, error) in
                if let page = result {
                    self.nextPage = page.next
                    
                    if self.isFirstPage {
                        self.tagList = page.list
                    } else {
                        self.tagList.append(contentsOf: page.list)
                    }
                    
                    self.isFirstPage = false
                }
                print("error:\(error?.localizedDescription)")
                complete(self.tagList)
            }
        }
        
        /*
        JSON.read("ugc-flash-card-tag-list") { (object) in
            if let dict = object as? [String : Any],
               let detail = UGCTagPageResult(JSON: dict) {
                let mockList = detail.list
                
                self.openTagListVC(tags: mockList)
            }
        }
        */
    }
}
