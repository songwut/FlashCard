//
//  PDFRepUIView.swift
//  UGC
//
//  Created by Songwut Maneefun on 4/4/2565 BE.
//

import PDFKit
import SwiftUI
import Combine
/*
struct PDFKitRepresentedView: UIViewRepresentable {
    
    typealias UIViewType = PDFView

    let data: Data
    let singlePage: Bool
    @Binding var totalCount: Int?
    @Binding var selection: String?
    
    var pdfview: PDFView!
    private var subscriptions: Set<AnyCancellable> = []

    init(_ data: Data, singlePage: Bool = false) {
        self.data = data
        self.singlePage = singlePage
        
        NotificationCenter.default.addObserver (self, selector: #selector(self.handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
    }

    func makeUIView(context _: UIViewRepresentableContext<PDFKitRepresentedView>) -> UIViewType {
        self.pdfView = PDFView()
        self.pdfView.document = PDFDocument(data: data)//PDFDocument(url: fileUrl)
        self.pdfView.autoScales = true
        if singlePage {
            self.pdfView.displayMode = .singlePage
        }
        
        NotificationCenter.default.publisher(for: .PDFViewSelectionChanged)
              .map { $0.object as? PDFView }
              .sink { [weak self]  (view) in
                // or do something else
                self?.selection = view?.currentSelection?.string
              }
              .store(in: &subscriptions)
        
        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFKitRepresentedView>) {
        pdfView.document = PDFDocument(data: data)
        if let total = pdfView.document?.pageCount {
            self.totalCount = total
        }
    }
    
    var currentPageNumber: Int  {
        let result = self.pdfview.currentPage?.pageRef?.pageNumber ?? 0
        return result > 0 ? result - 1 : 0
    }
    
    @objc func handlePageChange() {
        let page = self.currentPageNumber + 1
        print("page: \(page)")
    }
    
    
}
 */
