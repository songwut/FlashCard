//
//  MyMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/10/2564 BE.
//

import Foundation
import Combine

class MyMaterialListViewModel: ObservableObject {
    @Published var myMaterialFlash: MaterialFlashPageResult?
    //@Published var list = [MaterialFlashResult]()
    
    var previous: Int?
    var next: Int?
    var nextUrl: String?
    var count = 0
    var pageSize = 24
    
    // Tracks last page loaded. Used to load next page (current + 1)
    var currentPage = 0
    var isListFull = false
    
    private var cancellable: AnyCancellable?
    
    func callAPIMyFlashCard(nextUrl: String?, complete: @escaping (_ result: MaterialFlashPageResult?) -> ()) {
        
        /*
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { $0.data }
            .decode(type: [MaterialFlashResult].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.list) }
            .sink { [weak self] in
                self?.currentPage += 1
                self?.members.append(contentsOf: $0)
                // If count of data received is less than perPage value then it is last page.
                if $0.count < perPage {
                    self?.membersListFull = true
                }
        }
        */
        if let nextUrl = nextUrl {
            let viewModel = FLFlashCardViewModel()
            //param next id
            //let param = ["page" : nextId, "page_size": pageSize]
            //TODO: ask Backend with api new patern
            viewModel.callAPIMyFlashCard(.get, nextUrl: nextUrl) { [self] (pageResult) in
                guard let page = pageResult else { return complete(nil) }
                self.isListFull = page.next == nil
                self.currentPage += 1
                self.myMaterialFlash = page
                print("currentPage:\(self.currentPage)")
                complete(page)
            }
        }
        
    }
}
