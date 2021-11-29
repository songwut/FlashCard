//
//  CreateMaterialViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 29/11/2564 BE.
//

import UIKit
import IQKeyboardManagerSwift

class CreateMaterialViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var layout: UICollectionViewFlowLayout!

    private var viewModel = FLFlashCardViewModel()
    private let column = UIDevice.isIpad() ? 3 : 2
    private let margin: CGFloat = 16
    private var list = [LMCreateItem]()
    private var cellSize: CGSize = .zero
    private var edgeInset: UIEdgeInsets = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.updateLayout()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.unregisterAllNotifications()
        
        self.view.backgroundColor = .white
        self.collectionView.register(UINib(nibName: NewMaterialCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: NewMaterialCollectionViewCell.id)
        
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = .white
        self.collectionView.isPagingEnabled = false
        self.collectionView.alwaysBounceVertical = true
        
        self.collectionView.updateLayout()
        
        self.collectionView?.alwaysBounceVertical = true
        
        let superW = self.collectionView.frame.width
        let hWidth = superW - (margin * CGFloat(column + 1))
        let cellWidth = CGFloat(hWidth / CGFloat(column)) - 1//fix width swiftUI
        let cellHeight = CGFloat(cellWidth * (200 / 164))
        print("cellWidth: \(cellWidth)")
        self.cellSize = CGSize(width: cellWidth, height: cellHeight)
        self.layout.estimatedItemSize = CGSize(width: 1,height: 1)
        //self.layout.itemSize = self.cellSize
        self.layout.minimumInteritemSpacing = margin
        self.layout.minimumLineSpacing = margin
        self.edgeInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        self.layout.scrollDirection = .vertical
        self.layout.sectionInset = self.edgeInset
        self.collectionView.alpha = 0.0
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.showLoading(nil)
        viewModel.callAPILearningCoverList { (listResult: [LMCreateItem]?) in
            self.hideLoading()
            if let list = listResult {
                self.collectionView.alpha = 1.0
                self.list = list
                self.collectionView.reloadData()
            }
        }
    }
}


extension CreateMaterialViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMaterialCollectionViewCell.id, for: indexPath) as! NewMaterialCollectionViewCell
        cell.cellSize = self.cellSize
        cell.item = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.edgeInset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.list[indexPath.row]
        if item.isReady {
            let storyboard = UIStoryboard(name: "FlashCard", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(identifier: "FLEditorViewController") as! FLEditorViewController
            vc.viewModel.flashId = 0
            vc.createStatus = .new
            if let nav = self.navigationController {
                nav.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}
