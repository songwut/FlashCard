//
//  OpenSafariActivity.swift
//  flash
//
//  Created by Songwut Maneefun on 20/4/2565 BE.
//


import UIKit

class OpenSafariActivity: UIActivity {
    
    var url: URL?

    init(url: URL?) {
        self.url = url
    }

    override var activityTitle: String? {
        return "Open in Safari"
    }

    override var activityImage: UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "safari")
        } else {
            return nil
        }
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        if let _ = self.url {
            return true
        }
        return false
    }
    
    override func perform() {
        if let url = self.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
