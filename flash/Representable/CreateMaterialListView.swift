//
//  CreateMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 29/11/2564 BE.
//

import SwiftUI

import IQKeyboardManagerSwift

struct CreateMaterialListView: View {
    
    var body: some View {
        CreateMaterialViewControllerRep()
            .onAppear {
                IQKeyboardManager.shared.enable = false
                IQKeyboardManager.shared.enableAutoToolbar = false
                IQKeyboardManager.shared.unregisterAllNotifications()
            }
    }
}

struct CreateMaterialViewControllerRep: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        //let vc = CreateMaterialViewController()
        //return vc
        
        let storyboard = UIStoryboard(name: "CreateMaterial", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "CreateMaterialViewController") as! CreateMaterialViewController
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct CreateMaterialListView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMaterialListView()
    }
}

