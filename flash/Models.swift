//
//  Models.swift
//  flash
//
//  Created by Songwut Maneefun on 17/6/2564 BE.
//

import UIKit
import SVGKit

open class DidAction {
    var handler: ((_ sender: Any?) -> Void)!
    
    init(handler: @escaping ((_ sender: Any?) -> Void)) {
        self.handler = handler
    }
 
    
}

class FLButton: UIButton {
    var tool: FLTool = .text
    var alignment: FLTextAlignment = .center
    var textStyle: FLTextStyle?
    var actionMenu: FLMenuList = .select
}

class FLStageView: UIView {
    var page: FlashPageResult? {
        didSet {
            print("FLStageView frame: \(self.frame)")
        }
    }
}

enum FLTextStyle: String {
    case regular = "regular"
    case bold = "bold"
    case italic = "italic"
    case underline = "underline"
    
    func iconName() -> String {
        switch self {
        case .bold:
            return "ic_text_bold"
        case .italic:
            return "ic_text_Italic"
        case .underline:
            return "ic_text_underline"
        default:
            return ""
        }
    }
    
    //UIFont.w
}

enum FLTextAlignment: String {
    case left = "left"
    case center = "center"
    case right = "right"
    case justified = "justified"
    case natural = "natural"
    
    func alignment() -> NSTextAlignment {
        switch self {
        case .left:
            return .left
        case .center:
            return .center
        case .right:
            return .right
        case .justified:
            return .justified
        default:
            return .center
        }
    }
    
    func iconName() -> String {
        switch self {
        case .left:
            return "ic_text_left"
        case .center:
            return "ic_text_center"
        case .right:
            return "ic_text_right"
        case .justified:
            return "ic_text_justified"
        default:
            return ""
        }
    }
}

class FlashElement {
    var rotation: Float?
    var scale: Float = 1.0//default
    var tool: FLTool?
    var rawSize: CGSize?
}

class TextElement: FlashElement {
    
    var text = ""
    var textColor = "#000000"
    var fill:String?
    var x:CGFloat = 50
    var y:CGFloat = 50
    var fontSize:CGFloat = 36
    var width:CGFloat = 0
    var flAlignment = FLTextAlignment.center
    var flTextStyle:[FLTextStyle] = [FLTextStyle]()//["bold", "italic", "underline"]
    
    var widthPT:CGFloat?
    
    override init() {
        super.init()
        self.tool = .text
        //self.rotation = 1.69
    }
}

class ImageElement: FlashElement {
    var src: String?
    var textColor = "#005733"
    var fill:String?
    var x:CGFloat = 60
    var y:CGFloat = 10
    var width:CGFloat = 30
    var height:CGFloat = 20
    
    var image: UIImage?
    
    var graphicType: FLGraphicMenu?
    
    override init() {
        super.init()
    }
}

class VectorElement: FlashElement {
    var src = "https://openclipart.org/download/181651/manhammock.svg"
    var textColor = "#005733"
    var fill = "#8888EE"
    var x:CGFloat = 70
    var y:CGFloat = 70
    var width:CGFloat = 40
    var height:CGFloat = 20
    
    override init() {
        
    }
}

class VideoElement: FlashElement {
    //https://test-videos.co.uk/bigbuckbunny/mp4-h264
    var src = "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4"
    var textColor = "#005733"
    var fill = "#8888EE"
    var x:CGFloat = 50
    var y:CGFloat = 80
    var width:CGFloat = 80
    var height:CGFloat = 30
    var deviceUrl: URL?
    
    override init() {
        
    }
}

class ArrowElement: FlashElement {
    var textColor = "#005733"
    var stroke = "#000000"
    var strokeWidth:Float = 1
    var fill = "#8888EE"
    var x:CGFloat = 2
    var y:CGFloat = 50
    var width:CGFloat = 80
    var height:CGFloat = 2
    
    override init() {
        
    }
}
