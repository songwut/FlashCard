//
//  MyMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import Foundation
import Combine

class MyMaterialListViewModel: ObservableObject {
    @Published var myMaterialFlash: LMMaterialPageResult?
    
    var previous: Int?
    var next: Int? {
        didSet {
            isListFull = next == nil
        }
    }
    var nextUrl: String?
    var count = 0
    var pageSize = 24
    
    var currentPage = 0
    var isListFull = false
    
    func callAPIMyFlashCard(nextUrl: String?, complete: @escaping (_ result: LMMaterialPageResult?) -> ()) {
        let viewModel = FLFlashCardViewModel()
        let profileId = UserManager.shared.profile.id
        let parem = EndPointParam(dict: ["created_by" : profileId])
        viewModel.callAPIMyFlashCard(.get, nextUrl: nextUrl, param: parem) { [self] (pageResult) in
            guard let page = pageResult else { return complete(nil) }
            self.currentPage += 1
            self.myMaterialFlash = page
            self.next = page.next
            print("currentPage:\(self.currentPage)")
            complete(page)
        }
        
    }
}
