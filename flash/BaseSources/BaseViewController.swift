//
//  BaseViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet weak var noContentLabel: UILabel?
    
    var errorAutoDismiss = true
    var containerListView: Any? //can bee UITableView or UICollectionView
    var isPullingRefresh = false
    lazy var refresher: NVPullToRefresh = {
        let loadingView = NVPullToRefresh(NVActivityIndicatorType: .circleStrokeSpin, Color: .gray)
        return loadingView
    }()
    var detail: Any?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func close() {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func viewModelCallApiWithPulling() {
        self.isPullingRefresh = true
    }
    
    func viewModelCallApi() {
        
    }
    
    func pullToRefreshAction() {
        
    }
    
    func useRefreshControl(_ view: Any? ,noContentText: String? = "No content", callBackBeforeLoadAPI: (() -> Void)? = nil) {
        self.containerListView = view
        if let tableView = view as? UITableView {
            tableView.addPullToRefresh(refresher) {
                self.pullToRefreshAction()
                callBackBeforeLoadAPI?()
                self.viewModelCallApi()
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
                    if self == nil {
                        return
                    }
                    self?.detail = nil
                    tableView.endRefreshing(at: .top)
                }
            }
            
        } else if let collectionView = view as? UICollectionView {
            collectionView.addPullToRefresh(refresher) {
                self.pullToRefreshAction()
                callBackBeforeLoadAPI?()
                self.viewModelCallApi()
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
                    if self == nil {
                        return
                    }
                    self?.detail = nil
                    collectionView.endRefreshing(at: .top)
                }
            }
            
        } else if let scrollView = view as? UIScrollView {
            scrollView.addPullToRefresh(refresher) {
                self.pullToRefreshAction()
                self.viewModelCallApi()
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
                    if self == nil {
                        return
                    }
                    self?.detail = nil
                    scrollView.endRefreshing(at: .top)
                }
            }
            
        }
        
        self.setNoContentStylewith(label: self.noContentLabel,text: noContentText!)
    }
    
    func setNoContentStylewith(label:UILabel?, text: String) {
        label?.font = FontHelper.getFont(.regular, size: .header)
        label?.textColor = UIColor(hex: "999999")
        label?.text = text
    }

}
