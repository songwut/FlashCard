//
//  FLFlashEditorView.swift
//  flash
//
//  Created by Songwut Maneefun on 22/9/2564 BE.
//

import SwiftUI

struct FLFlashEditorView: View {
    
    var flashId: Int? = nil
    
    var body: some View {
        FLEditorViewControllerRep(flashId: flashId)
    }
}

struct FLEditorViewControllerRep: UIViewControllerRepresentable {
    var flashId: Int?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "FlashCard", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "FLEditorViewController") as! FLEditorViewController
        
        if let flashId = self.flashId {
            controller.viewModel.flashId = flashId
            controller.createStatus = .edit
        } else {
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
