//
//  FlashElement.swift
//  flash
//
//  Created by Songwut Maneefun on 17/6/2564 BE.
//

import UIKit
import ObjectMapper

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
    case justified = "justify"
    //case natural = "natural"
    
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
    var isCreating = false
    //Base
    var media: FLMediaResult?
    var sort: Int?
    var rotation: NSNumber?
    var scale: NSNumber = NSNumber(1.0) //default
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
    var fontSizeFix:CGFloat = 36
    var fontSizeDisplay:CGFloat = 36
    var flAlignment = FLTextAlignment.center
    var flTextStyle:[FLTextStyle] = [FLTextStyle]()//["bold", "italic", "underline"]
    var fontScale:CGFloat = 1.0
    
    //Graphic
    var graphic: FLGraphicResult?
    var code = ""
    
    //image
    var src: String?//image,video.sticker,shape
    var uiimage: UIImage?
    var graphicType: FLGraphicMenu?
    
    //video
    var deviceVideoUrl: URL?
    var mp4VideoUrl: URL?
    var mp4VideoUploade: String?
    
    //Quiz
    var scaleUI: Float = 1.0//default
    var question: FLQuestionResult?
    
    //maybe next
    var fill: String?
    //var stroke = "#000000"
    var strokeWidth:Float?
    
    var font: UIFont?
    
    func width(on stageWidth: CGFloat) -> CGFloat {
        return ((stageWidth * CGFloat(truncating: self.width)) / 100)
    }
    
    func height(on stageHeight: CGFloat) -> CGFloat {
        return ((stageHeight * CGFloat(truncating: self.height)) / 100)
    }
    
    func offsetY(on stageHeight: CGFloat) -> CGFloat {
        return ((stageHeight * CGFloat(truncating: self.y)) / 100)
    }

    func offsetX(on stageWidth: CGFloat) -> CGFloat {
        return (stageWidth * CGFloat(truncating: self.x) / 100)
    }
    
    func updateNewFontSize() {
        let newSize = self.fontSizeFix * self.fontScale
        self.fontSizeDisplay = newSize
    }
    
    func manageFontScale() -> UIFont {
        let isItalic = self.flTextStyle.contains(.italic)
        let size = self.fontSizeFix * self.fontScale
        self.fontSizeDisplay = size
        print("manageFont size: \(size)")
        var font:UIFont = .font(size, .text, isItalic: isItalic)
        if self.flTextStyle.contains(.bold) {
            font = .font(size, .bold, isItalic: isItalic)
        }
        self.font = font
        return font
    }
    
    private func createStyleList() -> [String] {
        var textStyle = [String]()
        for style in flTextStyle {
            textStyle.append(style.rawValue)
        }
        
        return textStyle
    }
    
    func createGraphicJSON() -> [String: AnyObject]? {
        var dict = [String: AnyObject]()
        dict["type"] = self.type.rawValue as AnyObject
        
        if let graphic = self.graphic {
            dict["code"] = graphic.code as AnyObject
            dict["src"] = graphic.image as AnyObject
        } else {
            dict["code"] = self.code as AnyObject
            dict["src"] = self.src as AnyObject
        }
        return dict
    }
    
    func createTextJSON() -> [String: AnyObject]? {
        var dict = [String: AnyObject]()
        dict["text"] = self.text as AnyObject
        dict["text_color"] = self.textColor as AnyObject
        dict["font_size"] = self.fontSizeFix as AnyObject
        dict["text_alignment"] = self.flAlignment.rawValue as AnyObject//["left", center", "right", "justified"]
        dict["text_style"] = self.createStyleList() as AnyObject //["bold", "italic", "underline"]
        return dict
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        sort            <- map["sort"]
        type            <- map["type"]
        height          <- map["height"]
        width           <- map["width"]
        x               <- map["position_x"]
        y               <- map["position_y"]
        rotation        <- map["rotation"]
        scale           <- map["scale"]
        text            <- map["text"]
        textColor       <- map["text_color"]
        fontSizeFix     <- map["font_size"]
        flAlignment     <- map["text_alignment"]
        flTextStyle     <- map["text_style"]
        
        graphicType     <- map["type"]
        src             <- map["src"]
        code            <- map["code"]
        
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




