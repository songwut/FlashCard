//
//  WebViewButtonView.swift
//  LEGO
//
//  Created by Kirameki on 11/3/2563 BE.
//  Copyright © 2563 Conicle. All rights reserved.
//

import UIKit

class WebViewButtonView: BaseView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    var didPreviousPressed: DidAction?
    var didForwardPressed: DidAction?
    var didRefreshPressed: DidAction?
    var didSharePressed: DidAction?
    
    class func instanciateFromNib() -> WebViewButtonView {
        return Bundle.main.loadNibNamed("WebViewButtonView", owner: nil, options: nil)![0] as! WebViewButtonView
    }
    
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        self.didPreviousPressed?.handler(self)
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        self.didForwardPressed?.handler(self)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        self.didRefreshPressed?.handler(self)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        self.didSharePressed?.handler(self)
    }
    
    override func awakeFromNib() {
        if #available(iOS 11.0, *) {
            self.contentViewHeight.constant = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero) + 44
        } else {
            self.contentViewHeight.constant = 44
        }
    }
}
