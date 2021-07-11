//
//  StatViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 5/7/2564 BE.
//

import UIKit

class StatViewController: UIViewController {

    var statLabel: UILabel!
    var lastRotation: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func createStatView( in view: UIView) {
        self.statLabel = UILabel()
        self.statLabel.textColor = .red
        self.statLabel.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(self.statLabel)
    }
    
    func updateStat(_ view: InteractView) {
        self.statLabel.numberOfLines = 0
        var statText = "\(InteractView.self): degrees \(view.rotation)\n X: \(view.frame.origin.x)\n Y: \(view.frame.origin.y)\n W: \(view.frame.size.width)\n W: \(view.frame.size.width)\n"
        statText = statText + "bounds"
        statText = statText + "X: \(view.bounds.origin.x)\n Y: \(view.bounds.origin.y)\n W: \(view.bounds.size.width)\n W: \(view.bounds.size.width)\n"
        statText = statText + "center"
        statText = statText + "X: \(view.center.x)\n Y: \(view.center.y)\n"
        self.statLabel.text = statText
        let width = view.superview?.frame.width ?? 0
        let size = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = self.statLabel.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        let y = view.superview?.frame.origin.y ?? 0
        self.statLabel.frame = CGRect(x: 0, y: y, width: width, height: height)
        
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
