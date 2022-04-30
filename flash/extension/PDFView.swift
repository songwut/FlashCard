//
//  PDFView.swift
//  flash
//
//  Created by Songwut Maneefun on 19/4/2565 BE.
//

import Foundation
import PDFKit

extension PDFView {
    var scrollView: UIScrollView? {
        return self.subviews.first?.subviews.first as? UIScrollView
    }
}
