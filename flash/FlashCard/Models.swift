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

public struct Action {
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
    var textColor = "000000"
    var fontSize:CGFloat = 36
    var flAlignment = FLTextAlignment.center
    var flTextStyle:[FLTextStyle] = [FLTextStyle]()//["bold", "italic", "underline"]
    var fontScale:CGFloat = 1.0
    
    func updateNewFontSize() {
        let newSize = self.fontSize * self.fontScale
        self.fontSize = newSize
    }
    
    func manageFont(scale: CGFloat = 1.0) -> UIFont {
        self.fontScale = scale
        let isItalic = self.flTextStyle.contains(.italic)
        let size = self.fontSize * self.fontScale
        print("manageFont size: \(size)")
        var font:UIFont = .getFontSystem(size, font: .text, isItalic: isItalic)
        if self.flTextStyle.contains(.bold) {
            font = .getFontSystem(size, font: .bold, isItalic: isItalic)
        }
        return font
    }
    
    private func createStyleList() -> [String] {
        var textStyle = [String]()
        for style in flTextStyle {
            textStyle.append(style.rawValue)
        }
        
        return textStyle
    }
    
    func createTextJSON() -> [String: AnyObject]? {
        var dict = [String: AnyObject]()
        dict["text"] = self.text as AnyObject
        dict["textColor"] = self.textColor as AnyObject
        dict["font_size"] = self.fontSize as AnyObject
        dict["text_alignment"] = self.flAlignment.rawValue as AnyObject//"left" center" "right" "justified"
        dict["text_style"] = self.createStyleList() as AnyObject
        return dict
    }
    
    //image
    var src: String?//image,video.sticker,shape
    var imageUploaded: String?
    var uiimage: UIImage?
    var graphicType: FLGraphicMenu?
    
    //video
    var deviceVideoUrl: URL?
    var mp4VideoUrl: URL?
    var mp4VideoUploade: String?
    
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




