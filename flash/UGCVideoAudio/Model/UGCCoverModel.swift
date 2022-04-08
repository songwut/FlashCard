//
//  UGCCoverModel.swift
//  flash
//
//  Created by Songwut Maneefun on 9/3/2565 BE.
//

import SwiftUI
import ObjectMapper

struct UGCCoverModel: Identifiable {
    let uuid = UUID()
    let id : Int?
    var image: String?
    @State var isSelected = false
    @State var uiimage: UIImage?
    
}

class UGCCoverResult: BaseResult, Identifiable {
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}
/*
//UGC change FLDetailResult -> UGCDetailResult
class UGCDetailResult: FLDetailResult {
    var imageVideoList = [UGCCoverResult]()
    var defaultImage = ""
    var fileSize = 0
    var uploadStatus = 0
    
    func fileSizeDisplay() -> String {
        let mb = Units(bytes:Int64(self.fileSize)).megabytes
        let mbStr = String(format:"%02d", mb)
        return "\(mbStr) " + "mb".localized()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        uploadStatus         <- map["upload_status"]
        fileSize             <- map["file_size"]
        imageVideoList       <- map["image_video_list"]
        defaultImage         <- map["default_image"]
    }
}
*/
