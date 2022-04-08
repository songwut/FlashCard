//
//  UGCPlayerFullscreenViewModel.swift
//  LEGO
//
//  Created by Songwut Maneefun on 11/3/2565 BE.
//  Copyright © 2565 BE conicle. All rights reserved.
//

import UIKit

struct UGCPlayerFullScreenViewModel {
    var contentCode: ContentCode = .video
    var isNeedStopWhenClose: Bool = true
    var mediaUrl: URL
    var coverImage: String = ""
    var currentTime: Double = 0.0
}


struct UGCPlayerParamModel {
    var durationInt: Int?
    var durationMax: Int?
    var durationDiff: Int?
}
