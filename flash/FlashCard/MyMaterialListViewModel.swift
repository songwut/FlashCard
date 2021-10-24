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
    @Published var list = [MaterialFlashResult]()
    
    var previous: Int?
    var next: Int?
    var count = 0
    var pageSize = 24
    var isLoading = false
    
    // Tracks last page loaded. Used to load next page (current + 1)
    var currentPage: Int?
    var isListFull = false
    
    private var cancellable: AnyCancellable?
    
    func callAPIMyFlashCard(next: Int?) {
        
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
        guard let currentPage = self.currentPage else {
            self.currentPage = 0
            print("currentPage:\(self.currentPage)")
            return
        }
        if let nextId = next  {
            isLoading = true
            let viewModel = FLFlashCardViewModel()
            //param next id
            viewModel.callAPIMyFlashCard(.get) { [self] (myFlashDetail) in
                guard let myFlashDetail = myFlashDetail else { return }
                if currentPage == 0 {
                    self.list = myFlashDetail.list
                } else {
                    if !self.isListFull {
                        for flash in myFlashDetail.list {
                            self.list.append(flash)
                        }
                    }
                }
                self.isListFull = myFlashDetail.next == nil
                isLoading = false
                self.currentPage! += 1
                print("currentPage:\(currentPage)")
            }
        }
        
    }
}
