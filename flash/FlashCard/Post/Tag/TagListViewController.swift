//
//  TagListViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 16/11/2564 BE.
//

import UIKit
import TTGTagCollectionView

class TagListViewController: PageViewController {

    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    
    var viewModel = TagListViewModel()
    
    var delegate: TagListSelectViewControllerDelegate?
    
    let totalSection = 0
    let listSection = 1
    let sectionCount = 2
    
    fileprivate var cellSize = CGSize.zero
    
    var items: [BaseResult] {
        return self.viewModel.tagList
    }
    
    var itemsCount: Int {
        return self.viewModel.tagList.count
    }
    
    override var pageSection: Int {
        return self.listSection
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let margin: CGFloat = UIDevice.isIpad() ? 40 : 20
        let tagView = TTGTextTagCollectionView(frame: CGRect.init(x: margin, y: 100, width: UIScreen.main.bounds.width - (margin * 2), height: 300))
        tagView.backgroundColor = .white
        self.view.addSubview(tagView)
        
        let strings = ["AutoLayout", "dynamically", "calculates", "the", "size", "and", "position",
                       "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
                       "on", "constraints", "placed", "on", "those", "views","AutoLayout", "dynamically", "calculates", "the", "size", "and", "position",
                       "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
                       "on", "constraints", "placed", "on", "those", "views","AutoLayout", "dynamically", "calculates", "the", "size", "and", "position",
                       "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
                       "on", "constraints", "placed", "on", "those", "views","AutoLayout", "dynamically", "calculates", "the", "size", "and", "position",
                       "of", "all", "the", "views", "in", "your", "view", "hierarchy", "based",
                       "on", "constraints", "placed", "on", "those", "views"]
        
        for text in strings {
            let isSelected = false
            let content = TTGTextTagStringContent(text: text)
            content.textColor = tagTextEnableColor
            content.textFont = UIFont.font(13, .text)
            
            let normalStyle = TTGTextTagStyle()
            normalStyle.backgroundColor = .white
            normalStyle.extraSpace = CGSize(width: 8, height: 8)
            normalStyle.borderColor = tagBgEnableColor
            normalStyle.borderWidth = 1
            normalStyle.cornerRadius = 39
            
            let selectedStyle = TTGTextTagStyle()
            selectedStyle.backgroundColor = tagBgEnableColor
            selectedStyle.extraSpace = CGSize(width: 8, height: 8)
            normalStyle.borderColor = tagBgEnableColor
            normalStyle.borderWidth = 0
            normalStyle.cornerRadius = 39
            
            
            let tag = TTGTextTag()
            tag.content = content
            tag.style = normalStyle
            tag.selectedStyle = selectedStyle
            tag.selected = isSelected
            tagView.addTag(tag)
        }
        
        tagView.reload()
    }
    /*
    override func viewDidLoad2() {
        //super.viewDidLoad()
        self.title = "categories".localized()
        var cellWidth = (self.view.frame.size.width / 2) - (edgeMargin * 1.5)
        if (UIDevice.isIpad()) {
            cellWidth = (self.view.frame.size.width / 3) - (edgeMargin * 2)
        }
        let cellHeight = CGFloat(cellWidth * (1.0 / 2.0))
        self.cellSize = CGSize(width: cellWidth, height: cellHeight)
        self.collectionView?.register(UINib(nibName: TitleCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        self.collectionView?.register(UINib(nibName: CategoryCollectionViewCell2.id, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell2.id)
        let edgeInset = UIEdgeInsets(top: 8, left: edgeMargin, bottom: 8, right: edgeMargin)
        self.layout.scrollDirection = .vertical
        self.layout.sectionInset = edgeInset
        self.collectionView?.alwaysBounceVertical = true
        self.cellSize = CGSize(width: cellWidth, height: cellHeight)
        self.layout.minimumInteritemSpacing = UIDevice.isIpad() ? edgeMargin : 0
        self.layout.minimumLineSpacing = edgeMargin
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.getCategoriesAPI()
        self.collectionView.reloadData()
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func getCategoriesAPI() {
        self.viewModel.callApi { [weak self] in
            self?.nextPage = self?.viewModel.nextPage
            self?.hideLoading()
            self?.collectionView?.reloadData()
        }
    }
    
    //MARK: - Paging Function
    override func scrollViewDidEndDeceleratingAnimatingFinal() {
        self.isLoading = true
        self.loadingFooterView?.startAnimate()
        self.viewModel.isLoadNextPage = true
        self.viewModel.callApi { [weak self] in
            self?.nextPage = self?.viewModel.nextPage
            self?.collectionView.reloadData()
            self?.isLoading = false
        }
    }
    /*
    //MARK: - UICollectionDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showCategoryDetail", sender: self.items[indexPath.row])
    }
    
    // MARK: - UICollectionDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == self.categoriesSection {
            return items.count
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == self.totalSection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as! TitleCollectionViewCell
            let countContentText = "total".localized() + " " + self.itemsCount.textNumber(many: "categories".localized())
            cell.totalText = countContentText
            cell.textLabel.isHidden = false
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell2.id, for: indexPath) as! CategoryCollectionViewCell2
            let item = self.items[indexPath.row]
            cell.setData(item)
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == self.totalSection {
            return CGSize(width: self.view.frame.size.width, height: 30)
        }
        return self.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == self.totalSection {
            return 0
        }
        return edgeMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: edgeMargin, bottom: 0, right: edgeMargin)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSectionCollectionViewCell.id, for: indexPath) as! HeaderSectionCollectionViewCell
            headerView.backgroundColor = .white
            return headerView
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind:kind, at:indexPath)
        }
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
    */
}

