//
//  FlashStyle.swift
//  flash
//
//  Created by Songwut Maneefun on 5/7/2564 BE.
//

import UIKit

enum FLTool: String {
    case menu = "menu"
    case background = "background"
    case media = "media"
    case text = "text"
    case graphic = "graphic"
    case quiz = "quiz"
    
    func title() -> String {
        switch self {
        case .menu:
            return "Add / Edit"
        case .background:
            return "Background Color"
        case .media:
            return "Media"//case custom image/video picker
        case .text:
            return "Text"
        case .quiz:
            return "Quiz"
        case .graphic:
            return "Graphic"
        }
    }
    
    func name() -> String {
        //TODO localized
        return self.rawValue
    }
    
    func iconName() -> String {
        return "ic_" + self.rawValue
    }
}

enum FLTextMenu: String {
    case keyboard = "keyboard"
    case style = "style"
    case color = "color"
}

struct FlashStyle {
    static let isIpad = UIDevice.isIpad()
    static let stageColor:UIColor = .gray
    static let screenColor:UIColor = .white
    
    static let deletePageWidth:CGFloat = UIDevice.isIpad() ? 72 : 32
    static let addPageWidth:CGFloat = UIDevice.isIpad() ? 70 : 32
    
    static let baseStageWidth:CGFloat = 325
    static let baseWidth:CGFloat = 375
    static let baseHeight:CGFloat = 600
    
    static let pageCardWidthRatio: CGFloat = UIDevice.isIpad() ?  575 / 1024 : 325.0 / 375
    static let pageCardRatio: CGFloat = 485 / 325
    
    static let bottonToolColor: UIColor = ColorHelper.primary()
    static let iconEedge: CGFloat = 0.3//
    static let bottonToolWidth: CGFloat = UIDevice.isIpad() ? 70 : 54
    static let toolMargin: CGFloat = 18 / 54
    static let contentToolHeight: CGFloat = UIDevice.isIpad() ? 260 : 200
    
    static let toolList: [FLTool] = [.background, .media, .text, .graphic, .quiz]
    
    struct stage {
        static let cellSpacing: CGFloat = UIDevice.isIpad() ? 56 : 16
    }
    
    //color picker
    struct color {
        static let column: CGFloat = UIDevice.isIpad() ? 10 : 7
        static let spaceing: CGFloat = UIDevice.isIpad() ? 16 : 8
        static let marginHor: CGFloat = UIDevice.isIpad() ? 38 : 180
        static let marginVer: CGFloat = UIDevice.isIpad() ? 38 : 0
        
    }
    
    struct text {
        static let placeholder = "Please\nInput Text\nHere"
        static let textWidthFromFont36:CGFloat = 120
        static let marginIView: CGFloat = 40//left+right,top+botton
    }
    
}
