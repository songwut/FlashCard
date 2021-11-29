//
//  FLFlashPostView.swift
//  flash
//
//  Created by Songwut Maneefun on 26/10/2564 BE.
//

import SwiftUI

struct FLFlashPostView: View {
    
    var flashId: Int? = nil
    
    var body: some View {
        FLPostViewControllerRep(flashId: flashId)
    }
}

struct FLPostViewControllerRep: UIViewControllerRepresentable {
    var flashId: Int?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let model = FLFlashCardViewModel()
        let vc = FLPostViewController.instantiate(viewModel: model)
        
        if let flashId = self.flashId {
            model.flashId = flashId
            vc.createStatus = .edit
        } else {
            vc.createStatus = .new
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct FLFlashPostView_Previews: PreviewProvider {
    static var previews: some View {
        FLFlashPostView()
    }
}
