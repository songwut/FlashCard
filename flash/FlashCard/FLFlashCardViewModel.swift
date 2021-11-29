//
//  FLFlashCardViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 7/7/2564 BE.
//

import UIKit
import Alamofire

protocol BasePagingProtocol {
    var nextPage: Int? { get set }
    var isFirstPage: Bool { get set }
    var isLoadNextPage: Bool { get set }
}

protocol BaseViewProtocol {
    func showLoading()
    func hideLoading()
    
}

class FLFlashCardViewModel: BaseViewModel {
    
    init(flashId: Int? = nil) {
        self.flashId = flashId ?? 6
    }
    func showLoading() {//show loading on window
        let window = UIApplication.shared.window
    }
    
    func hideLoading() {
        
    }
    
    var isFirstPage = true
    var isLoadNextPage = false
    var nextPage: Int?
    
    var stageVC: FLEditorViewController?
    var myFlashCard: LMMaterialPageResult?
    var detail: FLDetailResult?
    var pageList = [FLCardPageResult]()
    var flashCardDetail: FLFlashDetailResult? {
      didSet {
        self.newCard.total = self.flashCardDetail?.total ?? 0
      }
    }
    var pageIndex = 0
    var currentPage: FLCardPageResult?
    var currentPageDetail: FLCardPageDetailResult?
    var newCard = FLNewResult(JSON: ["total" : 0])!
    var flashId = flashFixId
    
    func getQuizContent() -> FlashElement? {
        let current = self.currentPageDetail?.componentList.filter({ (flash) -> Bool in
            return flash.type == .quiz
        })
        return current?.first
    }
    
    func callAPIMyFlashCard(_ method:APIMethod, nextUrl: String? = nil, body:[String: Any]? = nil, param: EndPointParam? = nil, complete: @escaping (_ result: LMMaterialPageResult?) -> ()) {
        let request = FLRequest()
        if let nextUrl = nextUrl {
            request.nextUrl = nextUrl
        }
        request.endPoint = .myContent
        request.apiMethod = method
        request.parameter = body
        request.endPointParam = param
        request.apiType = .json
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: LMMaterialPageResult?, isCache, error) in
            self?.checkResponseBody(responseBody)
            self?.myFlashCard = result
            complete(result)
        }
    }
    
    //callAPINewFlashCard | callAPIFlashDetail
    //deferen endPoint but same Data
    func callAPINewFlashCard(profile: ProfileResult, complete: @escaping (_ result: FLDetailResult?) -> ()) {
        let request = FLRequest()
        request.endPoint = .ugcFlashCard
        request.apiMethod = .post
        request.parameter = self.createJSONNewFlash(profileId: profile.id)
        request.apiType = .json
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLDetailResult?, isCache, error) in
            self?.checkResponseBody(responseBody)
            if let flashIs = result?.id {
                self?.flashId = flashIs
            }
            if let detail = result {
                self?.detail = detail
            }
            complete(result)
        }
    }
    
    func callAPIFlashDetail(_ method:APIMethod ,status: FLStatus? = nil, complete: @escaping (_ result: FLDetailResult?) -> ()) {
        let request = FLRequest()
        request.apiMethod = method
        request.endPoint = .ugcFlashCardDetail
        request.arguments = ["\(self.flashId)"]
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLDetailResult?, isCache, error) in
            self?.checkResponseBody(responseBody)
            if let detail = result {
                self?.detail = detail
            }
            complete(result)
        }
        
        //TODO: param for submit, calcle
        print("callAPIDetail\n\(request.url)")
        /*
        let fileName = "ugc-flash-card-id"
        JSON.read(fileName) { (object) in
            if let json = object as? [String : Any],
               let detail = FLDetailResult(JSON: json) {
                self.detail = detail
            }
            complete()
        }
        */
    }
    
    func callAPIFlashDetailUpdate(parameter: [String: Any]? , complete: @escaping (_ result: FLDetailResult?) -> ()) {
        guard let detail = self.detail else { return }
        let request = FLRequest()
        request.apiMethod = .patch
        request.endPoint = .ugcFlashCardDetail
        request.parameter = parameter
        request.arguments = ["\(detail.id)"]
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLDetailResult?, isCache, error) in
            self?.checkResponseBody(responseBody)
            if let detail = result {
                self?.detail = detail
            }
            complete(result)
        }
    }
    
    func callAPIFlashDetailSubmit(complete: @escaping (_ result: FLDetailResult?) -> ()) {
        guard let detail = self.detail else { return }
        let request = FLRequest()
        request.apiMethod = .post
        request.endPoint = .ugcFlashPostSubmit
        request.arguments = ["\(detail.id)"]
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLDetailResult?, isCache, error) in
            self?.checkResponseBody(responseBody)
            if let detail = result {
                self?.detail = detail
            }
            complete(result)
        }
    }
    
    func callAPIFlashDetailCancel(complete: @escaping (_ result: FLDetailResult?) -> ()) {
        guard let detail = self.detail else { return }
        let request = FLRequest()
        request.apiMethod = .post
        request.endPoint = .ugcFlashPostCancel
        request.arguments = ["\(detail.id)"]
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLDetailResult?, isCache, error) in
            self?.checkResponseBody(responseBody)
            if let detail = result {
                self?.detail = detail
            }
            complete(result)
        }
    }
    
    func callAPIFlashCard(complete: @escaping (_ result: FLFlashDetailResult?) -> ()) {
        let request = FLRequest()
        request.endPoint = .ugcCardList
        request.arguments = ["\(self.flashId)"]
        API.request(request) { [weak self] (responseBody: ResponseBody?, result: FLFlashDetailResult?, isCache, error) in
            self?.checkResponseBody(responseBody)
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
            self?.checkResponseBody(responseBody)
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
            self?.checkResponseBody(responseBody)
            if let page = result {
                self?.currentPageDetail = page
            }
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
            self.checkResponseBody(responseBody)
            complete(result)
        }
    }
    
    var answerPageResult: UserAnswerPageResult?
    
    func callAPICardDetailAnswerDetail(_ currentCard: FLCardPageResult? ,
                                       quiz: FlashElement? = nil,
                                       method: APIMethod = .get,
                                       param:[String: Any]? = nil,
                                       complete: @escaping (_ result: UserAnswerPageResult?) -> ()) {
        
        guard let card = currentCard else { return }
        
        if !self.isFirstPage, self.nextPage == nil {
            //max of items in page
            complete(self.answerPageResult)
        } else {
            let request = FLRequest()
            request.apiMethod = method
            request.parameter = param
            request.endPoint = .ugcCardDetailUserAnswer
            request.arguments = ["\(self.flashId)", "\(card.id)"]
            request.apiType = .json
            
            API.request(request) { (responseBody: ResponseBody?, pageResult: UserAnswerPageResult?, isCache, error) in
                self.checkResponseBody(responseBody)
                if let page = pageResult {
                    self.nextPage = page.next
                    if self.isFirstPage {
                        self.answerPageResult?.userAnswerList = page.userAnswerList
                    } else {
                        for item in page.userAnswerList {
                            self.answerPageResult?.userAnswerList.append(item)
                        }
                    }
                    
                    self.isFirstPage = false
                    
                    complete(pageResult)
                } else {//case show progress 0%
                    //empty choiceList
                    var choiceList = [FLChoiceResult]()
                    if let quiz = quiz, let question = quiz.question  {
                        for choice in question.choiceList {
                            choice.isAnswer = false// hide answer after show fake 0%
                            choice.percent = 0
                            choiceList.append(choice)
                        }
                    }
                    let userAnswerPage = UserAnswerPageResult(JSON: ["name": ""])!
                    userAnswerPage.choiceList = choiceList
                    complete(userAnswerPage)
                }
            }
        }
    }
    
    func createNewQuiz(completion: @escaping (_ q: FlashElement?) -> ()) {
        let fileName = "flash-card-new-quiz"
        JSON.read(fileName) { (object) in
            if let json = object as? [String : Any],
               let question = FlashElement(JSON: json) {
                question.type = .quiz
                completion(question)
            } else {
                completion(nil)
            }
        }
    }
    
    func callAPIDropboxUpload(_ currentCard:FLCardPageResult? ,media: FLMediaResult?, iView: InteractView, mainVC: UIViewController? = nil ,complete: @escaping () -> ()) {
        guard let card = currentCard else { return }
        let boundary: String = UUID().uuidString
        let request = FLRequest()
        request.apiMethod = .post
        request.endPoint = .ugcCardIdDropbox
        request.arguments = ["\(self.flashId)", "\(card.id)"]
        request.apiType = .url
        
        //request.contentType = "multipart/form-data; boundary=----\(boundary)"
        //request.accept =  "application/json"
        
        var fileName = ""
        var fileType = "jpeg"
        if let m = media {
            fileName = m.filename.replacingOccurrences(of: "trim.", with: "")
            fileType = URL(string: fileName)?.pathExtension ?? "mp4"
        }
        
        var videoData: Data?
        if let mp4VideoUrl = media?.mp4VideoUrl {
            do {
                videoData = try Data(contentsOf: mp4VideoUrl, options: Data.ReadingOptions.alwaysMapped)
            } catch _ {
                videoData = nil
                return
            }
        }
        
        var dict = [String: String]()
        if let csrftoken = API.getCookie(name: "csrftoken") {
            dict["X-CSRFToken"] = csrftoken
            if let m = media, let mp4VideoUrl = media?.mp4VideoUrl {
                let fileType = URL(string: m.filename)?.pathExtension ?? "mp4"
                dict["filename"] = fileName
                dict["Content-Type"] = "multipart/form-data"
                dict["Accept"] = "application/json"
            }
        }
        let headers: HTTPHeaders = HTTPHeaders(dict)
        
        ConsoleLog.show("URL:\(request.url)")
        ConsoleLog.show("headers:\(headers)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if let m = media {
                multipartFormData.append(fileName.data(using: .utf8)!, withName: "filename")
                
                if let videoData = videoData {
                    multipartFormData.append(videoData, withName: "file", fileName: fileName, mimeType: "video/\(fileType)")
                    
                } else if let imageData = m.imageData {
                    multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/\(fileType)")
                }
                
            }
        }, to: request.url, method: .post, headers: headers)
        .uploadProgress(queue: .main, closure: { progress in
            let percent = progress.fractionCompleted * 100
            self.stageVC?.showLoading("\(Int(percent))%")
            ConsoleLog.show("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { respond in
            do {
                // make sure this JSON is in the format we expect
                ConsoleLog.show("Upload respond: \(respond)")
                if let data = respond.data {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let media = FLMediaResult(JSON: json) {
                            print("JSON: \(json)")
                            if let file = media.file {
                                //do something after upload video to api
                                iView.element?.src = file
                            } else {
                                iView.element?.src = media.image
                            }
                        }
                        
                        complete()
                    }
                } else {
                    if let mainVC = mainVC {
                        PopupManager.showWarning("\(respond)", at: mainVC)
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
            self.checkResponseBody(responseBody)
            if let page = result {
                
            }
        }
    }
    
    func callApiDeleteList(_ selectList:[Int], apiMethod:APIMethod,completion: @escaping () -> ()) {
        
        self.removeCardView(idList: selectList)
        
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
            self.checkResponseBody(responseBody)
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
            self.checkResponseBody(responseBody)
            self.flashCardDetail = result
            if let listResult = result {
                self.pageList = listResult.list
            }
            completion()
        }
        
    }
    
    func callAPILearningCoverList(complete: @escaping (_ list: [LMCreateItem]?) -> ()) {
        
        let request = FLRequest()
        request.apiMethod = .get
        request.endPoint = .learningContentCoverList
        API.requestForItems(request) { (response: ResponseBody?, list: [LMCreateItem]?, isCache, error) in
            self.checkResponseBody(response)
            complete(list)
        }
    }
    
    func callAPICategoryList(complete: @escaping (_ result: UGCCategoryPageResult?) -> ()) {
        
        let request = FLRequest()
        request.apiMethod = .get
        request.endPoint = .subCategory
        API.request(request) { (response: ResponseBody?, result: UGCCategoryPageResult?, isCache, error) in
            self.checkResponseBody(response)
            complete(result)
        }
        /*
        JSON.read("ugc-flash-card-category") { (object) in
            if let dictList = object as? [[String : Any]],
               let detail = UGCCategoryPageResult(JSON: ["results": dictList]) {
                complete(detail)
            }
        }
        */
    }
    
    private func removeCardView(idList:[Int]) {
        for id in idList {
            let card = self.pageList.first { (pageResult) -> Bool in
                return pageResult.id == id
            }
            if let c = card {
                c.stage?.removeFromSuperview()
            }
        }
        
    }
    
    
    func checkResponseBody(_ response: ResponseBody?) {
        guard let body = response else { return }
        guard let urlResponse = body.urlResponse else { return }
        
        if urlResponse.statusCode > 300, let url = urlResponse.url {
            
            let text = "Error statusCode: \(urlResponse.statusCode) \n \(String(describing: url))"
            PopupManager.showWarning(text)
        }
    }
    
    
}

extension FLFlashCardViewModel {
    func createJSONNewFlash(profileId: Int) -> [String : Any] {
        var param = [String : Any]()
        param["name_content"] = "Untitled"
        param["created_by"] = profileId
        param["code"] = ""
        return param
    }
    
}
