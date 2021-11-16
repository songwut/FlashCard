//
//  UICollectionView.swift
//  LEGO
//
//  Created by Songwut Maneefun on 10/25/17.
//  Copyright © 2017 Conicle. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
//
//    func dynamicCellSize() -> CGSize {
//        let contentHeight = UIDevice.isIpad() ? BasicCollectionViewCell.contentHeight() : BasicListCollectionViewCell.contentHeight()
//        let rowNumber: CGFloat = UIDevice.isIpad() ? 2 : 1
//        let allEdge = edgeMargin * CGFloat(rowNumber + 1)
//        let widthCutEdge = self.frame.size.width - allEdge
//        let cellWidth = widthCutEdge / rowNumber
//        let imageHeight = cellWidth * (9/16)
//        let cellHeight = imageHeight + 170
//        return CGSize(width: cellWidth, height: UIDevice.isIpad() ? cellHeight : contentHeight)
//    }
    
    func reloadDataAsync() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func reloadAt(section: Int){
        self.performBatchUpdates({
            let indexSet = IndexSet(integer: section)
            self.reloadSections(indexSet)
        }, completion: nil)
    }
    
    func registerEmptyCell(_ id:String) {
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: id)
    }
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.setUITestId("\(identifier)_xctest")
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.setUITestId("\(identifier)_xctest")
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass, id:String? = nil) {
        let identifier = id ?? String.className(cellClass)
        let nib = UINib(nibName: String.className(cellClass), bundle: nil)
        self.setUITestId("\(identifier)_xctest")
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func registerSupplementaryClass(_ viewClass: AnyClass, Kind: String) {
        let identifier = String.className(viewClass)
        self.setUITestId("\(identifier)_xctest")
        self.register(viewClass, forSupplementaryViewOfKind: Kind, withReuseIdentifier: identifier)
    }
    
    func registerSupplementaryNib(_ viewClass: AnyClass, kind: String, id:String? = nil) {
        let identifier = id ?? String.className(viewClass)
        let nib = UINib(nibName: String.className(viewClass), bundle: nil)
        self.setUITestId("\(identifier)_xctest")
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    func reloadDataSections(_ indexSet: IndexSet) {
        self.performBatchUpdates({
            ConsoleLog.show("reloadDataCollectionView reloading")
            self.reloadSections(indexSet)
        }, completion: { (done) in
            ConsoleLog.show("reloadDataCollectionView", done)
        })
    }
}
