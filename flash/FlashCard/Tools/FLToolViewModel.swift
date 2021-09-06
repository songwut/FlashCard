//
//  FLToolViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import Foundation

struct FLToolViewSetup {
    var title: String?
    var tool: FLTool
    var iView: InteractView?
    
}

class FLToolViewModel {
    var tool: FLTool = FLTool.menu
    var graphicMenu: FLGraphicMenu = .shape
    var iView: InteractView?
    var graphicList = [FLGraphicResult]()
    private var colorList = [FLColorResult]()
    
    func colorList(complete: @escaping (_ list: [FLColorResult]) -> ()) {
        let request = FLRequest()
        request.endPoint = .ugcFlashColor
        API.request(request) { (responseBody: ResponseBody?, pageResult: FLColorPageResult?, isCache, error) in
            if let page = pageResult {
                self.colorList = page.list
            }
            complete(self.colorList)
        }
        
//        JSON.read("flash-card-color") { (object) in
//            guard let list = object as? [String] else {
//                return complete([])
//            }
//            self.colorList = list
//            complete(list)
//        }
    }
    
    func graphicList(complete: (_ list: [FLGraphicResult]) -> ()) {
        
    }
    
    func callApiGraphic(complete: @escaping (_ page: [FLGraphicResult]) -> ()) {
        let request = FLRequest()
        let endPoint:EndPoint = self.graphicMenu == .shape ? .ugcFlashShape : .ugcFlashSticker
        request.endPoint = endPoint
        API.request(request) { (responseBody: ResponseBody?, pageResult: FLGraphicPageResult?, isCache, error) in
            if let page = pageResult {
                self.graphicList = page.list
            }
            complete(self.graphicList)
        }
        
//        let fileName = self.graphicMenu == .shape ? "flash-card-shape" : "flash-card-sticker"
//        JSON.read(fileName) { (object) in
//            guard let json = object as? [String : Any] else {
//                return completion(self.graphicList)
//            }
//            if let page = FLGraphicPageResult(JSON: json) {
//                self.graphicList = page.list
//            }
//            completion(self.graphicList)
//        }
    }
    
}
