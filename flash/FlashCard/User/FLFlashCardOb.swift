//
//  FLFlashCardOb.swift
//  flash
//
//  Created by Songwut Maneefun on 28/10/2564 BE.
//

import SwiftUI
import Combine


class FLFlashPlayerViewModel: ObservableObject {
    @State var flashId = 0
    @Published var detail: FLDetailResult?
    @Published var list = [FLCardPageResult]()
    @Published var cardDeck = FLDeck()
    
    var previous: Int?
    var next: Int?
    var nextUrl: String?
    var count = 0
    var pageSize = 24
    
    init(flashId: Int) {
        self.flashId = flashId
    }
    
    // Tracks last page loaded. Used to load next page (current + 1)
    var currentPage = 0
    var isListFull = false
    
    private var cancellable: AnyCancellable?
    
    let viewModel = FLFlashCardViewModel()
    func prepareFirstCard() {
        self.viewModel.callAPIFlashDetail(.get) { [weak self] (flashDetail) in
            self?.detail = flashDetail
        }
        
        self.viewModel.callAPIFlashCard { [weak self] (cardResult: FLFlashDetailResult?) in
            guard let self = self else { return }
            guard let cardDetail = cardResult else { return }
            //self.list = cardDetail.list
            self.cardDeck.cards = cardDetail.list
            self.cardDeck.activeCard = cardDetail.list.first
        }
    }
    
    func callAPIMyFlashCard(nextUrl: String?, complete: @escaping (_ result: MaterialFlashPageResult?) -> ()) {
        
        if let nextUrl = nextUrl {
            let viewModel = FLFlashCardViewModel()
            //param next id
            //let param = ["page" : nextId, "page_size": pageSize]
            //TODO: ask Backend with api new patern
            viewModel.callAPIMyFlashCard(.get, nextUrl: nextUrl) { [self] (pageResult) in
                guard let page = pageResult else { return complete(nil) }
                self.isListFull = page.next == nil
                self.currentPage += 1
                //self.myMaterialFlash = page
                print("currentPage:\(self.currentPage)")
                complete(page)
            }
        }
        
    }
}
