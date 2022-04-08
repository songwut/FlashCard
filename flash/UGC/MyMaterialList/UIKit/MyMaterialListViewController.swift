//
//  MyMaterialListViewController.swift
//  LEGO
//
//  Created by Songwut Maneefun on 31/3/2565 BE.
//  Copyright © 2565 BE conicle. All rights reserved.
//

import UIKit
import SwiftUI
//prepare from 4.12 and will start use in UGC 5.0 re-design
class MyMaterialListViewController: PageViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var createViewHeight: NSLayoutConstraint!
    
    private var viewModel = MyMaterialListViewModel()
    private var createMaterialView = UIHostingController(rootView: FLCreateMaterialView())
    private var cellSize: CGSize = .zero
    private let cellHeight: CGFloat = 152
    private let edgeMargin: CGFloat = 16
    
    override var pageSection: Int {
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.updateLayout()
        self.totalLabel.font = .font(14, .regular)
        self.totalLabel.textColor = .text()
        self.collectionView.registerCellNib(MyMaterialCell.self)
        self.createViewHeight.constant = UIDevice.isIpad() ? 132 : 100
        
        if isKMSEnabled , UserManager.shared.profile.isCreator {
            self.createView.addSubViewAndConstraint(self.createMaterialView.view)
            let createTap = UITapGestureRecognizer(target: self, action: #selector(self.createPressed(_:)))
            self.createMaterialView.view.addGestureRecognizer(createTap)
            self.createView.superview?.isHidden = false
        } else {
            self.createView.superview?.isHidden = true
        }
        
        let edgeInset = UIEdgeInsets(top: 8, left: self.edgeMargin, bottom: self.edgeMargin, right: self.edgeMargin)
        self.layout.scrollDirection = .vertical
        self.layout.sectionInset = edgeInset
        
        let rowNumber: CGFloat = UIDevice.isIpad() ? 2 : 1
        let allEdge = self.edgeMargin * CGFloat(rowNumber + 1)
        let widthCutEdge = self.view.frame.size.width - allEdge
        let cellWidth = widthCutEdge / rowNumber
        
        self.cellSize = CGSize(width: cellWidth, height: self.cellHeight)
        self.layout.estimatedItemSize = self.cellSize
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showLoading(nil)
        self.viewModel.callAPIMyMaterialList { [weak self] in
            self?.updateUI()
            self?.hideLoading()
        }
    }
    
    override func scrollViewDidEndDeceleratingAnimatingFinal() {
        self.isLoading = true
        self.loadingFooterView?.startAnimate()
        self.viewModel.callAPIMyMaterialList { [weak self] in
            self?.updateUI()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyMaterialCell.id, for: indexPath) as! MyMaterialCell
        let item = self.viewModel.items[indexPath.row]
        cell.size = self.cellSize
        cell.setData(item)
        cell.didEdit = Action(handler: { [weak self] sender in
            self?.manageEditDestination(item: item)
        })
        cell.didPreview = Action(handler: { [weak self] sender in
            self?.managePreviewDestination(item: item)
        })
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.edgeMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: edgeMargin, bottom: 0, right: edgeMargin)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind:kind, at:indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        return super.collectionView(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        return super.collectionView(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return super.collectionView(collectionView, layout: layout, referenceSizeForFooterInSection: section)
    }

    @objc private func createPressed(_ gesture: UITapGestureRecognizer) {
        OpenVCHelper.openUGCCreateMaterial(mainVC: self)
    }
    
    private func updateUI() {
        self.totalLabel.text = self.viewModel.totalText()
        self.collectionView.reloadData()
        self.isLoading = false
        self.hideLoading()
    }
    
    private func manageEditDestination(item: LMMaterialResult) {
        switch item.contentCode {
        case .flashcard:
            OpenVCHelper.openUGCEditPost(material: item, mainVC: self)
            
        case .video , .audio:
            if let _ = item.url {
                OpenVCHelper.openUGCEditPost(material: item, mainVC: self)
            } else {
                OpenVCHelper.openUGCCreateMedia(material: item, mainVC: self)
            }
            
        case .pdf:
            OpenVCHelper.openUGCCreateDoc(material: item, mainVC: self)
            
        default:
            OpenVCHelper.openUGCEditPost(material: item, mainVC: self)
        }
    }
    
    private func managePreviewDestination(item: LMMaterialResult) {
        switch item.contentCode {
        case .flashcard:
            OpenVCHelper.openFlashcardUserPreview(id: item.id, state: .preview, mainVC: self)
            
        case .video , .audio:
            if let mediaUrl = URL(string: item.url ?? "") {
                let contentCode = item.contentCode
                let model = UGCPlayerFullScreenViewModel(contentCode: contentCode,
                                                         isNeedStopWhenClose: false,
                                                            mediaUrl: mediaUrl,
                                                         coverImage: item.image,
                                                         currentTime: 0)
                OpenVCHelper.openUGCPreviewVideoAudio(viewModel: model, playerVM: UGCPlayerViewModel(), mainVC: self)
            }
        case .pdf:
            //TODO: preview pdf
            print("pdf")
            
        default:
            print("default")
        }
    }

}
