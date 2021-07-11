//
//  UIColor.swift
//  flash
//
//  Created by Songwut Maneefun on 3/7/2564 BE.
//

import UIKit

var primaryColor: UIColor = UIColor("E7000A")
var secondaryColor: UIColor = UIColor("E7000A")

extension UIColor {
    
    class func light() -> UIColor {
        return .white
    }
    
    class func disable() -> UIColor {
        return UIColor("DDDDDD")
    }
    
    class func background() -> UIColor{
        return UIColor("FBFBFB")
    }
    
    class func elementBackground() -> UIColor{
        return UIColor("2F3542")
    }
    
    class func table() -> UIColor{
        return UIColor("F5F5F5")
    }
    
    class func text(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "525252").withAlphaComponent(alpha)//config-primary-color
    }
    
    class func text75(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "7D7D7D").withAlphaComponent(alpha)//config-primary-color
    }
    
    class func text50(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "A9A9A9").withAlphaComponent(alpha)//config-primary-color
    }
    
    class func text25(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "D3D3D3").withAlphaComponent(alpha)//config-primary-color
    }
    
    class func light(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor( "FFFFFF").withAlphaComponent(alpha)//config-primary-color
    }
    
    class func background(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor("FBFBFB").withAlphaComponent(alpha)
    }
    
    class func primary(_ alpha: CGFloat = 1.0) -> UIColor {
        return primaryColor.withAlphaComponent(alpha)//config-primary-color
    }
    
    class func primary_10() -> UIColor {
        return primaryColor.withAlphaComponent(0.1)
    }

    class func primary_25() -> UIColor {
       return primaryColor.withAlphaComponent(0.25)
    }

    class func primary_50() -> UIColor {
       return primaryColor.withAlphaComponent(0.50)
    }

    class func primary_75() -> UIColor {
       return primaryColor.withAlphaComponent(0.75)
    }

    class func secondary(_ alpha: CGFloat = 1.0) -> UIColor {
        return secondaryColor.withAlphaComponent(alpha)//config-secondary-color
    }

    class func secondary_10() -> UIColor {
       return secondaryColor.withAlphaComponent(0.1)
    }

    class func secondary_25() -> UIColor {
       return secondaryColor.withAlphaComponent(0.25)
    }

    class func secondary_50() -> UIColor {
       return secondaryColor.withAlphaComponent(0.50)
    }

    class func secondary_75() -> UIColor {
       return secondaryColor.withAlphaComponent(0.75)
    }
    
    class func black() -> UIColor {
       return UIColor( red: (0.0)/255, green: (0.0)/255, blue: (0.0)/255, alpha: (1.00) );
    }

    class func error() -> UIColor {
       return UIColor( red: (249.0)/255, green: (50.0)/255, blue: (12.0)/255, alpha: (1.00) );
    }

    class func info() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (1.00) );
    }

    class func info_10() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (0.10) );
    }

    class func info_25() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (0.25) );
    }

    class func info_50() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (0.50) );
    }

    class func info_75() -> UIColor {
       return UIColor( red: (33.0)/255, green: (150.0)/255, blue: (243.0)/255, alpha: (0.75) );
    }

    class func success() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (1.00) );
    }

    class func success_10() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (0.10) );
    }

    class func success_50() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (0.50) );
    }

    class func success_75() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (0.75) );
    }

    class func suceess_25() -> UIColor {
       return UIColor( red: (0.0)/255, green: (150.0)/255, blue: (136.0)/255, alpha: (0.25) );
    }

    class func warning() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (1.00) );
    }

    class func warning_10() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (0.10) );
    }

    class func warning_25() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (0.25) );
    }

    class func warning_50() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (0.50) );
    }

    class func warning_75() -> UIColor {
       return UIColor( red: (255.0)/255, green: (152.0)/255, blue: (0.0)/255, alpha: (0.75) );
    }

}
