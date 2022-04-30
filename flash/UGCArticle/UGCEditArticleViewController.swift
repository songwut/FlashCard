//
//  UGCEditArticleViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 20/4/2565 BE.
//

import UIKit
import EventKit
import WebKit
import Alamofire

class UGCEditArticleViewController: BaseViewController {
    
    @IBOutlet var webView: WKWebView!
    
    let customButtonView = WebViewButtonView.instanciateFromNib()
    var isAddWebViewButtonView = false
    var contentOffsetTemp :CGFloat = 0
    
    var url: String?
    
    var error: NSError?
    var message: String?
    var pageId: Int?
    
    var isDismissLoading = false
    var isDescription = false
    
    var courseId: Int?
    var slotId: Int?
    var onboardId: Int?
    var onboardSectionId: Int?
    var learningPathId: Int?
    var learningPathSectionId: Int?
    var isScorm = false
    var isHiddenCustomButtonView = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.setLargeTitles(isLarge: false)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.isOpaque = false // for avoid black space
        self.webView.contentMode = .scaleAspectFit
        self.loadHtml()
    }
    
    func loadHtml() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        if let err = self.error {
            self.webView.loadHTMLString("<h1>ERROR</h1><p>\(err)</p>", baseURL: nil)
        }
        
        if #available(iOS 13.0, *) {
            self.webView.backgroundColor = UIColor.systemBackground
        } else {
            self.webView.backgroundColor = UIColor.white
        }
        
        if let urlStr = self.url {
            if let url = URL(string: urlStr) {
                self.webView.load(URLRequest(url: url))
            } else {
                //Alert.showAlert(title: "Can not open link!", message: "\(urlStr) Please contact Admin", closeButton: "Close", controller: self)
            }
        } else {
            self.webView.configuration.allowsInlineMediaPlayback = true
        }
    }
    
    override func loadView() {
        self.webView = WKWebView()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        self.view = self.webView
    }
    
    func setUpOptionView() {
        if !self.isAddWebViewButtonView {
            self.isAddWebViewButtonView = true
            self.customButtonView.refreshButton.tintColor = themeColor
            self.customButtonView.shareButton.tintColor = themeColor
            self.customButtonView.didPreviousPressed = DidAction(handler: { (sender) in
                self.webviewPrevious()
            })
            self.customButtonView.didForwardPressed = DidAction(handler: { (sender) in
                self.webviewForward()
            })
            self.customButtonView.didRefreshPressed = DidAction(handler: { (sender) in
                self.webviewRefresh()
            })
            self.customButtonView.didSharePressed = DidAction(handler: { (sender) in
                self.webviewShare()
            })
            self.customButtonView.frame = CGRect(x: 0, y: self.view.frame.height - self.customButtonView.contentViewHeight.constant, width: self.view.frame.width, height: self.customButtonView.contentViewHeight.constant)
            self.view.addSubview(customButtonView)
        }
    }
    
    func updateOptionView() {
        self.customButtonView.previousButton.isUserInteractionEnabled = self.webView.canGoBack
        self.customButtonView.previousButton.tintColor = self.webView.canGoBack ? themeColor : .gray
        self.customButtonView.forwardButton.isUserInteractionEnabled = self.webView.canGoForward
        self.customButtonView.forwardButton.tintColor = self.webView.canGoForward ? themeColor : .gray
        self.customButtonView.isHidden = self.isHiddenCustomButtonView

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.load(URLRequest(url: URL(string: "about:blank")!))
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    func webviewPrevious() {
        if self.webView.canGoBack  {
            self.webView.goBack()
        }
    }
    
    func webviewForward() {
        if self.webView.canGoForward  {
            self.webView.goForward()
        }
    }
    
    func webviewRefresh() {
        self.webView.reload()
    }
    
    func webviewShare() {
        if let url = self.webView.url {
            let activityViewController = UIActivityViewController(
                    activityItems: [url],
                    applicationActivities: [OpenSafariActivity(url: url)]
            )
            if UIDevice.isIpad() {
                activityViewController.popoverPresentationController?.sourceView = self.customButtonView
                activityViewController.popoverPresentationController?.sourceRect = self.customButtonView.shareButton.frame
            }
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
extension UGCEditArticleViewController: WKNavigationDelegate, WKUIDelegate {
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var actionPolicy:WKNavigationActionPolicy = .allow
        self.updateOptionView()
        if let url = navigationAction.request.url, self.isScorm {
            if url.pathExtension.lowercased() == "pdf" {
                actionPolicy = .cancel
                UIApplication.shared.open(url, options: [:])
            }
        }
        decisionHandler(actionPolicy)
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoading()
        self.setUpOptionView()
        /*
        self.webView.evaluateJavaScript("document.readyState") { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
                    //self.didHeightUpdate?.handler(webView.scrollView.contentSize.height)
                }
            }
        }
        */
    }
    
    // this handles target=_blank links by opening them in the same view
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if !(navigationAction.targetFrame?.isMainFrame ?? false) {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension UGCEditArticleViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.contentOffsetTemp = scrollView.contentOffset.y
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.customButtonView.isHidden = scrollView.contentOffset.y > self.contentOffsetTemp
    }
}
