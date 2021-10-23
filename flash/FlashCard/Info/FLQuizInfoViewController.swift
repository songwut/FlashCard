//
//  FLQuizInfoViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 29/9/2564 BE.
//

import UIKit
import SwiftUI

protocol FLQuizInfoViewControllerDelegate {
    func quizInfoViewControllerClose(_ vc: FLQuizInfoViewController)
}

class FLQuizInfoViewController: PageViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleHeight: NSLayoutConstraint!
    @IBOutlet private weak var ansTextHeight: NSLayoutConstraint!
    @IBOutlet private weak var footerHeight: NSLayoutConstraint!
    @IBOutlet private weak var progressHeight: NSLayoutConstraint!
    @IBOutlet private weak var progressStackView: UIStackView!
    
    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var userTableView: UITableView!
    @IBOutlet private weak var userListHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var emptyView: UIView!
    
    private var quizInfoVC: UIHostingController<FLQuizInfoProgressView>!
    private var quizInfoSheetView: FLQuizInfoProgressView?
    
    var viewModel: FLFlashCardViewModel!
    var delegate: FLQuizInfoViewControllerDelegate?
    var userAnswerList = [FLAnswerResult]()
    var selfFrame: CGRect = .zero
    
    init(frame: CGRect, viewModel: FLFlashCardViewModel) {
        self.selfFrame = frame
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selfFrame = .zero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bounds = self.selfFrame
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        self.titleHeight.constant = UIDevice.isIpad() ? 80 : 60
        self.ansTextHeight.constant = UIDevice.isIpad() ? 90 : 50
        self.titleLabel.textColor = .black
        self.answerLabel.textColor = .black
        self.titleLabel.font = .font(UIDevice.isIpad() ? 24 : 14, font: .medium)
        self.titleLabel.text = "quiz".localized()
        self.answerLabel.text = "Answer".localized()
        self.userTableView.backgroundColor = .white
        self.userTableView.updateLayout()
        self.progressStackView.updateLayout()
        
        self.userTableView.register(UINib(nibName: "FLUserTableViewCell", bundle: nil), forCellReuseIdentifier: FLUserTableViewCell.id)
        
        self.answerLabel.text = "answer".localized()
        self.answerLabel.font = .font( UIDevice.isIpad() ? 28 : 14, font: .medium)
        self.userListHeight.constant = 0
        
        self.tableView = self.userTableView
        self.userTableView.separatorStyle = .none
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
        self.userTableView.reloadData()
        
        let card = self.viewModel.currentPage
        self.viewModel.callAPICardDetailAnswerDetail(card, method: .get, param: nil) { [weak self] (result) in
            if let userAnswerPage = result {
                self?.userAnswerList = userAnswerPage.userAnswerList
                self?.manage(userAnswerPage: userAnswerPage)
            }
        }
    }
    
    func manage(userAnswerPage: UserAnswerPageResult) {
        DispatchQueue.main.async { [self] in
            let width = self.progressStackView.frame.width
            var infoSheetView = self.quizInfoSheetView ?? FLQuizInfoProgressView(userAnswerPage: userAnswerPage, width: width)
            infoSheetView.delegate = self
            self.quizInfoVC = UIHostingController(rootView: infoSheetView)
            
            let pading: CGFloat = FlashStyle.quiz.choiceSpacing * CGFloat(userAnswerPage.choiceList.count)
            let allChoice: CGFloat = FlashStyle.quiz.choiceMinHeight * CGFloat(userAnswerPage.choiceList.count)
            let height: CGFloat = 50 + allChoice + pading
            self.quizInfoVC.view.backgroundColor = .clear
            self.quizInfoVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.progressStackView.addArrangedSubview(self.quizInfoVC.view)
            
            let maxHeight: CGFloat = 358
            let allH: CGFloat = CGFloat(self.userAnswerList.count) * FlashStyle.quiz.userMinHeight
            let userH = allH >= maxHeight ? maxHeight : allH
            self.userListHeight.constant = userH
            self.userTableView.reloadData()
            
            //*custom UIBezierPath need to updateLayout before drawing
            self.cardView.updateLayout()
            self.cardView.roundCorners([.topLeft, .topRight], radius: 16)
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton?) {
        self.delegate?.quizInfoViewControllerClose(self)
    }

    //MARK: - Paging Function
    override func scrollViewDidEndDeceleratingAnimatingFinal() {
        self.loadingPageView?.startAnimate()
        self.isLoading = true
        self.viewModel.isLoadNextPage = true
        
        let card = self.viewModel.currentPage
        self.viewModel.callAPICardDetailAnswerDetail(card, method: .get, param: nil) { [weak self] (result) in
            guard let self = self else { return }
            if let userAnswerPage = result {
                self.userAnswerList = userAnswerPage.userAnswerList
                self.nextPage = self.viewModel.nextPage
                self.isLoading = false
                self.tableView.reloadData()
                self.loadingPageView?.stopAnimate()
            }
        }
    }
}

extension FLQuizInfoViewController: FLQuizProgressBarDelegate{
    func didUpdateHeight(_ size: CGSize) {
        self.quizInfoVC.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.progressHeight.constant = size.height
        
        self.cardView.updateLayout()
        self.cardView.roundCorners([.topLeft, .topRight], radius: 16)
    }
}

extension FLQuizInfoViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userAnswerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FLUserTableViewCell.id) as! FLUserTableViewCell
        cell.answer = self.userAnswerList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FLUserTableViewCell.height()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension FLQuizInfoViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
}
