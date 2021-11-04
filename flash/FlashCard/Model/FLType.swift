//
//  FLType.swift
//  LEGO
//
//  Created by Songwut Maneefun on 1/11/2564 BE.
//  Copyright © 2564 BE conicle. All rights reserved.
//

import UIKit

enum FLInteractViewHandler: Int {
    case none
    case close
    case rotate
    case flip
}

enum FLInteractViewPosition {
    case midLeft
    case midRight
    
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

@objc protocol InteractViewDelegate {
    @objc optional func interacViewDidBeginMoving(view: InteractView)
    @objc optional func interacViewDidChangeMoving(view: InteractView)
    @objc optional func interacViewDidEndMoving(view: InteractView)
    @objc optional func interacViewDidBeginRotating(view: InteractView)
    @objc optional func interacViewDidChangeRotating(view: InteractView)
    @objc optional func interacViewDidEndRotating(view: InteractView)
    @objc optional func interacViewDidClose(view: InteractView)
    @objc optional func interacViewDidTap(view: InteractView)
}

enum FLType: String {
    case unknow = ""
    case text = "text"
    case image = "image"
    case video = "video"
    case shape = "shape"
    case sticker = "sticker"
    case quiz = "questionnaire"
}

class FLControlIcon: UIImageView {
    var position: FLInteractViewPosition = .midLeft
}
