//
//  UGCUploadChunk.swift
//  LEGO
//
//  Created by Songwut Maneefun on 29/3/2565 BE.
//  Copyright © 2565 BE conicle. All rights reserved.
//

import Foundation

struct UGCUploadChunk {
    let mediaUrl: URL
    let fileSize: Int
    let chunkSize: Int
    let fullChunks: Int
    let totalChunks: Int
    var numberList: [Int]
    var chunkList: [Data]
}

enum UploadChunkStatus: Int {//UGC 4.12 use only 3
    case none = 0
    case complete = 3
}
