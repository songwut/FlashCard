//
//  FLInfoPageViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 29/9/2564 BE.
//

import UIKit

class FLInfoPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet private weak var contentStackView: UIStackView!
    
    var cardInfoVC: FLCardInfoViewController!
    var quizInfoVC: FLQuizInfoViewController!
    var pageVC: UIPageViewController!
    var pages = [UIViewController]()
    
    var quiz: FlashElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        self.view.updateLayout()
        //self.footerHeight.constant = self.safeAreaBottomHeight
        
        let isQuiz = !(self.quiz == nil)
        self.cardInfoVC = FLCardInfoViewController()
        self.cardInfoVC.delegate = self
        self.cardInfoVC.isQuiz = isQuiz
        self.pages.append(self.cardInfoVC)
        
        if isQuiz {
            self.quizInfoVC = FLQuizInfoViewController()
            self.quizInfoVC.delegate = self
            self.pages.append(self.cardInfoVC)
        }
        
        self.pageVC = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: .horizontal)
        self.addChild(self.pageVC)
        self.pageVC.view.backgroundColor = .clear
        self.pageVC.view.bounds = self.view.bounds
        self.contentStackView.addArrangedSubview(self.pageVC.view)
        self.pageVC.delegate = self
        self.pageVC.dataSource = self
        
        //self.pageVC.reloadInputViews()
        self.pageVC.setViewControllers([self.cardInfoVC], direction: .forward, animated: true) { (done) in
            print("pageVC.setViewControllers")
            self.pageScrollEnabled(false)
        }
        
    }
    
    private func pageScrollEnabled(_ isScrollEnabled: Bool){
        for view in self.pageVC.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = isScrollEnabled
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("didFinishAnimating")
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.pages.firstIndex(of: viewController) {
                if index == 0 {
                    // wrap to last page in array
                    return self.pages.last
                } else {
                    // go to previous page in array
                    return self.pages[index - 1]
                }
            }
            return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.pages.firstIndex(of: viewController) {
                if index < self.pages.count - 1 {
                    // go to next page in array
                    return self.pages[index + 1]
                } else {
                    // wrap to first page in array
                    return self.pages.first
                }
            }
            return nil
    }

}

extension FLInfoPageViewController: FLCardInfoViewControllerDelegate, FLQuizInfoViewControllerDelegate {
    
    func cardInfoViewControllerOpenQuizInfo(_ vc: FLCardInfoViewController) {
        self.pageScrollEnabled(true)
        guard let quizVC = self.quizInfoVC else { return }
        self.pageVC.setViewControllers([quizVC], direction: .forward, animated: true) { (done) in
            self.pageScrollEnabled(false)
        }
    }
    
    func cardInfoViewControllerClose(_ vc: FLCardInfoViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func quizInfoViewControllerClose(_ vc: FLQuizInfoViewController) {
        self.pageScrollEnabled(true)
        guard let cardInfoVC = self.cardInfoVC else { return }
        self.pageVC.setViewControllers([cardInfoVC], direction: .reverse, animated: true) { (done) in
            self.pageScrollEnabled(false)
        }
    }
    
}
