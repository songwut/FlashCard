//
//  NavigationConfig.swift
//  flash
//
//  Created by Songwut Maneefun on 10/2/2565 BE.
//

import SwiftUI

struct NavigationConfig: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfig>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfig>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
