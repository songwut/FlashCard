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

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var footerHeight: NSLayoutConstraint!
    @IBOutlet private weak var progressStackView: UIStackView!
    
    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var userTableView: UITableView!
    @IBOutlet private weak var userListHeight: NSLayoutConstraint!
    
    var userListView: FLQuizUserListView?
    var quizInfoSheetView: FLQuizInfoProgressView?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        self.cardView.updateLayout()
        self.userTableView.updateLayout()
        self.cardView.roundCorners([.topLeft, .topRight], radius: 16)
        self.progressStackView.updateLayout()
        
        self.userTableView.register(UINib(nibName: "FLUserTableViewCell", bundle: nil), forCellReuseIdentifier: FLUserTableViewCell.id)
        
        self.answerLabel.text = "answer".localized()
        self.answerLabel.font = FontHelper.getFontSystem(14, font: .medium)
        let userAns = [["name" : "ฮอกไกโด"], ["name" : "เขาใหญ่"]]// ["user_answer_list" : ]
        let userAnswerPage = UserAnswerPageResult(JSON: ["value" : "quiz name", "choice" : [["value" : "ฮอกไกโด", "is_answer":true, "percent": 70], ["value" : "เขาใหญ่", "percent": 30]], "user_answer_list": userAns])!
        let infoSheetView = self.quizInfoSheetView ?? FLQuizInfoProgressView(userAnswerPage: userAnswerPage)
        let infoVC = UIHostingController(rootView: infoSheetView)
        //infoVC.rootView.delegate = self
        
        let width = self.progressStackView.frame.width
        let pading: CGFloat = CGFloat(8 * userAnswerPage.choiceList.count)
        let allChoice: CGFloat = CGFloat(36 * userAnswerPage.choiceList.count)
        let height: CGFloat = 50 + allChoice + pading
        infoVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        //infoVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.progressStackView.addArrangedSubview(infoVC.view)
        
        
        let userListView = self.userListView ?? FLQuizUserListView(maxSize: 50)
        userListView.items = userAnswerList
        let maxHeight: CGFloat = 358
        let allH: CGFloat = CGFloat(userAnswerList.count * 60)
        let userH = allH >= maxHeight ? maxHeight : allH
        let userListVC = UIHostingController(rootView: userListView)
        userListVC.view.bounds = CGRect(x: 0, y: 0, width: width, height: userH)
        //self.userView.addSubview(userListVC.view)
        self.userListHeight.constant = userH
        
        self.userTableView.separatorStyle = .none
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
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
