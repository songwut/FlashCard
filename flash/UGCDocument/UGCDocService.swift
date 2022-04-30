//
//  UGCDocService.swift
//  UGC
//
//  Created by Songwut Maneefun on 19/4/2565 BE.
//

import AVFoundation
import PDFKit
import Combine

final class UGCDocService: ObservableObject {
    @Published var countText = ""
    @Published var selection: String?
    @Published var totalCount: Int?
    
    var pdfView: PDFView?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private var currentPageNumber: Int  {
        let result = self.pdfView?.currentPage?.pageRef?.pageNumber ?? 0
        return result > 0 ? result - 1 : 0
    }
    
    deinit {
        self.subscriptions.removeAll()
    }
    
    func prepareData(pdfView: PDFView?) {
        self.pdfView = pdfView
        NotificationCenter.default.publisher(for: .PDFViewPageChanged)
            .map { $0.object as? PDFView }
            .sink { [weak self] view in
                guard let self = self else { return }
                let page = self.currentPageNumber + 1
                print("page: \(page)")
                self.totalCount = self.pdfView?.document?.pageCount ?? 0
                self.countText = "\(page) / \(self.totalCount ?? 0)"
            }
            .store(in: &subscriptions)
        
        NotificationCenter.default.publisher(for: .PDFViewSelectionChanged)
            .map { $0.object as? PDFView }
            .sink { [weak self] view in
                guard let self = self else { return }
                self.selection = view?.currentSelection?.string
                print("selection: \(String(describing: self.selection))")
            }
            .store(in: &subscriptions)
    }
}
