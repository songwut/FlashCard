//
//  BaseCollectionReusableView.swift
//  connect
//
//  Created by Songwut Maneefun on 2/8/2560 BE.
//  Copyright © 2560 Conicle. All rights reserved.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    
    //class var id: String { return String.className(self) }
    
    open func setData(_ data: Any?) {
        
    }
    
    open class func size() -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
