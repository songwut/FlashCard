//
//  ColorHelper.swift
//  flash
//
//  Created by Songwut Maneefun on 20/7/2564 BE.
//

import UIKit
import SwiftUI

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension Color {
    init(_ hex: String) {
        let uiColor = UIColor(hex)
        self.init(uiColor)
        /*
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
        */
    }
}

extension UIColor {
    
    static func config_primary(_ alpha: CGFloat = 1.0) -> UIColor {
        return primaryColor.withAlphaComponent(alpha)//config-primary-color
    }
    
    static func config_primary_10() -> UIColor {
        return primaryColor.withAlphaComponent(0.1)
    }

    static func config_primary_25() -> UIColor {
       return primaryColor.withAlphaComponent(0.25)
    }

    static func config_primary_50() -> UIColor {
       return primaryColor.withAlphaComponent(0.50)
    }

    static func config_primary_75() -> UIColor {
       return primaryColor.withAlphaComponent(0.75)
    }

    static func config_secondary(_ alpha: CGFloat = 1.0) -> UIColor {
        return secondaryColor.withAlphaComponent(alpha)//config-secondary-color
    }

    static func config_secondary_10() -> UIColor {
       return secondaryColor.withAlphaComponent(0.1)
    }

    static func config_secondary_25() -> UIColor {
       return secondaryColor.withAlphaComponent(0.25)
    }

    static func config_secondary_50() -> UIColor {
       return secondaryColor.withAlphaComponent(0.50)
    }

    static func config_secondary_75() -> UIColor {
       return secondaryColor.withAlphaComponent(0.75)
    }
}

extension UIColor {
    /// The SwiftUI color associated with the receiver.
    var color: Color { Color(self) }
    
    static func background() -> UIColor{
        return UIColor("FBFBFB")
    }
    
    static func elementBackground() -> UIColor{
        return UIColor("2F3542")
    }
    
    static func table() -> UIColor{
        return UIColor("F5F5F5")
    }
    
    static func text(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "525252").withAlphaComponent(alpha)
    }
    
    static func text75(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "7D7D7D").withAlphaComponent(alpha)
    }
    
    static func text50(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "A9A9A9").withAlphaComponent(alpha)
    }
    
    static func text25(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "D3D3D3").withAlphaComponent(alpha)
    }
    
    static func light(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "FFFFFF").withAlphaComponent(alpha)
    }
    
    static func background(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor("FBFBFB").withAlphaComponent(alpha)
    }
    
    static func success() -> UIColor {
       return UIColor("00DB85")
    }
    
    static func warning() -> UIColor {
       return UIColor("FFAD00")
    }

    static func error() -> UIColor {
       return UIColor("EB4852")
    }
    
    static func info() -> UIColor {
       return UIColor("1F75FE")
    }
    
    static func info_10() -> UIColor {
        return info().withAlphaComponent(0.10)
    }
    
    static func info_75() -> UIColor {
        return info().withAlphaComponent(0.75)
    }
    
    static func noti() -> UIColor {
       return UIColor("FF202A")
    }
    
    static func disable() -> UIColor {
       return UIColor("DDDDDD")
    }
    
    static func black() -> UIColor {
       return UIColor( red: (0.0)/255, green: (0.0)/255, blue: (0.0)/255, alpha: (1.00) )
    }
}

extension Color {
    
    static func config_primary(_ alpha: CGFloat = 1.0) -> Color {
        return UIColor.config_primary(alpha).color
    }
    
    static func config_primary10() -> Color {
        return UIColor.config_primary_10().color
    }

    static func config_primary25() -> Color {
        return UIColor.config_primary_25().color
    }

    static func config_primary50() -> Color {
        return UIColor.config_primary_50().color
    }

    static func config_primary75() -> Color {
        return UIColor.config_primary_75().color
    }

    static func config_secondary(_ alpha: CGFloat = 1.0) -> Color {
        return UIColor.config_secondary(alpha).color
    }

    static func config_secondary10() -> Color {
        return UIColor.config_secondary_10().color
    }

    static func config_secondary25() -> Color {
        return UIColor.config_secondary_25().color
    }

    static func config_secondary50() -> Color {
        return UIColor.config_secondary_50().color
    }

    static func config_secondary75() -> Color {
        return UIColor.config_secondary_75().color
    }
    
    static func background() -> Color {
        return UIColor.background().color
    }
    
    static func elementBackground() -> Color {
        return UIColor.elementBackground().color
    }
    
    static func table() -> Color {
        return UIColor.table().color
    }
    
    static func text(_ alpha: CGFloat = 1.0) -> Color {
        return UIColor.text(alpha).color
    }
    
    static func text75(_ alpha: CGFloat = 1.0) -> Color {
        return UIColor.text75().color
    }
    
    static func text50(_ alpha: CGFloat = 1.0) -> Color {
        return UIColor.text50().color
    }
    
    static func text25(_ alpha: CGFloat = 1.0) -> Color {
        return UIColor.text25().color
    }
    
    static func light(_ alpha: CGFloat = 1.0) -> Color {
        return UIColor.light(alpha).color
    }
    
    static func background(_ alpha: CGFloat = 1.0) -> Color {
        return UIColor.background(alpha).color
    }
    
    static func success() -> Color {
        return UIColor.success().color
    }
    
    static func warning() -> Color {
        return UIColor.warning().color
    }

    static func error() -> Color {
        return UIColor.error().color
    }
    
    static func info() -> Color {
        return UIColor.info().color
    }
    
    static func info10() -> Color {
        return UIColor.info_10().color
    }
    
    static func info75() -> Color {
        return UIColor.info_75().color
    }
    
    static func noti() -> Color {
        return UIColor.noti().color
    }
    
    static func disable() -> Color {
        return UIColor.disable().color
    }
}
