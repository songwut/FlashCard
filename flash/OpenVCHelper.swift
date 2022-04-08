//
//  OpenVCHelper.swift
//  flash
//
//  Created by Songwut Maneefun on 7/4/2565 BE.
//

import Foundation
import SwiftUI

class OpenVCHelper {
    
    class func openUGCPreviewVideoAudio(viewModel: UGCPlayerFullScreenViewModel, playerVM: UGCPlayerViewModel, mainVC: UIViewController?) {
        let storyboard = UIStoryboard(name: "UGCPlayerFullScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UGCPlayerFullScreenViewController") as! UGCPlayerFullScreenViewController
        vc.playerVM = playerVM
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        if let nav = mainVC?.navigationController {
            nav.present(vc, animated: true, completion: nil)
        } else {
            mainVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    class func openUGCCreateMaterial(mainVC: UIViewController?) {
        //swiftUI
        /*
        UserManager.shared.tabMenu?.setTabBar(isHidden: true)
        let vc = UIHostingController(rootView: CreateMaterialListView())
        vc.view.backgroundColor = .white
        vc.title = "create_material".localized()
        */
        let storyboard = UIStoryboard(name: "CreateMaterial", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "CreateMaterialViewController") as! CreateMaterialViewController
        if let nav = mainVC?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            mainVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    class func openUGCCreateDoc(material: LMMaterialResult, mainVC: UIViewController?) {
        let viewModel = UGCCreateMediaViewModel(mId: material.id,
                                            contentCode: material.contentCode)
        let createDocView = UGCCreateDocSwiftUI(isCreated: true)
            .environmentObject(viewModel)
        let vc = UIHostingController(rootView: createDocView)
        vc.view.backgroundColor = .white
        
        if let nav = mainVC?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            mainVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    class func openUGCCreateMedia(material: LMMaterialResult, mainVC: UIViewController?) {
        let viewModel = UGCCreateMediaViewModel(mId: material.id,
                                            contentCode: material.contentCode)
        
        let createVideoView =  UGCCreateMediaSwiftUIView(isCreated: false)
            .environmentObject(viewModel)
        let vc = UIHostingController(rootView: createVideoView)
        vc.view.backgroundColor = .white
        
        if let nav = mainVC?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            mainVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    class func openUGCEditPost(material: LMMaterialResult, mainVC: UIViewController?) {
        let model = FLFlashCardViewModel()
        model.contentCode = material.contentCode
        model.materialId = material.id
        let vc = FLPostViewController.instantiate(viewModel: model)
        vc.createStatus = .edit
        vc.title = material.nameContent
        if let nav = mainVC?.navigationController {
            mainVC?.navigationItem.setHidesBackButton(true, animated:false)
            nav.pushViewController(vc, animated: true)
        } else {
            mainVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    class func openFlashcardUserPreview(id:Int,
                                        state: FLPlayerState = .user,
                                        slotId: Int? = nil,
                                        course:Parent? = nil,
                                        event:Parent? = nil,
                                        learningPathParam: APIParam? = nil,
                                        progress: ProgressResult? = nil,
                                        lmViewModel: LearningMaterialDetailViewModel? = nil,
                                        mainVC: UIViewController? = nil) {
        /*
        let viewModel = lmViewModel ?? LearningMaterialDetailViewModel()
        
        viewModel.learningMaterialId = id
        viewModel.typeVideo = .video
        viewModel.course = course
        viewModel.event = event
        viewModel.contentCode = .flashcard
        viewModel.learningPathParam = learningPathParam
        
        let s = UIStoryboard(name: "FlashUserDisplay", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "FLPlayerViewController") as! FLPlayerViewController
        vc.viewModel.materialId = id
        vc.viewModel.slotId = slotId
        vc.viewModel.course = course
        vc.viewModel.event = event
        vc.viewModel.learningPathParam = learningPathParam
        vc.isShowInfo = true
        vc.playerState = state// user send answer | just preview quiz UI
        vc.progress = progress
        vc.lmViewModel = viewModel
        
        if let nav = mainVC?.navigationController {
            nav.pushViewController(vc, animated: true)
            vc.navigationController?.isNavigationBarHidden = false
        } else {
            mainVC?.present(vc, animated: true, completion: nil)
            vc.navigationController?.isNavigationBarHidden = false
        }
        */
    }
}
