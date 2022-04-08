//
//  FLFlashPostView.swift
//  flash
//
//  Created by Songwut Maneefun on 26/10/2564 BE.
//

import SwiftUI

struct FLFlashPostView: View {
    
    var item: LMMaterialResult?
    
    var body: some View {
        FLPostViewControllerRep(item: self.item)
            .navigationBarBackButtonHidden(true)
        //custom nav back hide default
    }
}

struct UGCPostView: View {
    var item: LMMaterialResult?
    
    var body: some View {
        FLPostViewControllerRep(item: item)
    }
}

struct FLPostViewControllerRep: UIViewControllerRepresentable {
    var item: LMMaterialResult?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let model = FLFlashCardViewModel()
        let vc = FLPostViewController.instantiate(viewModel: model)
        model.contentCode = item?.contentCode ?? .flashcard
        if let item = self.item {//flashcard,video
            model.materialId = item.id
            vc.createStatus = .edit
        } else {
            vc.createStatus = .new//flashcard
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
