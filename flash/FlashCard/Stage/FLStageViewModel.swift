//
//  FLStageViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import UIKit
import Alamofire

protocol BaseViewProtocol {
    func showProgressLoading()
    func hideProgressLoading()
}

protocol FLStageViewModelProtocol: BaseViewProtocol {
    func stageUploading()
    var stageVC: FLStageViewController? { get set }
    
    func showProgressLoading()
    func hideProgressLoading()
}

class FLStageViewModel {
    
    var stageVC: FLStageViewController?
    
    var detail: FLDetailResult?
    var pageList = [FlashPageResult]()
    var flCard: FlCardResult?
    //var pageList: [FlashElement] = []()
    var pageIndex = 0
    var currentPage: FlashPageResult?
    var currentPageDetail: FLPageDetailResult?
    var flashId = 16
    
    func prepareModel() {
        //mock data
        
        if pageList.count == 0 {
            //create new 1 + 1
            let page0 = FLPageDetailResult(JSON: ["id" : 102])!
            pageList.append(page0)
            let page1 = FLPageDetailResult(JSON: ["id" : 2])!
            pageList.append(page1)
            
            let page2 = FLPageDetailResult(JSON: ["id" : 3])!
            pageList.append(page2)
            let page3 = FLPageDetailResult(JSON: ["id" : 4])!
            pageList.append(page3)
            
            currentPage = page0
        } else {
            //read api
        }
        
    }
    
    func callAPICurrentPageDetail(complete: @escaping () -> ()) {
        guard let page = self.currentPage else { return complete() }
        let request = FLRequest()
        request.endPoint = .ugcCardListDetail
        request.arguments = ["\(self.flashId)", "\(page.id)"]
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLPageDetailResult?, isCache, error) in
            self?.currentPageDetail = result
            complete()
        }
//
//        let fileName = "ugc-flash-card-id"
//        JSON.read(fileName) { (object) in
//            if let json = object as? [String : Any],
//               let item = FLDetailResult(JSON: json) {
//                detail = item
//            }
//            complete()
//        }
    }
    
    func callAPIFlashCard(complete: @escaping (_ result: FlCardResult?) -> ()) {
        let request = FLRequest()
        request.endPoint = .ugcCardList
        request.arguments = ["\(self.flashId)"]
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FlCardResult?, isCache, error) in
            if let item = result {
                self?.flCard = item
                self?.pageList = item.list
                self?.currentPage = item.list.first
                complete(self?.flCard)
            }
        }

//        let fileName = "ugc-flash-card-id-card"
//        JSON.read(fileName) { (object) in
//            if let json = object as? [String : Any],
//               let item = FlCardResult(JSON: json) {
//                flCard = item
//                pageList = item.list
//            }
//            complete(flCard)
//        }
    }
    
    func callAPICardList(cardId: Int ,complete: @escaping (_ page: FLPageDetailResult) -> ()) {
        //ugcCardIdDropbox
        
        let request = FLRequest()
        request.endPoint = .ugcCardListDetail
        request.arguments = ["\(self.flashId)", "\(cardId)"]
        // api array ??? bac need to fix
        //https://develop.conicle.co/api/ugc/flash-card/16/card/72/?format=json
//        API.requestForItems(request) { (body, list: [FLPageDetailResult]?, isCache, error) in
//            if let l = list, let detail = l.first {
//                self.currentPageDetail = detail
//                complete(detail)
//            }
//        }
        
        
        // correct
//        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLPageDetailResult?, isCache, error) in
//            if let page = result {
//                complete(page)
//            }
//        }
        
        let fileName = "ugc-flash-card-id-card-id"
        JSON.read(fileName) { (object) in
            if let dict = object as? [String : Any] {
                let detail = FLPageDetailResult(JSON: dict)!
                self.currentPageDetail = detail
                complete(detail)
            }
        }
    }
    
    func save(element: FlashElement, at index: Int) {
        //TODO: save API by page
        // convert element to dict -> save api
        currentPageDetail?.componentList.append(element)
    }
    
    func createNewQuiz(completion: @escaping (_ q: FLQuestionResult?) -> ()) {
        let fileName = "flash-card-new-quiz"
        JSON.read(fileName) { (object) in
            if let json = object as? [String : Any],
               let question = FLQuestionResult(JSON: json) {
                completion(question)
            } else {
                completion(nil)
            }
        }
    }
    
    func callAPIDropboxUpload(type: FLType ,row: Int, media: FLMediaResult?, iView: InteractView ,complete: @escaping () -> ()) {
        
        let card = self.pageList[row]
        
        let request = FLRequest()
        var params = [String: AnyObject]()
        if let m = media {
            //params["image"] = m.imageData as AnyObject
            //params["uuid"] = m.uuid as AnyObject
            //params["card_id"] = "\(card.id)" as AnyObject
            //params["file"] = m.file as AnyObject
            params["filename"] = m.filename as AnyObject
        }
        request.paramiter = params
        request.apiMethod = .post
        request.endPoint = .ugcCardIdDropbox
        request.arguments = ["\(self.flashId)", "\(card.id)"]
        
        let headers = request.headers
        ConsoleLog.show("URL:\(request.url)")
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if let m = media {
                multipartFormData.append(m.filename.data(using: String.Encoding.utf8)!, withName: "filename")
                
                if let imageData = m.imageData {
                    let fileType = URL(string: m.filename)?.pathExtension ?? "jpeg"
                    multipartFormData.append(imageData, withName: "image", fileName: m.filename, mimeType: "image/\(fileType)")
                }
                
                if let deviceUrl = m.deviceUrl {
                    multipartFormData.append(deviceUrl, withName: "file")
                }
            }
        }, to: request.url, headers: HTTPHeaders(headers!))
        .uploadProgress(queue: .main, closure: { progress in
            let percent = progress.fractionCompleted * 100
            self.stageVC?.showLoading("\(Int(percent))%")
            ConsoleLog.show("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { [self] respond in
            do {
                // make sure this JSON is in the format we expect
                ConsoleLog.show("Upload respond: \(respond)")
                if let data = respond.data {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let dropboxPage = FLDropboxPageResult(JSON: json)!
                        print("JSON: \(json)")
                        currentPageDetail?.dropboxPage = dropboxPage
                        //currentPageDetail?.componentList
                        iView.element?.src = dropboxPage.image
                        complete()
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        })
    }
    
    func callAPIDropboxList(cardId: Int ,complete: @escaping (_ page: FLPageDetailResult) -> ()) {
        
        let request = FLRequest()
        request.apiMethod = .get
        request.endPoint = .ugcCardIdDropbox
        request.arguments = ["\(self.flashId)", "\(cardId)"]
        API.request(request) { (responseBody: ResponseBody?, result: FLDropboxPageResult?, isCache, error) in
            if let page = result {
                
            }
        }
    }
    
}
