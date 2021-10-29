//
//  FLPlayerHostingController.swift
//  flash
//
//  Created by Songwut Maneefun on 28/10/2564 BE.
//

import SwiftUI

class FLPlayerHostingController<ContentView>: UIHostingController<ContentView> where ContentView : View {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
    }
}
