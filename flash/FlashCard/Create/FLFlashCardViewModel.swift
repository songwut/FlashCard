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
    var stageVC: FLCreateViewController? { get set }
    
    func showProgressLoading()
    func hideProgressLoading()
}

class FLFlashCardViewModel {
    
    var stageVC: FLCreateViewController?
    var myFlashCard: MaterialFlashPageResult?
    var detail: FLDetailResult?
    var pageList = [FLCardPageResult]()
    var flashCardDetail: FLFlashDetailResult? {
      didSet {
        self.newCard.total = self.flashCardDetail?.total ?? 0
      }
    }
    //var pageList: [FlashElement] = []()
    var pageIndex = 0
    var currentPage: FLCardPageResult?
    var currentPageDetail: FLCardPageDetailResult?
    var newCard = FLNewResult(JSON: ["total" : 0])!
    var flashId = 6
    
    func getQuizContent() -> FlashElement? {
        let current = self.currentPageDetail?.componentList.filter({ (flash) -> Bool in
            return flash.type == .quiz
        })
        return current?.first
    }
    
    func callAPIMyFlashCard(method:APIMethod, complete: @escaping (_ result: MaterialFlashPageResult?) -> ()) {
        let request = FLRequest()
        request.endPoint = .ugcFlashCreate
        request.apiMethod = method
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: MaterialFlashPageResult?, isCache, error) in
            self?.myFlashCard = result
            complete(result)
        }
    }
    
    //Flash create get list
    func callAPIFlashCard(complete: @escaping (_ result: FLFlashDetailResult?) -> ()) {
        let request = FLRequest()
        request.endPoint = .ugcCardList
        request.arguments = ["\(self.flashId)"]
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLFlashDetailResult?, isCache, error) in
            if let item = result {
                self?.flashCardDetail = item
                self?.pageList = item.list
                self?.currentPage = item.list.first
                complete(self?.flashCardDetail)
            }
        }

//        let fileName = "ugc-flash-card-id-card"
//        JSON.read(fileName) { (object) in
//            if let json = object as? [String : Any],
//               let item = FlDetailResult(JSON: json) {
//                flCard = item
//                pageList = item.list
//            }
//            complete(flCard)
//        }
    }
    
    func callAPIAddNewCard( param:[String: Any]? = nil, complete: @escaping (_ result: FLCardPageResult?) -> ()) {
        let request = FLRequest()
        request.apiMethod = .post
        request.endPoint = .ugcCardList
        request.arguments = ["\(self.flashId)"]
        request.parameter = param
        request.apiType = .json
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLCardPageResult?, isCache, error) in
            if let item = result {
                self?.pageList.append(item)
                self?.currentPage = item
                complete(item)
            }
        }
    }
    //ugcCardDetailAnswer
    func callAPICardDetail(_ currentCard: FLCardPageResult? ,
                           method: APIMethod = .get ,
                           param:[String: Any]? = nil,
                           complete: @escaping (_ page: FLCardPageDetailResult?) -> ()) {
        
        guard let card = currentCard else { return }
        let request = FLRequest()
        request.apiMethod = method
        request.parameter = param
        request.endPoint = .ugcCardListDetail
        request.arguments = ["\(self.flashId)", "\(card.id)"]
        request.apiType = .json
        
        //JSON format error
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLCardPageDetailResult?, isCache, error) in
            self?.currentPageDetail = result
            complete(result)
        }
        
        /*
        
        guard let url = URL(string: request.url) else { return }
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        urlRequest.httpMethod = method.rawValue
        if let json = param {
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
        }
        
        //header
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.addValue(key, forHTTPHeaderField: value)
            }
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    print("HTTPURLResponse: \(String(describing: response)))")
                    if let httpResponse = response as? HTTPURLResponse {
                            print("statusCode: \(httpResponse.statusCode)")
                    }
                    if let responseJSON = responseJSON as? [String: Any] {
                        print("API responseJSON:\n\(responseJSON)\n======")
                        self.currentPageDetail = FLCardPageDetailResult(JSON: responseJSON)
                        complete(self.currentPageDetail)
                    }
                }
            }
        task.resume()
 
        */
//        let fileName = "ugc-flash-card-id-card-id"
//        JSON.read(fileName) { (object) in
//            if let dict = object as? [String : Any] {
//                let detail = FLCardPageDetailResult(JSON: dict)!
//                self.currentPageDetail = detail
//                complete(detail)
//            }
//        }
    }
    
    func callAPICardDetailAnswer(_ currentCard: FLCardPageResult? ,
                           method: APIMethod = .get ,
                           param:[String: Any]? = nil,
                           complete: @escaping (_ ans: FLAnswerResult?) -> ()) {
        
        guard let card = currentCard else { return }
        let request = FLRequest()
        request.apiMethod = method
        request.parameter = param
        request.endPoint = .ugcCardDetailUserAnswer
        request.arguments = ["\(self.flashId)", "\(card.id)"]
        request.apiType = .json
        
        API.request(request) { (responseBody: ResponseBody?, result: FLAnswerResult?, isCache, error) in
            complete(result)
        }
    }
    
    func save(element: FlashElement, at index: Int) {
        //TODO: save API by page
        // convert element to dict -> save api
        currentPageDetail?.componentList.append(element)
    }
    
    func createNewQuiz(completion: @escaping (_ q: FlashElement?) -> ()) {
        let fileName = "flash-card-new-quiz"
        JSON.read(fileName) { (object) in
            if let json = object as? [String : Any],
               let question = FlashElement(JSON: json) {
                completion(question)
            } else {
                completion(nil)
            }
        }
    }
    
    func callAPIDropboxUpload(_ currentCard:FLCardPageResult? ,media: FLMediaResult?, iView: InteractView ,complete: @escaping () -> ()) {
        guard let card = currentCard else { return }
        
        let request = FLRequest()
        request.apiMethod = .post
        request.endPoint = .ugcCardIdDropbox
        request.arguments = ["\(self.flashId)", "\(card.id)"]
        request.apiType = .json
        let headers = request.headers
        ConsoleLog.show("URL:\(request.url)")
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if let m = media {
                multipartFormData.append("\(card.id)".data(using: .utf8)!, withName: "card_id")
                multipartFormData.append(m.filename.data(using: .utf8)!, withName: "filename")
                multipartFormData.append("\(m.uuid)".data(using: .utf8)!, withName: "uuid")
                
                if let mp4VideoUrl = media?.mp4VideoUrl {
                    multipartFormData.append(mp4VideoUrl, withName: "file")
                    
                } else if let imageData = m.imageData {
                    let fileType = URL(string: m.filename)?.pathExtension ?? "jpeg"
                    multipartFormData.append(imageData, withName: "image", fileName: m.filename, mimeType: "image/\(fileType)")
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
    
    func callAPIDropboxList(cardId: Int ,complete: @escaping (_ page: FLCardPageDetailResult) -> ()) {
        
        let request = FLRequest()
        request.apiMethod = .get
        request.endPoint = .ugcCardIdDropbox
        request.arguments = ["\(self.flashId)", "\(cardId)"]
        API.request(request) { (responseBody: ResponseBody?, result: FLDropboxPageResult?, isCache, error) in
            if let page = result {
                
            }
        }
    }
    
    func callApiDeleteList(_ selectList:[Int], apiMethod:APIMethod,completion: @escaping () -> ()) {
        var idList = [String]()
        for id in selectList {
            idList.append("\(id)")
        }
        print("selected id: \(idList)")
        let request = FLRequest()
        request.endPoint = .ugcCardList
        request.parameter = ["id_list": idList]
        request.apiMethod = apiMethod
        request.arguments = ["\(self.flashId)"]
        API.request(request) { (responseBody: ResponseBody?, result: FLFlashDetailResult?, isCache, error) in
            self.flashCardDetail = result
            if let listResult = result {
                self.pageList = listResult.list
            }
            completion()
        }
        
    }
    
    func callApiDuplicateList(_ selectList:[Int], apiMethod:APIMethod,completion: @escaping () -> ()) {
        var idList = [String]()
        for id in selectList {
            idList.append("\(id)")
        }
        print("selected id: \(idList)")
        let request = FLRequest()
        request.endPoint = .ugcCardListDuplicate
        request.parameter = ["id_list": idList]
        request.apiMethod = apiMethod
        request.arguments = ["\(self.flashId)"]
        API.request(request) { (responseBody: ResponseBody?, result: FLFlashDetailResult?, isCache, error) in
            self.flashCardDetail = result
            if let listResult = result {
                self.pageList = listResult.list
            }
            completion()
        }
        
    }
    
    
}
