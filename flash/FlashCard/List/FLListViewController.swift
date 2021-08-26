//
//  FLListViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import UIKit
import SwiftUI

enum FLSectionList {
    case total
    case contentItem
}

enum FLMenuList {
    case delete
    case duplicate
    case add
    case select
    
    func text() -> String {
        switch self {
        case .delete:
            return "delete"
        case .duplicate:
            return "duplicate"
        case .add:
            return "add_new"
        case .select:
            return "select"
        }
    }
    
    func iconName() -> String {
        switch self {
        case .delete:
            return "ic_v2_delete"
        case .duplicate:
            return "copy"
        case .add:
            return "ic_v2_create"
        case .select:
            return "ic_v2_check"
        }
    }
}

class FLListViewController: UIViewController {
    
    private let sectionContentItem = 1
    private let sectionList: [FLSectionList] = [.total, .contentItem]
    private let editMenu: [FLMenuList] = [.delete, .duplicate, .add, .select]
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var layout: UICollectionViewFlowLayout!
    @IBOutlet private weak var menuStackView: UIStackView!
    @IBOutlet private weak var menuHeight: NSLayoutConstraint!
    
    private var viewModel = FLListViewModel()
    private var sectionEdge = UIEdgeInsets.zero
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
        self.view.updateLayout()
        self.createMenu()
        self.collectionViewConfig()
        
        self.collectionView.reloadData()
        self.viewModel.callApiList {
            self.collectionView.alpha = 1.0
            self.collectionView.reloadData()
        }
        // Do any additional setup after loading the view.
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
    }
    
    @objc func menuPressed(_ sender: UIButton) {
        guard let btn = sender as? FLButton else { return }
        if btn.actionMenu == .select {
            if self.userAction == "select" {
                self.userAction = ""
            } else {
                self.userAction = "select"
            }
            if self.userAction == "select" {
                //case can delete, duplicate
                let count = self.selectSortList.count
                self.menuSelect.setColor(ColorHelper.primary(), count: count, menu: .select)
                self.menuAdd.setColor(ColorHelper.disable(), menu: .add)
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
            for sort in self.selectSortList {
                if let index = self.selectSortList.firstIndex(of: sort) {
                    self.selectSortList.remove(at: index)
                }
            }
            self.collectionView.reloadData()
            
        } else if btn.actionMenu == .delete {
            for sort in self.selectSortList {
                if let index = self.selectSortList.firstIndex(of: sort) {
                    self.selectSortList.remove(at: index)
                }
            }
            self.collectionView.reloadData()
            
            //TODO: check delete API
            self.viewModel.callApiDelete(self.selectSortList) {
                
            }
            
        } else {
            
        }
    }
    
    private func setColor(_ color: UIColor, count: Int?, menu: FLItemView) {
        menu.setColor(color, count: count, menu: menu.menu)
        
    }
    
    private func collectionViewConfig() {
        self.collectionView?.register(UINib(nibName: TitleCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        self.collectionView.register(UINib(nibName: FLItemCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: FLItemCollectionViewCell.id)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor("E5E5E5")
        self.collectionView.isPagingEnabled = false
        self.collectionView.alwaysBounceVertical = true
        
        self.collectionView.updateLayout()
        
        self.sectionEdge = UIEdgeInsets(top: 0, left: edgeMargin, bottom: edgeMargin, right: edgeMargin)
        self.layout.sectionInset = self.sectionEdge
        let column:CGFloat = UIDevice.isIpad() ? 3 : 2
        let allwidth = self.collectionView.frame.width
        let itemMargin:CGFloat = edgeMargin * (column - 1)
        let edgeLRMargin:CGFloat = edgeMargin * 2
        let allItemWidth = allwidth - (itemMargin + edgeLRMargin)
        let cellWidth = allItemWidth / column
        let cellHeight = cellWidth * FlashStyle.pageCardRatio
        self.cellSize = CGSize(width: cellWidth, height: cellHeight)
        self.layout.itemSize = self.cellSize
        self.layout.minimumInteritemSpacing = edgeMargin
        self.layout.minimumLineSpacing = itemMargin
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.alpha = 0.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createNewPage() {
        let page = FLItemResult(JSON: ["name" : "some"])!
        let lastItemIndex = self.viewModel.lastItemIndex
        if let item = self.viewModel.list[lastItemIndex] as? FLItemResult {
            page.sort = item.sort + 1
        }
        self.viewModel.list.insert(page, at: lastItemIndex)
        self.collectionView.reloadData()
        
        let lastRow = self.viewModel.list.count - 1
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
            return self.viewModel.list.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if sectionList[indexPath.section] == .total {
            let total = self.viewModel.listResult?.total ?? 0
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as! TitleCollectionViewCell
            let countContentText = "total".localized() + " " + total.textNumber(many: "pages".localized())
            cell.totalText = countContentText
            cell.contentWidth?.constant = collectionView.frame.width
            cell.contentHeight?.constant = 40
            return cell
            
        } else {
            let item = self.viewModel.list[indexPath.row]
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
            let margin = edgeMargin * 2
            return CGSize(width: collectionView.frame.width, height: 40)
        } else {
            return self.cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if sectionList[section] == .total {
            return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        } else {
            return self.sectionEdge
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if sectionList[indexPath.section] == .contentItem {
            if self.userAction == "select" {
                guard let item = self.viewModel.list[indexPath.row] as? FLItemResult else { return }
                if let index = self.selectSortList.firstIndex(of: item.sort) {
                    self.selectSortList.remove(at: index)
                } else {
                    self.selectSortList.append(item.sort)
                }
                
                let count = self.selectSortList.count
                self.menuSelect.setColor(ColorHelper.primary(), count: count, menu: .select)
                
                self.collectionView.reloadData()
                
            } else {
                guard let _ = self.viewModel.list[indexPath.row] as? FLNewResult else { return }
                self.createNewPage()
                
            }
            print("self.selectSortList: \(self.selectSortList)")
            
            
        }
        //TODO: multiple select
        //TODO: select to open
    }
    
}
