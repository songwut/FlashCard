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

class FLQuizInfoViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet private weak var ansTextHeight: NSLayoutConstraint!
    @IBOutlet private weak var footerHeight: NSLayoutConstraint!
    @IBOutlet private weak var progressStackView: UIStackView!
    
    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var userTableView: UITableView!
    @IBOutlet private weak var userListHeight: NSLayoutConstraint!
    
    
    private var quizInfoSheetView: FLQuizInfoProgressView?
    
    var flashCardDetail: FLFlashDetailResult?
    var delegate: FLQuizInfoViewControllerDelegate?
    
    let userAnswerList = [
        UserAnswerResult(JSON: ["name" : "wrrwer"])!,
        UserAnswerResult(JSON: ["name" : "ererwre"])!,
        UserAnswerResult(JSON: ["name" : "rgrggefsfs"])!,
        UserAnswerResult(JSON: ["name" : "ukyk"])!,
        UserAnswerResult(JSON: ["name" : "prgrto"])!,
        UserAnswerResult(JSON: ["name" : "trterm,"])!,
        UserAnswerResult(JSON: ["name" : "wrrwer"])!,
        UserAnswerResult(JSON: ["name" : "ererwre"])!,
        UserAnswerResult(JSON: ["name" : "rgrggefsfs"])!,
        UserAnswerResult(JSON: ["name" : "ukyk"])!
    ]
    
    var selfFrame: CGRect = .zero
    
    init(frame: CGRect, flashCardDetail: FLFlashDetailResult?) {
        self.selfFrame = frame
        self.flashCardDetail = flashCardDetail
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
        let userAns = [["name" : "ฮอกไกโด"], ["name" : "เขาใหญ่"]]// ["user_answer_list" : ]
        let userAnswerPage = UserAnswerPageResult(JSON: ["value" : "quiz name", "choice" : [["value" : "ฮอกไกโด", "is_answer":true, "percent": 70], ["value" : "เขาใหญ่", "percent": 30]], "user_answer_list": userAns])!
        let infoSheetView = self.quizInfoSheetView ?? FLQuizInfoProgressView(userAnswerPage: userAnswerPage)
        let infoVC = UIHostingController(rootView: infoSheetView)
        
        let width = self.progressStackView.frame.width
        let pading: CGFloat = FlashStyle.quiz.choiceSpacing * CGFloat(userAnswerPage.choiceList.count)
        let allChoice: CGFloat = FlashStyle.quiz.choiceMinHeight * CGFloat(userAnswerPage.choiceList.count)
        let height: CGFloat = 50 + allChoice + pading
        infoVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.progressStackView.addArrangedSubview(infoVC.view)
        
        let maxHeight: CGFloat = 358
        let allH: CGFloat = CGFloat(userAnswerList.count) * FlashStyle.quiz.userMinHeight
        let userH = allH >= maxHeight ? maxHeight : allH
        self.userListHeight.constant = userH
        
        self.userTableView.separatorStyle = .none
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
        self.userTableView.reloadData()
        self.userTableView.reloadData()
    }
    
    @IBAction func closePressed(_ sender: UIButton?) {
        self.delegate?.quizInfoViewControllerClose(self)
    }

}

extension FLQuizInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userAnswerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FLUserTableViewCell.id) as! FLUserTableViewCell
        cell.user = self.userAnswerList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FLUserTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
