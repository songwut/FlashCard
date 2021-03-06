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
    
    var viewModel: FLFlashCardViewModel!
    var detail: FLDetailResult?
    var quiz: FlashElement?
    
    var selfFrame: CGRect = .zero
    
    var didPressTag: DidAction?
    
    init(frame: CGRect, viewModel: FLFlashCardViewModel) {
        self.viewModel = viewModel
        self.selfFrame = frame
        self.detail = viewModel.detail
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selfFrame = .zero
    }
    
    deinit {
        ConsoleLog.show(self.className + "removed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bounds = self.selfFrame
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        self.view.updateLayout()
        
        //self.footerHeight.constant = self.safeAreaBottomHeight
        
        let isQuiz = !(self.quiz == nil)
        self.cardInfoVC = FLCardInfoViewController(frame: self.view.bounds, detail: self.detail, isQuiz: isQuiz)
        self.cardInfoVC.view.frame = self.view.bounds
        self.cardInfoVC.view.setNeedsDisplay()
        self.cardInfoVC.cardView.updateLayout()
        self.cardInfoVC.cardView.roundCorners([.topLeft, .topRight], radius: 16)
        self.cardInfoVC.detail = self.detail
        print(self.cardInfoVC.view.frame)
        self.cardInfoVC.delegate = self
        self.cardInfoVC.didPressTag = self.didPressTag
        self.cardInfoVC.isQuiz = isQuiz
        self.pages.append(self.cardInfoVC)
        
        let tap = TapGesture(target: self, action: #selector(self.viewTap(_:)))
        self.cardInfoVC.emptyView.addGestureRecognizer(tap)
        
        if isQuiz {
            self.quizInfoVC = FLQuizInfoViewController(frame: self.view.bounds, viewModel: self.viewModel)
            self.quizInfoVC.quiz = self.quiz
            self.quizInfoVC.view.frame = self.view.bounds
            self.quizInfoVC.cardView.updateLayout()
            self.quizInfoVC.cardView.roundCorners([.topLeft, .topRight], radius: 16)
            self.quizInfoVC.delegate = self
            self.pages.append(self.quizInfoVC)
            
            let tap = TapGesture(target: self, action: #selector(self.viewTap(_:)))
            self.quizInfoVC.emptyView.addGestureRecognizer(tap)
        }
        /*
        //Stack View
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 0.0

        for vc in self.pages {
            ConsoleLog.show("view: \(vc.view)")
            let width = vc.view.frame.width
            vc.view.setWidthConstraint(width)
            stackView.addArrangedSubview(vc.view)
        }
        self.contentStackView.addArrangedSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        */
        self.pageVC = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: .horizontal)
        self.pageVC.view.frame = self.view.bounds
        self.addChild(self.pageVC)
        self.pageVC.view.backgroundColor = .clear
        self.contentStackView.addArrangedSubview(self.pageVC.view)
        self.pageVC.delegate = self
        self.pageVC.dataSource = self
        
        //self.pageVC.reloadInputViews()
        self.pageVC.setViewControllers([self.cardInfoVC], direction: .forward, animated: true) { (done) in
            print("pageVC.setViewControllers")
            self.pageScrollEnabled(false)
        }
        
    }
    
    @objc func viewTap(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func pageScrollEnabled(_ isScrollEnabled: Bool){
        for view in self.pageVC.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = isScrollEnabled
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        
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
