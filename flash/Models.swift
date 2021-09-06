//
//  Models.swift
//  flash
//
//  Created by Songwut Maneefun on 17/6/2564 BE.
//

import UIKit
import SVGKit
import ObjectMapper

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

class FlashElement: FLBaseResult {
    //Base
    var rotation: Float?
    var scale: Float = 1.0//default
    var tool: FLTool?
    var x:NSNumber = 0
    var y:NSNumber = 0
    var width:NSNumber = 0
    var height:NSNumber = 0
    var type:FLType = .unknow
    var rawSize: CGSize?
    
    //text
    var text = ""
    var textColor = "#000000"
    var fontSize:CGFloat = 36
    var flAlignment = FLTextAlignment.center
    var flTextStyle:[FLTextStyle] = [FLTextStyle]()//["bold", "italic", "underline"]
    
    //image
    var src: String?//image,video.sticker,shape
    var uiimage: UIImage?
    var graphicType: FLGraphicMenu?
    
    //video
    var deviceUrl: URL?
    
    //Quiz
    var question: FLQuestionResult?
    
    //maybe next
    var fill: String?
    //var stroke = "#000000"
    var strokeWidth:Float?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        //scale           <- map["scale"] not confirm
        type            <- map["type"]
        height          <- map["height"]
        width           <- map["width"]
        x               <- map["position_x"]
        y               <- map["position_y"]
        rotation        <- map["rotation"]
        
        text            <- map["text"]
        textColor       <- map["text_color"]
        fontSize        <- map["font_size"]
        flAlignment     <- map["text_alignment"]
        flTextStyle     <- map["text_style"]
        
        graphicType     <- map["type"]
        src             <- map["src"]
        
        question        <- map["detail"]
        
        fill            <- map["fill"]
        
        if self.type == .text {
            self.tool = .text
        }
    }
    
    class func with(_ dict: [String : Any]) -> FlashElement? {
        let item = Mapper<FlashElement>().map(JSON: dict)
        return item
    }
}
//test element
//https://test-videos.co.uk/bigbuckbunny/mp4-h264
//var src = "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4"
//var deviceUrl: URL?
//var src = "https://openclipart.org/download/181651/manhammock.svg"




