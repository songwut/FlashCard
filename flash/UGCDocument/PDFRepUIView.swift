//
//  PDFRepUIView.swift
//  UGC
//
//  Created by Songwut Maneefun on 4/4/2565 BE.
//

import PDFKit
import SwiftUI
import Combine

struct PDFKitRepresentedView: UIViewRepresentable {
    
    typealias UIViewType = PDFView

    let pdfView: PDFView
    let data: Data
    
    func makeUIView(context: Context) -> PDFView {
        self.pdfView.document = PDFDocument(data: self.data)
        self.pdfView.translatesAutoresizingMaskIntoConstraints = false
        self.pdfView.backgroundColor = .clear
        self.pdfView.displayMode = .singlePageContinuous
        self.pdfView.displayDirection = .horizontal
        self.pdfView.autoScales = true
        self.pdfView.clipsToBounds = false
        self.pdfView.usePageViewController(true, withViewOptions: nil)
        self.pdfView.scrollView?.showsHorizontalScrollIndicator = false
        self.pdfView.scrollView?.showsVerticalScrollIndicator = false
        return self.pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(data: self.data)
    }
}
