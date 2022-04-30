//
//  BaseTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//
import UIKit

open class BaseView : UIView {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var detailLabel: UILabel?
    
    var actionCount = 0
    var tagString: String = ""
    var didPressedCell: DidAction? {
        didSet {
            let contentViewTap = UITapGestureRecognizer(target: self, action: #selector(self.cellPressed(_:)))
            contentViewTap.delaysTouchesBegan = true
            self.addGestureRecognizer(contentViewTap)
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
            longPressGesture.minimumPressDuration = 2.0
            longPressGesture.allowableMovement = 15 // 15 points
            //longPressGesture.delegate = self
            self.addGestureRecognizer(longPressGesture)
        }
    }
    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: [.curveLinear], animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { (done) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: [.curveLinear], animations: {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }) { (done) in
                }
            }
        } else if sender.state == .changed {
            self.actionCount += 1
            ConsoleLog.show("self.actionCount: \(self.actionCount)")
            
        } else if sender.state == .ended {
            if self.actionCount <= 20 {
                self.didPressedCell?.handler(sender)
            }
            self.actionCount = 0
        }
    }
    var indexPath: IndexPath?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func awakeFromNib() {
        setup()
    }
    
    @objc func cellPressed(_ sender: UIButton) {
        self.didPressedCell?.handler(sender)
    }
    
    open func setup() {
        self.backgroundColor = .clear
        self.titleLabel?.font = FontHelper.getFont(.regular, size: .header)
        self.titleLabel?.textColor = UIColor.black
        self.detailLabel?.font = FontHelper.getFont(.regular, size: .normal)
        self.detailLabel?.textColor = UIColor(hex: "999999")
    }
    
    open class func height() -> CGFloat {
        return 48
    }
    
    open func setData(_ data: Any?) {
        /*
         if let menuText = data as? String {
         self.textLabel?.text = menuText
         }*/
    }
    
    open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
}
