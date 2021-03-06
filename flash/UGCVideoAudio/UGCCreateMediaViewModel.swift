//
//  UGCCreateMediaViewModel.swift
//  flash
//
//  Created by Songwut Maneefun on 3/3/2565 BE.
//

import SwiftUI
import Combine
import Alamofire
import AVFoundation

class UGCCreateMediaViewModel: ObservableObject {
    @Published var detail: UGCDetailResult = MockObject.ugcVideoDetail
    @Published var imageId: Int?
    @Published var mediaUrl: URL?
    @Published var loadingProgress: CGFloat = -1
    @Published var isShowingPreview = false
    @Published var imagePicked: UIImage?
    @Published var isAllowDownload = false
    @Published var isDetailReady = false
    @Published var filePdfContent:Data?
    @Published var isShowDocUpload = false
    
    var playerVM = UGCPlayerViewModel()
    var mId = 0
    var contentCode: ContentCode = .video
    var isCancelUpload: Bool?
    var isComeFromEditPost = false
    var isLoaded = false
    var coverList = [UGCCoverModel]()
    var coverCurrentImage: String = ""
    
    private let apiModel = FLFlashCardViewModel()
    private var chunkFile:UGCUploadChunk?
    private var sendingChunkNumber = 0
    private var sendingChunkMaxNumber = 0
    private let uploadStatusComplete = 3
    
    init(mId: Int?, contentCode: ContentCode?) {
        self.mId = mId ?? 0
        self.contentCode = contentCode ?? .video
    }
    
    func durationTimeText() -> String {
        let cmTime = CMTime(seconds: Double(self.detail.duration), preferredTimescale: 1)
        return cmTime.readableText
    }
    
    func urlMedisPlayer() -> URL? {
        if let url =  self.detail.url,
            let mediaUrl = URL(string: url),
            self.isShowingPreview  {
            
            return mediaUrl
        }
        return nil
    }
    
    func uploadTitle() -> String {
        return String(format: "upload_a_xx".localized(), self.contentCode.name())
    }
    
    func supportTypeText() -> String {
        var typeStr = ".mp4"
        if self.contentCode == .audio {
            typeStr = ".mp3"
        }
        return "accept_only".localized() + " " + typeStr
    }
    
    func isUploadReady() -> Bool {
        if self.detail.uploadStatus == .complete, !self.isShowingPreview, !self.isShowUploading() {
            return true
        }
        return false
    }
    
    func isDisablePost() -> Bool {
        return self.detail.uploadStatus != .complete
    }
    
    func isShowUploading() -> Bool {
        let isUploading = self.loadingProgress >= 0.1 && self.loadingProgress < 100
        if let _ = self.isCancelUpload {
            return false
        } else if self.loadingProgress == -1 {//default
            return false
        } else if isUploading || self.detail.uploadStatus != .complete {
            return true
        }
        return false
    }
    
    func isShowDocPreview() -> Bool {
        if self.isShowUploading() {
            return false
            
        } else if let _ = self.detail.url {
            return true
            
        } else if self.detail.url == nil {
            return false
        }
        return false
    }
    
    func isShowMediaUpload() -> Bool {
        if self.isShowUploading() {
            return true
            
        } else if let _ = self.detail.url {
            return true
            
        } else if self.detail.url == nil {
            return false
        }
        return false
    }
    
    func callAPICreateMaterial() {
        let request = FLRequest()
        request.apiMethod = .post
        request.endPoint = UGCPath.materialCreate(code: self.contentCode)//.ugcVideo
        self.isLoaded = false
        API.request(request) { (response: ResponseBody?, detail: UGCDetailResult?, isCache, error) in
            if let detail = detail {
                self.isLoaded = true
                self.coverCurrentImage = detail.image
                self.coverList = self.createCoverList(detail: detail)
                self.detail = detail
                self.mId = detail.id
                self.isDetailReady = true
            }
        }
    }
    
    func callAPIMaterialDetail() {
        let request = FLRequest()
        request.apiMethod = .get
        request.endPoint = UGCPath.materialDetail(code: self.contentCode)//.ugcVideoDetail
        request.arguments =  ["\(self.mId)"]
        self.isLoaded = false
        API.request(request) { (response: ResponseBody?, detail: UGCDetailResult?, isCache, error) in
            if let detail = detail {
                self.isLoaded = true
                self.coverCurrentImage = detail.image
                self.coverList = self.createCoverList(detail: detail)
                self.detail = detail
                if self.contentCode == .pdf {
                    self.readPdfDataFromDetail()
                }
                self.isDetailReady = true
                self.isAllowDownload = detail.isAllowDownload
            }
        }
    }
    
    func callAPIUpdateCover(uiimage: UIImage? = nil, coverId: Int? = nil) {
        var param: EndPointParam?
        let fieldUGCCover = self.contentCode.fieldUGCCover()
        if let coverId = coverId {
            self.imageId = coverId
            self.imagePicked = nil
            self.isShowingPreview = false
            param = EndPointParam(dict: [fieldUGCCover : coverId])
            
        } else if let imageBase64 = uiimage?.jpegData(compressionQuality: 1)?.base64EncodedString() {
            self.imageId = nil
            self.imagePicked = uiimage
            self.isShowingPreview = false
            param = EndPointParam(dict: ["image" : imageBase64])
        }
        self.isLoaded = false
        let urlMissing = self.detail.url
        let request = FLRequest()
        request.apiMethod = .patch
        request.parameter = param?.dict
        request.endPoint = UGCPath.materialDetail(code: self.contentCode)//.ugcVideoDetail
        request.arguments =  ["\(self.mId)"]
        API.request(request) { (response: ResponseBody?, detail: UGCDetailResult?, isCache, error) in
            if let detail = detail {
                detail.url = urlMissing
                self.isLoaded = true
                self.coverCurrentImage = detail.image
                self.coverList = self.createCoverList(detail: detail)
                self.detail = detail
            }
        }
    }
    
    func createCoverList(detail: UGCDetailResult) -> [UGCCoverModel] {
        self.imageId = nil
        var coverList = [UGCCoverModel]()
        
        let currentCover = detail.image
        
        let coverInList = detail.imageVideoList.first { $0.image == currentCover }
        var uploadItem:UGCCoverModel
        
        if let _ = coverInList {
            uploadItem = UGCCoverModel(id: nil, image: nil, isSelected: false)
            
        } else if currentCover == detail.defaultImage {
            uploadItem = UGCCoverModel(id: nil, image: nil, isSelected: false)
            
        } else {
            uploadItem = UGCCoverModel(id: nil, image: currentCover, isSelected: true)
        }
        coverList.append(uploadItem)
        
        
        var defaultItem:UGCCoverModel
        if currentCover == detail.defaultImage {//id 0 send to api
            defaultItem = UGCCoverModel(id: 0, image: detail.defaultImage, isSelected: true)
        } else {
            //user upload
            defaultItem = UGCCoverModel(id: 0, image: detail.defaultImage, isSelected: false)
        }
        coverList.append(defaultItem)
        
        for itemResult in detail.imageVideoList {
            let itemId = itemResult.id
            if let covetIn = coverInList, covetIn.image == itemResult.image {
                self.imageId = itemId
                //found cover in imageVideoList
                coverList.append(UGCCoverModel(id: itemId, image: itemResult.image, isSelected: true))
            } else {
                coverList.append(UGCCoverModel(id: itemId, image: itemResult.image, isSelected: false))
            }
        }
        
        return coverList
    }
    
    func checkUploadStatus() {
        self.isLoaded = false
        
        let request = FLRequest()
        request.apiMethod = .get
        request.endPoint = UGCPath.materialDetail(code: self.contentCode)
        request.arguments =  ["\(self.mId)"]
        API.request(request) { (response: ResponseBody?, detail: UGCDetailResult?, isCache, error) in
            if let detail = detail {
                if detail.uploadStatus == .complete {
                    self.loadingProgress = 100
                    self.isLoaded = true
                    self.coverCurrentImage = detail.image
                    self.coverList = self.createCoverList(detail: detail)
                    self.detail = detail
                    self.isAllowDownload = detail.isAllowDownload
                    if self.contentCode == .pdf {
                        self.readPdfDataFromDetail()
                        self.isShowDocUpload = true
                    }
                } else {
                    ConsoleLog.show("checkUploadStatus")
                    self.checkUploadStatus()
                }
            }
        }
    }
    
    func sendAllowDownload(_ isAllow: Bool) {
        guard isAllow != self.detail.isAllowDownload else { return }
        
        let request = FLRequest()
        request.apiMethod = .patch
        request.endPoint = UGCPath.materialDetail(code: self.contentCode)
        request.parameter = ["is_allow_download" : isAllow]
        request.arguments =  ["\(self.mId)"]
        API.request(request) { [weak self] (response: ResponseBody?, detail: UGCDetailResult?, isCache, error) in
            guard let self = self, let detail = detail else { return }
            self.isLoaded = true
            self.coverCurrentImage = detail.image
            self.coverList = self.createCoverList(detail: detail)
            self.detail = detail
        }
    }
    
    func readPdfDataFromDetail() {
        guard let urlStr = self.detail.url,
        let mediaUrl = URL(string: urlStr) else { return }
        do {
            self.filePdfContent = try Data(contentsOf: mediaUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func uploadDoc(mediaUrl: URL) {
        if mediaUrl.absoluteString.contains(find: ".pdf") {
            guard let fileContent = self.preparefileContentData(mediaUrl: mediaUrl) else { return }
            self.chunkFile = self.manageChunkFile(fileContent: fileContent)
            self.loadingProgress = 0.1
            self.sendMaterialUploadResume(chunkFile: self.chunkFile!)
        } else {
            self.mediaUrl = nil
            let filename = mediaUrl.lastPathComponent
            let unsupportedtext = "\(filename) " + "upload_invalid_file_type".localized() + " .pdf"
            PopupManager.showWarning(unsupportedtext)
        }
    }
    
    func uploadAudio(mediaUrl: URL) {
        if mediaUrl.absoluteString.contains(find: ".mp3") {
            guard let fileContent = self.preparefileContentData(mediaUrl: mediaUrl) else {
                PopupManager.showWarning("file_unsupport".localized())
                return
            }
            self.chunkFile = self.manageChunkFile(fileContent: fileContent)
            self.loadingProgress = 0.1
            self.sendMaterialUploadResume(chunkFile: self.chunkFile!)
        } else {
            self.mediaUrl = nil
            let filename = mediaUrl.lastPathComponent
            let unsupportedtext = "\(filename) " + "upload_invalid_file_type".localized() + " .mp3"
            PopupManager.showWarning(unsupportedtext)
        }
    }
    
    func uploadVideo(mediaUrl: URL) {
        self.loadingProgress = 0.1
        self.mp4Convert(deviceVideoUrl: mediaUrl) { [weak self] (mp4Url) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let asset = AVURLAsset(url: mp4Url)
                let size = asset.tracks(withMediaType: .video)[0].naturalSize
                print("asset.preferredTransform: \(asset.preferredTransform)")
                print("asset size: \(size)")
                
                guard let fileContent = self.preparefileContentData(mediaUrl: mp4Url) else { return }
                self.chunkFile = self.manageChunkFile(fileContent: fileContent)
                self.sendMaterialUploadResume(chunkFile: self.chunkFile)
            }
        }
    }
    
    private func isUseImportFile() -> Bool {
        switch self.contentCode {
        case .audio , .pdf :
            return true
        default://video import from photos
            return false
        }
    }
    
    private func preparefileContentData(mediaUrl: URL) -> Data? {
        var fileContent:Data?
        do {
            if self.isUseImportFile() {
                //case import files app
                guard mediaUrl.startAccessingSecurityScopedResource() else { return nil }
                fileContent = try Data(contentsOf: mediaUrl)
                do { mediaUrl.stopAccessingSecurityScopedResource() }
                
            } else {
                //case import from photos video import from photos app
                fileContent = try Data(contentsOf: mediaUrl)
            }
        } catch {
            print(error.localizedDescription)
        }
        return fileContent
    }
    
    private func manageChunkFile(fileContent: Data) -> UGCUploadChunk? {
        guard let mediaUrl = self.mediaUrl else { return nil }
        let chunkSize = 1024 * 1000
        let data = fileContent
        let dataLen = data.count
        
        let fullChunks = Int(dataLen / chunkSize)
        let totalChunks = fullChunks + (dataLen % 1024 != 0 ? 1 : 0)
        
        var numbers:[Int] = [Int]()
        var chunks:[Data] = [Data]()
        for chunkCounter in 0..<totalChunks {
            var chunk:Data
            let chunkBase = chunkCounter * chunkSize
            var diff = chunkSize
            if(chunkCounter == totalChunks - 1) {
              diff = dataLen - chunkBase
            }
            let range:Range<Data.Index> = chunkBase..<(chunkBase + diff)
            chunk = data.subdata(in: range)
            let number = chunkCounter + 1
            print("chunk number \(number) size is \(chunk.count)")
            print("chunk all done ")
            numbers.append(number)
            chunks.append(chunk)
        }
        
        let upload = UGCUploadChunk(
            mediaUrl: mediaUrl,
            fileSize: dataLen,
            chunkSize: chunkSize,
            fullChunks: fullChunks,
            totalChunks: totalChunks,
            numberList: numbers,
            chunkList: chunks
        )
        return upload
    }
    
    private func sendMaterialUploadResume(chunkFile: UGCUploadChunk?) {
        guard let chunk = chunkFile else { return }
        self.sendingChunkMaxNumber = chunk.chunkList.count
        self.sendingChunkNumber = 1
        ConsoleLog.show("Upload order: ++++++++")
        ConsoleLog.show("Upload: \(self.sendingChunkNumber)/\(self.sendingChunkMaxNumber)")
        
        let request = FLRequest()
        request.apiMethod = .post
        request.endPoint = UGCPath.materialUploadResume(code: self.contentCode)
        request.arguments = ["\(self.mId)"]
        
        //upload Chunk in loop lib no progress need to mock it
        self.loadingProgress = 0.2
        self.loopSendResumeChunk(request: request)
    }
    
    private func loopSendResumeChunk(request: FLRequest) {
        if let _ = self.isCancelUpload {
            self.loadingProgress = -1
            self.chunkFile = nil
            self.mediaUrl = nil
            self.isCancelUpload = nil
            return
        }
        
        guard let chunkFile = self.chunkFile else { return }
        
        let chunkIndex = self.sendingChunkNumber - 1
        
        let headers = request.headers
        let fileName = chunkFile.mediaUrl.lastPathComponent.replace("trim.", withString: "")
        let fileSize = chunkFile.fileSize
        let fileNameId = "\(fileSize)-\(fileName)"
        let materialIdField = self.contentCode.materialIdField()
        let resumableType = self.contentCode.resumableType()
        
        let chunkNumber = self.sendingChunkNumber
        let currentChunk = chunkFile.chunkList[chunkIndex]
        let currentSize = currentChunk.count
        
        var formData = [String: String]()
        formData[materialIdField] = "\(self.mId)"
        formData["resumableChunkNumber"] = "\(chunkNumber)"
        formData["resumableChunkSize"] = "\(chunkFile.chunkSize)"
        formData["resumableCurrentChunkSize"] = "\(currentSize)"
        formData["resumableTotalSize"] = "\(fileSize)"
        formData["resumableType"] = "\(resumableType)"
        formData["resumableIdentifier"] = "\(fileNameId)"
        formData["resumableFilename"] = fileName
        formData["resumableRelativePath"] = fileName
        formData["resumableTotalChunks"] = "\(self.sendingChunkMaxNumber)"
        
        ConsoleLog.show("start Upload order: \(formData)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(currentChunk, withName: "file", fileName: fileName, mimeType: resumableType)
            for (key, value) in formData {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            
        }, to: request.url, method: .post, headers: HTTPHeaders(headers!))
        .responseJSON(completionHandler: { response in
            guard let apiResponse = response.response else { return }
            ConsoleLog.show("response: \(apiResponse.statusCode)")
            ConsoleLog.show("sendingChunkNumber: \(self.sendingChunkNumber)")
            ConsoleLog.show("chunkList count: \(chunkFile.chunkList.count)")
            if apiResponse.statusCode == 200,
                self.sendingChunkNumber < chunkFile.chunkList.count {
                
                //trick for resume upload progress
                let progress = CGFloat(self.sendingChunkNumber.cgFloat / chunkFile.chunkList.count.cgFloat)
                let percent = CGFloat(progress * 100)
                print("index \(chunkIndex) Uploaded progress: \(progress)")
                self.loadingProgress = percent
                
                self.sendingChunkNumber += 1
                self.loopSendResumeChunk(request: request)
                
            } else if let responseData = response.data {
                ConsoleLog.show("all Chunk sended")
                ConsoleLog.show("loadingProgress: \(self.loadingProgress)")
                ConsoleLog.show("responseData: \(responseData)")
                self.manageResponseData(request: request,
                                        responseData: responseData)
            }
        })
    }
    
    private func manageResponseData(request: FLRequest, responseData: Data?) {
        guard let data = responseData else { return }
        ConsoleLog.show("manageResponseData: \(String(decoding: data, as: UTF8.self))")
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] {
                guard let uuid = json["uuid"] as? String else { return }
                guard let chunkFile = self.chunkFile  else { return }
                ConsoleLog.show("uuid: \(uuid)")
                if chunkFile.chunkList.count == self.sendingChunkMaxNumber {
                    self.chunkFile = nil
                    self.mediaUrl = nil
                    self.checkUploadStatus()
                }
            }
        } catch {
            ConsoleLog.show("manageResponseData error: \(error)")
        }
    }
    
    private func mp4Convert(deviceVideoUrl: URL,  complete: @escaping (URL) -> Void) {
        if deviceVideoUrl.absoluteString.contains(find: ".mp4") {
            complete(deviceVideoUrl)
        } else {
            let videoCletertor = VideoConvertor(videoURL: deviceVideoUrl)
            videoCletertor.encodeVideo { (progress) in
                DispatchQueue.main.async {
                    ConsoleLog.show("mp4Convert progress: \(progress)")
                }
            } completion: { (url, error) in
                if let e = error {
                    ConsoleLog.show("error: \(e)")
                } else if let urlMP4 = url {
                    ConsoleLog.show("encodeVideo:\(urlMP4.absoluteString)")
                    complete(urlMP4)
                }
            }
        }
    }
}

