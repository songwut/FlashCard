//
//  UGCPopupView.swift
//  flash
//
//  Created by Songwut Maneefun on 8/3/2565 BE.
//

import SwiftUI

struct UGCPopupView: View {
    var content: Any?
    var didClose: DidAction? = nil
    var error: NSError? = nil
    
    var body: some View {
        UGCPopupViewRep(content: content, didClose: didClose, error: error)
        //PopupManager.showWarning("warning_maximum_card".localized(), at: self)
    }
}


struct UGCPopupViewRep: UIViewControllerRepresentable {
    
    var content: Any?
    var didClose: DidAction? = nil
    var error: NSError? = nil
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.content = content
        vc.didClose = didClose
        vc.error = error
        UserManager.shared.currentPopup = vc
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


struct UGCPopupView_Previews: PreviewProvider {
    static var previews: some View {
        UGCPopupView()
    }
}
//PopupViewController

