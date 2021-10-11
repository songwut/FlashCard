//
//  FontHelper.swift
//  flash 4.11
//
//  Created by Songwut Maneefun on 19/7/2564 BE.
//

import UIKit
import SwiftUI

extension UIFont {
    var font: Font { Font(self) }
}

let fontScale: CGFloat = UIScreen.main.scale * 0.4

enum AppFont: Int {
    case regular = 0
    case italic = 1
    case lightItalic = 2
    
    case text = 3
    case medium = 4
    case bold = 5
    
    func fontName(_ isItalic: Bool = false) -> String {
        var fontName = fontConicleText
        switch self {
        //design system
        case .text: fontName = isItalic ? fontConicleTextIt : fontConicleText
        case .medium: fontName = isItalic ? fontConicleMediumIt : fontConicleMedium
        case .bold: fontName = isItalic ? fontConicleBoldIt : fontConicleBold
            
        case .regular: fontName = isItalic ? fontConicleTextIt : fontConicleText
        case .italic: fontName = fontConicleTextIt
        case .lightItalic: fontName = fontConicleTextIt
        }
        return fontName
    }
}

enum SizeName: CGFloat {
    case largeTitle = 34.0
    case headerSuper = 50.0
    case headerBanner = 28.0
    case headerSpecial = 24.0
    case headerTitle = 22.0
    case header = 20.0
    case title = 18.0
    case normal = 16.0
    case small = 14.0
    case mini = 12.0
    case tiny = 10.0
    case atomic = 8.0
    
}

enum StyleName: CGFloat {
    case hero1 = 96.0
    case hero2 = 88.0
    case hero3 = 72.0
    case hero4 = 56.0
    case hero5 = 48.0

    case heading1 = 40.0
    case heading2 = 32.0
    case heading3 = 28.0
    case heading4 = 24.0
    case heading5 = 22.0
    case heading6 = 18.0
    
    case paragraph = 16.0
    case l = 14.0
    case small = 13.0//= m
    case s = 12.0
    case xs = 10.0
}

struct FontHelper {
    //design system
    static func getFontSystem(_ rawSize: CGFloat, font: AppFont, isItalic: Bool = false) -> UIFont {
        
        return UIFont(name: font.fontName(isItalic), size: rawSize * fontScale)!
    }
    
    static func getFontSystem(_ size: StyleName, font: AppFont, isItalic: Bool = false) -> UIFont {
        return UIFont(name: font.fontName(isItalic), size: size.rawValue * fontScale)!
    }
    
    //before use design system
    static func getFont(_ font: AppFont, size: SizeName) -> UIFont {
        return UIFont(name: font.fontName(), size: size.rawValue * fontScale)!
    }
    
    static func getFont(_ font: AppFont, rawSize: CGFloat) -> UIFont {
        return UIFont(name: font.fontName(), size: rawSize * fontScale)!
    }
}

extension UIFont {
    static func font(_ rawSize: CGFloat, font: AppFont, isItalic: Bool = false) -> UIFont {
        return UIFont(name: font.fontName(isItalic), size: rawSize * fontScale)!
    }
    
    static func font(_ size: StyleName, font: AppFont, isItalic: Bool = false) -> UIFont {
        return UIFont(name: font.fontName(isItalic), size: size.rawValue * fontScale)!
    }
}

extension Font {//SwiftUI
    static func font(_ rawSize: CGFloat, font: AppFont, isItalic: Bool = false) -> Font {
        return UIFont(name: font.fontName(isItalic), size: rawSize * fontScale)!.font
    }
    
    static func font(_ size: StyleName, font: AppFont, isItalic: Bool = false) -> Font {
        return UIFont(name: font.fontName(isItalic), size: size.rawValue * fontScale)!.font
    }
}
