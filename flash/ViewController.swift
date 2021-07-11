//
//  ViewController.swift
//  flash
//
//  Created by Songwut Maneefun on 4/6/2564 BE.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet private weak var stageButton: UIButton!
    
    
    
    func getCenter(_ view: UIView) -> CGPoint {
        let parentFrame = view.superview?.frame ?? .zero
        let x = (parentFrame.width - view.frame.width) / 2
        let y = (parentFrame.height - view.frame.height) / 2
        return CGPoint(x: x, y: y)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = FlashStyle.screenColor
        
        let screenHeight = self.view.frame.height
        let screenWidth = self.view.frame.width
        let screenRatio:CGFloat = 16 / 9
        let height = screenWidth * screenRatio
        var stageFrame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        
        if stageFrame.height > screenHeight {//ipad 3:4 will use this case
            //need scale down height
            //ratioDown 0.x - 1.0
            let ratioDown = screenHeight / stageFrame.height
            let newHeight = stageFrame.height * ratioDown
            let newWidth = stageFrame.width * ratioDown
            let newX = (screenWidth - newWidth) / 2
            let updateFrame = CGRect(x: newX, y: 0, width: newWidth, height: newHeight)
            stageFrame = updateFrame
        }
        //calculate for ipad stageFrame
        
        
        
        // Do any additional setup after loading the view.
        self.stageButton.addTarget(self, action: #selector(self.stageButtonPressed(_:)), for: .touchUpInside)
        
        
    }
    
    @objc func stageButtonPressed(_ sender: UIButton) {
        let s = UIStoryboard(name: "FlashCard", bundle: nil)
        let vc = s.instantiateViewController(identifier: "FLStageViewController")
        if let nav = self.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
}

