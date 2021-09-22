//
//  FLFlashEditorView.swift
//  flash
//
//  Created by Songwut Maneefun on 22/9/2564 BE.
//

import SwiftUI

struct FLFlashEditorView: View {
    var body: some View {
        StageViewController()
    }
}

struct StageViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "FlashCard", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "FLStageViewController")
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
