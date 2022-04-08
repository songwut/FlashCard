//
//  FLFlashPlayerUIKitView.swift
//  flash
//
//  Created by Songwut Maneefun on 15/11/2564 BE.
//

import SwiftUI

struct FLFlashPlayerUIKitView: View {
    
    var flashId: Int? = nil
    
    var body: some View {
        FLPlayerViewControllerRep(flashId: flashId)
    }
}

struct FLPlayerViewControllerRep: UIViewControllerRepresentable {
    var flashId: Int?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let s = UIStoryboard(name: "FlashUserDisplay", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLPlayerViewController") as! FLPlayerViewController
        vc.viewModel.materialId = self.flashId ?? 0
        vc.playerState = .preview
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct FLFlashPlayerUIKitView_Previews: PreviewProvider {
    static var previews: some View {
        FLFlashPlayerUIKitView()
    }
}
