//
//  FLFlashEditorView.swift
//  flash
//
//  Created by Songwut Maneefun on 22/9/2564 BE.
//

import SwiftUI
import IQKeyboardManagerSwift

struct FLFlashEditorView: View {
    
    var flashId: Int? = nil
    
    var body: some View {
        FLEditorViewControllerRep(flashId: flashId)
            .onAppear {
                IQKeyboardManager.shared.enable = false
                IQKeyboardManager.shared.enableAutoToolbar = false
                IQKeyboardManager.shared.unregisterAllNotifications()
            }
    }
}

struct FLEditorViewControllerRep: UIViewControllerRepresentable {
    var flashId: Int?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "FlashCard", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "FLEditorViewController") as! FLEditorViewController
        
        if let flashId = self.flashId {
            controller.viewModel.materialId = flashId
            controller.createStatus = .edit
        } else {
            controller.viewModel.materialId = 0
            controller.createStatus = .new
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct FLFlashEditorView_Previews: PreviewProvider {
    static var previews: some View {
        FLFlashEditorView()
    }
}
