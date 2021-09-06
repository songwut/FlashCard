//
//  FLProgressUIController.swift
//  segment-progress
//
//  Created by Songwut Maneefun on 1/9/2564 BE.
//

import UIKit
import SwiftUI

class FLProgressUIController: UIViewController {

    let sgProgress = UIHostingController(rootView: FLUserProgressView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        self.sgProgress.view.frame = CGRect(x: 0, y: 100, width: width, height: 100)
        self.sgProgress.view.backgroundColor = .white
        self.view.backgroundColor = .orange
        self.view.addSubview(self.sgProgress.view)
        self.sgProgress.rootView.maximum = 5
        self.sgProgress.rootView.value = 15
        self.sgProgress.rootView.isShowButton = true
        self.sgProgress.rootView.delegate = self
        //self.sgProgress.view
    }


}

extension FLProgressUIController: FLUserProgressViewDelegate {
    func segmentSelected(_ index: Int) {
        print("index:\(index)")
    }
    
    
}

