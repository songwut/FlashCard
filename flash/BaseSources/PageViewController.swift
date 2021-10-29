//
//  PageViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 22/10/2564 BE.
//

import UIKit

class PageViewController: BaseViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var tableView: UITableView!
    var loadingPageView: LoadingPageView!
    
    //var loadingFooterView:LoadingFooterView?
    var isLoading:Bool = false
    var pageSection: Int { return 0 }
    var nextPage: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tableView = self.tableView {
            self.tableView.updateLayout()
            self.loadingPageView = LoadingPageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            self.loadingPageView.backgroundColor = .clear
            self.tableView.tableFooterView = self.loadingPageView
            self.tableView?.delegate = self
            self.tableView?.dataSource = self
            
        } else {
//            self.collectionView?.registerSupplementaryNib(LoadingFooterView.self, kind: UICollectionView.elementKindSectionFooter)
//            self.layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
//            self.collectionView?.delegate = self
//            self.collectionView?.dataSource = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDeceleratingAnimatingFinal() {
        
    }
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let _ = self.nextPage {
            if (scrollView.contentSize.height < scrollView.bounds.height) {
                self.loadingFooterView?.prepareInitialAnimation()
                self.isLoading = true
            }
            let threshold = 100.0
            let contentOffset = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let diffHeight = contentHeight - contentOffset
            let frameHeight = scrollView.bounds.size.height
            var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold)
            triggerThreshold   =  min(triggerThreshold, 0.0)
            let pullRatio  = min(abs(triggerThreshold),1.0)
            self.loadingFooterView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
            self.loadingPageView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
            if pullRatio >= 0.3 {
                self.loadingFooterView?.animateFinal()
                self.loadingPageView?.animateFinal()
            } else {
                self.loadingFooterView?.startAnimate()
            }
            ConsoleLog.show("pullRatio: \(pullRatio)")
        }
        
    }
    */
}
/*
extension PageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UICollectionDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.id, for: indexPath) as! LoadingFooterView
            self.loadingFooterView = footerView
            self.loadingFooterView?.backgroundColor = UIColor.clear
            return footerView
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingFooterView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingFooterView?.stopAnimate()
        }
    }
    
    //UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == pageSection {
            return isLoading ? CGSize.zero : CGSize(width: collectionView.bounds.size.width, height: 55)
        }
        return CGSize.zero
    }
}
*/
extension PageViewController: UITableViewDataSource, UITableViewDelegate {
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = self.loadingPageView
        footerView?.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == pageSection {
            return isLoading ? 0 : 30
        }
        return 0
    }
    
}

extension PageViewController: UIScrollViewDelegate {
    
    //compute the offset and call the load method
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        let pullHeight  = abs(diffHeight - frameHeight)
        print("pullHeight:\(pullHeight)")
        if pullHeight <= 100 {
            if let loadingPageView = self.loadingPageView {
                if loadingPageView.isAnimatingFinal {
                    print("load more trigger")
                    self.loadingPageView?.stopAnimate()
                    self.scrollViewDidEndDeceleratingAnimatingFinal()
                }
            }
            /*
            if let loadingFooterView = self.loadingFooterView { //collectionView
                if loadingFooterView.isAnimatingFinal {
                    print("load more trigger")
                    self.loadingFooterView?.stopAnimate()
                    self.scrollViewDidEndDeceleratingAnimatingFinal()
                }
            } else if let loadingPageView = self.loadingPageView {
                if loadingPageView.isAnimatingFinal {
                    print("load more trigger")
                    self.loadingPageView?.stopAnimate()
                    self.scrollViewDidEndDeceleratingAnimatingFinal()
                }
            }
            */
        }
    }
}
