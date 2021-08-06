//
//  BaseViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 2/8/2564 BE.
//

import UIKit

class BaseViewModel: NSObject {
    
    var latestRequest: APIRequest?
    
    override init() {
        super.init()
    }
    
    open func setData(_ data: Any?) {
        
    }
    
    open func callApi(completion: @escaping () -> ()) {
        
    }
}
