//
//  ColorHelper.swift
//  flash
//
//  Created by Songwut Maneefun on 20/7/2564 BE.
//

import UIKit
import SwiftUI

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
    
    static func info75() -> UIColor {
        return info().withAlphaComponent(0.75)
    }
    
    static func noti() -> UIColor {
       return UIColor("FF202A")
    }
}

extension UIColor {
    struct colorApi {
        static func primary(_ alpha: CGFloat = 1.0) -> UIColor {
            return primaryColor.withAlphaComponent(alpha)//config-primary-color
        }
        
        static func primary10() -> UIColor {
            return primaryColor.withAlphaComponent(0.1)
        }

        static func primary25() -> UIColor {
           return primaryColor.withAlphaComponent(0.25)
        }

        static func primary50() -> UIColor {
           return primaryColor.withAlphaComponent(0.50)
        }

        static func primary75() -> UIColor {
           return primaryColor.withAlphaComponent(0.75)
        }

        static func secondary(_ alpha: CGFloat = 1.0) -> UIColor {
            return secondaryColor.withAlphaComponent(alpha)//config-secondary-color
        }

        static func secondary10() -> UIColor {
           return secondaryColor.withAlphaComponent(0.1)
        }

        static func secondary25() -> UIColor {
           return secondaryColor.withAlphaComponent(0.25)
        }

        static func secondary50() -> UIColor {
           return secondaryColor.withAlphaComponent(0.50)
        }

        static func secondary75() -> UIColor {
           return secondaryColor.withAlphaComponent(0.75)
        }
    }
}

extension Color {
    init(_ hex: String) {
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
    }
    
    
    
    func system(_ systemColor: SystemColor) -> UIColor {
        return systemColor.color()
    }
}

enum SystemColor {
    case black
    case light
    case disable
    case background
    case elementBackground
        
    func color() -> UIColor {
        switch self {
        case .black:
            return .black
        default:
            return .black
        }
    }
    
    
    
    
}

struct ColorHelper {
    
    static func black() -> UIColor {
        return .black
    }
    
    static func light() -> UIColor {
        return .white
    }
    
    static func disable() -> UIColor {
        return UIColor("DDDDDD")
    }
    
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
        return UIColor( "525252").withAlphaComponent(alpha)//config-primary-color
    }
    
    static func text75(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "7D7D7D").withAlphaComponent(alpha)//config-primary-color
    }
    
    static func text50(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "A9A9A9").withAlphaComponent(alpha)//config-primary-color
    }
    
    static func text25(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "D3D3D3").withAlphaComponent(alpha)//config-primary-color
    }
    
    static func light(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "FFFFFF").withAlphaComponent(alpha)//config-primary-color
    }
    
    static func background(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor("FBFBFB").withAlphaComponent(alpha)
    }
    
    static func primary(_ alpha: CGFloat = 1.0) -> UIColor {
        return primaryColor.withAlphaComponent(alpha)//config-primary-color
    }
    
    static func primary10() -> UIColor {
        return primaryColor.withAlphaComponent(0.1)
    }

    static func primary25() -> UIColor {
       return primaryColor.withAlphaComponent(0.25)
    }

    static func primary50() -> UIColor {
       return primaryColor.withAlphaComponent(0.50)
    }

    static func primary75() -> UIColor {
       return primaryColor.withAlphaComponent(0.75)
    }

    static func secondary(_ alpha: CGFloat = 1.0) -> UIColor {
        return secondaryColor.withAlphaComponent(alpha)//config-secondary-color
    }

    static func secondary10() -> UIColor {
       return secondaryColor.withAlphaComponent(0.1)
    }

    static func secondary25() -> UIColor {
       return secondaryColor.withAlphaComponent(0.25)
    }

    static func secondary50() -> UIColor {
       return secondaryColor.withAlphaComponent(0.50)
    }

    static func secondary75() -> UIColor {
       return secondaryColor.withAlphaComponent(0.75)
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
    
    static func info75() -> UIColor {
        return info().withAlphaComponent(0.75)
    }
    
    static func noti() -> UIColor {
       return UIColor("FF202A")
    }
    
    
}
