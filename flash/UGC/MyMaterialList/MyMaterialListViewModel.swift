//
//  MyMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import Foundation
import Combine
import UIKit

class MyMaterialListViewModel: ObservableObject {
    @Published var myMaterialFlash: LMMaterialPageResult?
    
    var next: Int? {
        didSet {
            self.isListFull = self.next == nil
        }
    }
    var previous: Int?
    var count = 0
    var currentPage = 0
    var isListFull = false
    var isLoadNextPage = false
    var items = [LMMaterialResult]()
    
    func totalText() -> String {
        let count =  self.myMaterialFlash?.count ?? 0
        let total = "total".localized()
        let totalText =  count.textNumber(many: "learning_material_unit".localized())
        return "\(total) \(totalText)"
    }
    
    func callAPIMyFlashCard(nextUrl: String?, complete: @escaping (_ result: LMMaterialPageResult?) -> ()) {
        let viewModel = FLFlashCardViewModel()
        let profileId = UserManager.shared.profile.id
        var parem = EndPointParam(dict: ["created_by" : profileId])
        parem.dict?["page_size"] = UIDevice.isIpad() ? 50 : 24
        viewModel.callAPIMyFlashCard(.get, nextUrl: nextUrl, param: parem) { [self] (pageResult) in
            guard let page = pageResult else { return complete(nil) }
            self.currentPage += 1
            self.myMaterialFlash = page
            self.next = page.next
            print("currentPage:\(self.currentPage)")
            complete(page)
        }
        
    }
    
    func callAPIMyMaterialList(complete: @escaping () -> ()) {
        let viewModel = FLFlashCardViewModel()
        let profileId = UserManager.shared.profile.id
        var parem = EndPointParam(dict: ["created_by" : profileId])
        parem.dict?["page_size"] = UIDevice.isIpad() ? 50 : 24
        if let next = self.next, self.isLoadNextPage {
            parem.dict?["page"] = next
        }
        viewModel.callAPIMyMaterial(.get, param: parem) { [self] (pageResult) in
            guard let page = pageResult else { return complete() }
            self.currentPage += 1
            self.myMaterialFlash = page
            self.next = page.next
            if self.isLoadNextPage {
                self.items.append(contentsOf: page.list)
            } else {
                self.items = page.list
            }
            print("list:\(self.items.count)")
            print("currentPage:\(self.currentPage)")
            complete()
        }
        
    }
}
