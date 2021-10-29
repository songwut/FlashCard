//
//  UIViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import UIKit

extension UIViewController {
    
    static func initFromNib() -> Self {
        func instanceFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: self), bundle: nil)
        }
        return instanceFromNib()
    }
    
    var safeAreaTopHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.window
            let topPadding = window?.safeAreaInsets.top ?? 0
            return topPadding
        } else {
            let window = UIApplication.shared.window
            let topPadding = window?.safeAreaInsets.top ?? 0
            return topPadding
        }
    }
    
    var safeAreaBottomHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.window
            let topPadding = window?.safeAreaInsets.bottom ?? 0
            return topPadding
        } else {
            let window = UIApplication.shared.window
            let topPadding = window?.safeAreaInsets.bottom ?? 0
            return topPadding
        }
    }
    
    func updateNavigationTheme(barTintColor: UIColor, tintColor: UIColor) {
        let fontNav = FontHelper.getFont(.regular, size: .header)
        let titleFontAttrs = [ NSAttributedString.Key.font: fontNav, NSAttributedString.Key.foregroundColor: tintColor ]
        //let barButtonFontAttrs = [ NSAttributedString.Key.font: fontNav ]
        var backImage = UIImage(named: "icn_back")
        backImage = backImage?.stretchableImage(withLeftCapWidth: 18, topCapHeight: 17)
        
        UITabBar.appearance().backgroundColor = UIColor.white
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().backgroundColor = barTintColor
        UINavigationBar.appearance().tintColor = tintColor
        UIApplication.shared.statusBarView?.backgroundColor = barTintColor // for iOS 11 Large Titles
        UINavigationBar.appearance().titleTextAttributes = titleFontAttrs
        
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = barTintColor // If you want different nav background color other than white
            
            appearance.titleTextAttributes = titleFontAttrs
            appearance.largeTitleTextAttributes = titleFontAttrs // If your app supports largeNavBarTitle
            
            appearance.buttonAppearance.normal.titleTextAttributes = titleFontAttrs
            appearance.buttonAppearance.highlighted.titleTextAttributes = titleFontAttrs
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            
            UINavigationBar.appearance().titleTextAttributes = titleFontAttrs
            UIBarButtonItem.appearance().setTitleTextAttributes(titleFontAttrs, for: .normal)
            UIBarButtonItem.appearance().setTitleTextAttributes(titleFontAttrs, for: .highlighted)
        }
        
    }
    
    @objc func searchPressed() {
        
    }
    
    @objc func calendarPressed() {
        
    }
    
    class func with(_ storyboardName: String, storyboardId: String) -> UIViewController? {
        let vc = UIStoryboard(name: storyboardName,
                              bundle: nil).instantiateViewController(withIdentifier: storyboardName)
        return vc
    }
    
    func setLargeTitles(isLarge: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = isLarge
        navigationItem.largeTitleDisplayMode = isLarge ?.automatic : .never
    }
    
    func getNavHeight() -> CGFloat {
        if let nav = navigationController {
            return nav.navigationBar.frame.size.height
        }
        return 0.0
    }
    
    func isModal() -> Bool {
        
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self {
                return false
            }
        }
        
        if self.presentingViewController != nil {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    func topViewController() -> UIViewController? {
        return self.topViewControllerWithRootViewController(UIApplication.shared.window?.rootViewController)
    }
    
    func topViewControllerWithRootViewController(_ rootViewController:UIViewController?) -> UIViewController? {
        
        if rootViewController is UITabBarController{
            let control = rootViewController as! UITabBarController
            return self.topViewControllerWithRootViewController(control.selectedViewController)
            
        } else if rootViewController is UINavigationController{
            let control = rootViewController as! UINavigationController
            return self.topViewControllerWithRootViewController(control.visibleViewController)
            
        } else if let control = rootViewController?.presentedViewController{
            return self.topViewControllerWithRootViewController(control)
        }
        
        return rootViewController
        
    }
    
    func showLoading(_ text: String?) {
        UIApplication.shared.window?.showLoading(text)
    }
    
    func showText(_ text: String?) {
        UIApplication.shared.window?.showText(text)
    }
    
    func alertHUD(_ errorType:ErrorType){
        let error = errorType.domain().localized()
        UIApplication.shared.window?.alertHUD(error)
    }
    
    func alertHUD(_ msg:String) {
        UIApplication.shared.window?.alertHUD(msg)
    }
    
    @objc func hideLoading() {
        UIApplication.shared.window?.hideLoading()
    }
}
