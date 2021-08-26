//
//  FLCardInfoViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 26/8/2564 BE.
//

import UIKit

class FLCardInfoViewController: UIViewController {
    @IBOutlet weak var iconCount: UIImageView!
    @IBOutlet weak var iconLike: UIImageView!
    @IBOutlet weak var iconQuiz: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var quizLabel: UILabel!
    //@IBOutlet weak var tagView: TagListView!
    //@IBOutlet weak var tagHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textColor = ColorHelper.text()
        self.iconCount.tintColor = textColor
        self.iconLike.tintColor = textColor
        self.iconQuiz.tintColor = textColor
        
        self.countLabel.textColor = textColor
        self.likeLabel.textColor = textColor
        self.quizLabel.textColor = textColor
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
