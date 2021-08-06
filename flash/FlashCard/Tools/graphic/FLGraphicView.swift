//
//  FLGraphicView.swift
//  flash
//
//  Created by Songwut Maneefun on 6/8/2564 BE.
//

import UIKit

final class FLGraphicView: UIView {

    @IBOutlet private weak var contentHeight: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var layout: UICollectionViewFlowLayout!
    
    private var graphicList = [FLGraphicResult]()
    private var selectedIndex = 0
    private var cellSize: CGSize = .zero
    
    var didSelectedGraphic: DidAction?
    var height = CGFloat.zero
    
    func setup(graphicList:[FLGraphicResult]) {
        self.graphicList = graphicList
        self.collectionView.updateLayout()
        
        self.collectionView.isScrollEnabled = false
        let spaceing = FlashStyle.graphic.spaceing
        let fixRow = FlashStyle.graphic.fixRow
        let column = FlashStyle.graphic.column
        let marginVer = FlashStyle.graphic.marginVer
        
        let allSpaceing = spaceing * (column - 1)
        let allWidth = self.collectionView.frame.width - CGFloat(allSpaceing)
        let itemW = CGFloat(allWidth) / CGFloat(column) - 1
        
        let spaceV = (fixRow - 1) * spaceing
        let contentV = fixRow * itemW
        let allHeight = (marginVer * 2) + spaceV + contentV
        self.height = allHeight
        self.contentHeight.constant = allHeight
            
        self.cellSize = CGSize(width: itemW, height: itemW)
        self.layout.itemSize = self.cellSize
        self.layout.minimumInteritemSpacing = CGFloat(spaceing)
        self.layout.minimumLineSpacing = CGFloat(spaceing)
        self.layout.sectionInset = UIEdgeInsets(top: marginVer, left: 0, bottom: marginVer, right: 0)
        self.collectionView.isScrollEnabled = true
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        self.collectionView.register(UINib(nibName: "FLImageCell", bundle: nil), forCellWithReuseIdentifier: "FLImageCell")
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.alwaysBounceHorizontal = true
    }
    
    class func instanciateFromNib() -> FLGraphicView {
        return Bundle.main.loadNibNamed("FLGraphicView", owner: nil, options: nil)![0] as! FLGraphicView
    }
}

extension FLGraphicView : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.graphicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLImageCell", for: indexPath) as! FLImageCell
        cell.isSelected = indexPath.row == self.selectedIndex
        cell.imageBase64 = self.graphicList[indexPath.row].imageBase64
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        collectionView.reloadData()
        let imageBase64 = self.graphicList[indexPath.row]
        self.didSelectedGraphic?.handler(imageBase64)
    }
    
}
