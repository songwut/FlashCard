//
//  ColorHelper.swift
//  flash
//
//  Created by Songwut Maneefun on 20/7/2564 BE.
//

import UIKit

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
       return UIColor("00DB85")
    }

    static func error() -> UIColor {
       return UIColor("EB4852")
    }
    
    static func info() -> UIColor {
       return UIColor("1F75FE")
    }
    
    static func noti() -> UIColor {
       return UIColor("FF202A")
    }
    
    
}
