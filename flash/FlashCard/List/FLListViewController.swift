//
//  FLListViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import UIKit
import SwiftUI


class FLListViewController: UIViewController {
    
    private let sectionContentItem = 1
    private let sectionList: [FLSectionList] = [.total, .contentItem]
    private let editMenu: [FLMenuList] = [.delete, .duplicate, .add, .select]
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var layout: UICollectionViewFlowLayout!
    @IBOutlet private weak var menuStackView: UIStackView!
    @IBOutlet private weak var menuHeight: NSLayoutConstraint!
    
    var viewModel = FLFlashCardViewModel()
    var list = [FLBaseResult]()
    
    private var cellSize = CGSize.zero
    private let edgeMargin:CGFloat = 16
    private var menuDelete:FLItemView!
    private var menuDuplicate:FLItemView!
    private var menuAdd:FLItemView!
    private var menuSelect:FLItemView!
    private var userAction = ""
    private var selectSortList = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.collectionViewConfig()
        self.createMenu()
        self.collectionView.reloadData()
        
        if self.viewModel.flashCardDetail == nil {
            let index = self.viewModel.pageIndex
            let card = self.viewModel.pageList[index]
            self.viewModel.callAPICardDetail(card, method: .get) { [weak self] (cardDetail) in
                self?.orderingItem()
                self?.reloadCollectionView()
            }
        } else {
            self.orderingItem()
            self.reloadCollectionView()
        }
        // Do any additional setup after loading the view.
    }
    
    func orderingItem() {
        self.list.removeAll()
        var i = 0
        for card in self.viewModel.pageList {
            card.index = i
            self.list.append(card)
            i += 1
        }
        let newCard = FLNewResult(JSON: ["total" : self.viewModel.pageList.count])!
        self.list.append(newCard)
    }
    
    func reloadCollectionView() {
        self.collectionView.alpha = 1.0
        self.collectionView.reloadData()
    }
    
    private func createMenu(_ menu: FLMenuList) -> FLItemView {
        let menuHeight = FlashStyle.listMenuHeight
        let menuWidth = menuHeight * 0.8
        let menuView = FLItemView.instanciateFromNib()
        menuView.menu = menu
        menuView.button.addTarget(self, action: #selector(self.menuPressed(_:)), for: .touchUpInside)
        
        menuView.widthAnchor.constraint(equalToConstant: menuWidth).isActive = true
        return menuView
    }
    
    private func createMenu() {
        let menuHeight = FlashStyle.listMenuHeight
        self.menuHeight.constant = menuHeight
        self.menuStackView.spacing = 8
        self.menuStackView.removeAllArranged()
        
        self.menuDelete = self.createMenu(.delete)
        self.menuDuplicate = self.createMenu(.duplicate)
        self.menuAdd = self.createMenu(.add)
        self.menuSelect = self.createMenu(.select)
        
        self.menuStackView.addArrangedSubview(self.menuDelete)
        self.menuStackView.addArrangedSubview(self.menuDuplicate)
        self.menuStackView.addArrangedSubview(self.menuAdd)
        self.menuStackView.addArrangedSubview(self.menuSelect)
        
        self.menuDelete.menu = .delete
        self.menuDuplicate.menu = .duplicate
        self.menuAdd.menu = .add
        self.menuSelect.menu = .select
        
        self.menuDelete.isUserInteractionEnabled = false
        self.menuDuplicate.isUserInteractionEnabled = false
    }
    
    @objc func menuPressed(_ sender: UIButton) {
        guard let btn = sender as? FLButton else { return }
        if btn.actionMenu == .select {
            if self.userAction == "select" {
                self.userAction = ""
                self.menuDelete.isUserInteractionEnabled = false
                self.menuDuplicate.isUserInteractionEnabled = false
            } else {
                self.userAction = "select"
                self.menuDelete.isUserInteractionEnabled = true
                self.menuDuplicate.isUserInteractionEnabled = true
            }
            
            if self.userAction == "select" {
                //case can delete, duplicate
                let count = self.selectSortList.count
                self.menuSelect.setColor(UIColor.config_primary(), count: count, menu: .select)
                self.menuAdd.setColor(UIColor.disable(), menu: .add)
                self.menuDuplicate.menu = .duplicate
                self.menuDelete.menu = .delete
            } else {
                //reset to normal
                self.selectSortList.removeAll()
                self.menuSelect.menu = .select
                self.menuAdd.menu = .add
                self.menuDuplicate.menu = .duplicate
                self.menuDelete.menu = .delete
                
                self.collectionView.reloadData()
            }
            
        } else if btn.actionMenu == .add {
            //TODO: check add API
            if self.userAction == "" {
                self.createNewPage()
            }
            
        } else if btn.actionMenu == .duplicate {
            self.showLoading(nil)
            self.viewModel.callApiDuplicateList(self.selectSortList, apiMethod: .post) { [weak self] in
                self?.hideLoading()
                self?.orderingItem()
                self?.selectSortList.removeAll()
                self?.collectionView.reloadData()
                self?.updateSelectCount()
                
            }
            
            
        } else if btn.actionMenu == .delete {
            self.showLoading(nil)
            self.viewModel.callApiDeleteList(self.selectSortList, apiMethod: .delete) { [weak self] in
                ConsoleLog.show("done for delete")
                self?.hideLoading()
                self?.orderingItem()
                self?.selectSortList.removeAll()
                self?.collectionView.reloadData()
                self?.updateSelectCount()
            }
            
        } else {
            
        }
    }
    
    private func updateSelectCount() {
        let count = self.selectSortList.count
        self.menuSelect.setColor(UIColor.config_primary(), count: count, menu: .select)
    }
    
    private func setColor(_ color: UIColor, count: Int?, menu: FLItemView) {
        menu.setColor(color, count: count, menu: menu.menu)
        
    }
    
    private func collectionViewConfig() {
        self.collectionView?.register(UINib(nibName: TitleCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        self.collectionView.register(UINib(nibName: FLItemCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: FLItemCollectionViewCell.id)
        
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor("F5F5F5")
        self.collectionView.isPagingEnabled = false
        self.collectionView.alwaysBounceVertical = true
        
        self.collectionView.updateLayout()
        
        let column:CGFloat = UIDevice.isIpad() ? 3 : 2
        let allEdge = edgeMargin * CGFloat(column + 1)
        let allwidth = self.collectionView.frame.width
        let allItemWidth = allwidth - allEdge
        let cellWidth = (allItemWidth / column) - 1
        let cellHeight = cellWidth * FlashStyle.pageCardRatio
        self.cellSize = CGSize(width: cellWidth, height: cellHeight)
        self.layout.itemSize = self.cellSize
        self.layout.minimumInteritemSpacing = edgeMargin
        self.layout.minimumLineSpacing = edgeMargin
        self.collectionView.alpha = 0.0
    }
    
    func createNewPage() {
        var newCardData = [String: Any]()
        var data = [String: Any]()
        data["bg_color"] = ["cl_code" : "FFFFFF","code": "color_01"]
        newCardData["data"] = data
        self.showLoading(nil)
        self.viewModel.callAPIAddNewCard(param: newCardData) { [weak self] (cardPage) in
            guard let self = self else { return }
            self.hideLoading()
            guard let page = cardPage else { return }
            let lastItemIndex = self.viewModel.pageList.count - 1
            page.index = lastItemIndex + 1
            self.list.insert(page, at: lastItemIndex)
            self.collectionView.reloadData()
            self.slideToNewPage()
        }
    }
    
    func slideToNewPage() {
        let lastRow = self.list.count - 1
        let lastIndex = IndexPath(row: lastRow, section: self.sectionContentItem)
        self.collectionView.scrollToItem(at: lastIndex, at: .bottom, animated: true)
    }
    
}

extension FLListViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.sectionList[section] == .total {
            return 1
        } else {
            return self.list.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if sectionList[indexPath.section] == .total {
            let total = self.viewModel.flashCardDetail?.total ?? 0
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as! TitleCollectionViewCell
            let countContentText = "total".localized() + " " + total.textNumber(many: "pages".localized())
            cell.totalText = countContentText
            cell.contentWidth?.constant = collectionView.frame.width
            cell.contentHeight?.constant = 40
            return cell
            
        } else {
            let item = self.list[indexPath.row]
            ConsoleLog.show("flItem: \(item.id)")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FLItemCollectionViewCell.id, for: indexPath) as! FLItemCollectionViewCell
            if let _ = self.selectSortList.firstIndex(of: item.id) {
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }
            cell.item = item
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if sectionList[indexPath.section] == .total {
            return CGSize(width: collectionView.frame.width, height: 40)
        } else {
            return self.cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if sectionList[section] == .total {
            return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if sectionList[indexPath.section] == .contentItem {
            if self.userAction == "select" {
                guard let item = self.list[indexPath.row] as? FLCardPageResult else { return }
                if let index = self.selectSortList.firstIndex(of: item.id) {
                    self.selectSortList.remove(at: index)
                } else {
                    self.selectSortList.append(item.id)
                }
                
                let count = self.selectSortList.count
                self.menuSelect.setColor(UIColor.config_primary(), count: count, menu: .select)
                
                self.collectionView.reloadData()
                
            } else {
                guard let _ = self.list[indexPath.row] as? FLNewResult else { return }
                self.createNewPage()
                
            }
            print("self.selectSortList: \(self.selectSortList)")
            
            
        }
        //TODO: select to open
    }
    
}
