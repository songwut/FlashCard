//
//  FLColorView.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import UIKit

final class FLColorView: UIView {

    @IBOutlet private weak var contentHeight: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var layout: UICollectionViewFlowLayout!
    
    private var colorList = [String]()
    private var selectedIndex = 0
    private var cellSize: CGSize = .zero
    
    var didSelectedColor: DidAction?
    var height = CGFloat.zero
    
    func setup(colorList:[String]) {
        self.colorList = colorList
        self.collectionView.updateLayout()
        
        self.collectionView.isScrollEnabled = false
        let spaceing = FlashStyle.color.spaceing
        let fixRow = FlashStyle.color.fixRow
        let column = FlashStyle.color.column
        let marginVer = FlashStyle.color.marginVer
        let row:CGFloat = CGFloat(colorList.count) / column
        
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
        self.collectionView.register(UINib(nibName: "FLColorCell", bundle: nil), forCellWithReuseIdentifier: "FLColorCell")
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.alwaysBounceHorizontal = true
    }
    
    class func instanciateFromNib() -> FLColorView {
        return Bundle.main.loadNibNamed("FLColorView", owner: nil, options: nil)![0] as! FLColorView
    }
}

extension FLColorView : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLColorCell", for: indexPath) as! FLColorCell
        cell.isSelected = indexPath.row == self.selectedIndex
        cell.colorHex = self.colorList[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        collectionView.reloadData()
        let hex = self.colorList[indexPath.row]
        self.didSelectedColor?.handler(hex)
    }
    
}
