//
//  SelectCategoryListViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 4/2/2565 BE.
//

import UIKit
import SwiftUI

class SelectCategoryListViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var loadingStackView: UIStackView!
    
    var items = [UGCCategory]()
    var didSelectCategory: Action?
    private var viewitems = [UGCCategoryRow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentStackView.updateLayout()
        self.contentStackView.removeAllArranged()
        
        let width = self.contentStackView.frame.width
        /*
        for item in items {
            let categoryRow = UGCCategoryRow(category: item) { category in
                //select
                self.clearCheckAll(selectedId: category.id)
                self.contentStackView.updateConstraintsIfNeeded()
                //return self.didSelectCategory?.handler(category)
            } expaned: { isExpaned in
                return
            }
            let host = UIHostingController(rootView: categoryRow)
            //host.view.frame = CGRect(x: 0, y: 0, width: width, height: 42)
            host.view.backgroundColor = UIColor.clear
            //host.rootView.delegate = self
            self.contentStackView.addArrangedSubview(host.view)
        }
        */
        
        // Do any additional setup after loading the view.
    }
    
    
    func clearCheckAll(selectedId: Int? = nil) {
        for caregory in self.items {
            if let id = selectedId, id == caregory.id {
                caregory.isChecked = true
            } else {
                caregory.isChecked = false
                caregory.reset()
            }
        }
    }
    

    @IBAction private func donePressed() {
        
    }
}
