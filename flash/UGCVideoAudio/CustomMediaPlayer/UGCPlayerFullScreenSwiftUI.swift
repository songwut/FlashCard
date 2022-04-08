//
//  UGCPlayerFullScreenSwiftUI.swift
//  LEGO
//
//  Created by Songwut Maneefun on 11/3/2565 BE.
//  Copyright © 2565 BE conicle. All rights reserved.
//

import SwiftUI

struct UGCPlayerFullScreenSwiftUI: View {
    var viewModel: UGCPlayerFullScreenViewModel
    @StateObject var playerVM: UGCPlayerViewModel
    
    var body: some View {
        UGCPlayerFullScreenSwiftUIRep(viewModel: self.viewModel, playerVM: self.playerVM)
            .ignoresSafeArea()
    }
}

struct UGCPlayerFullScreenSwiftUIRep: UIViewControllerRepresentable {
    
    var viewModel: UGCPlayerFullScreenViewModel
    @StateObject var playerVM: UGCPlayerViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "UGCPlayerFullScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UGCPlayerFullScreenViewController") as! UGCPlayerFullScreenViewController
        vc.playerVM = self.playerVM
        vc.viewModel = self.viewModel
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
