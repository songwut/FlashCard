//
//  Utility.swift
//  flash
//
//  Created by Songwut Maneefun on 22/7/2564 BE.
//

import UIKit

public class Utility {
    class func  attributedText(with icon: UIImage,iconColor:UIColor? = nil, text: String, titleFont:UIFont? = nil) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: " \(text)")
        
        let iconAttachment = NSTextAttachment()
        iconAttachment.image = icon
        
        
        
        if let titleFont = titleFont {
            iconAttachment.bounds = CGRect(x: 0, y: (titleFont.capHeight - icon.size.height).rounded() / 2, width: icon.size.width, height: icon.size.height)
        }
        iconAttachment.image = icon
        
        
        let attachmentString = NSAttributedString(attachment: iconAttachment)
        let attrStringWithImage = NSMutableAttributedString(attributedString: attachmentString)
        if let c = iconColor {
            let style: [NSAttributedString.Key: Any] = [.foregroundColor: c]
            let range = NSMakeRange(0, attrStringWithImage.length)
            attrStringWithImage.addAttributes(style, range: range)
        }
        
        
        attrStringWithImage.append(attributedString)
        return attrStringWithImage
    }
    
    class func  attributedText(with string: String, font: UIFont) -> NSMutableAttributedString {
        let atbString = NSMutableAttributedString(string: string, attributes:[.font: font])
        return atbString
    }
    
    class func  attributedText(with string: String, font: UIFont, color: UIColor, paragraph:NSMutableParagraphStyle? = nil) -> NSMutableAttributedString {
        let atbString: NSMutableAttributedString?
        
        if let p = paragraph {
            let attributes: [NSAttributedString.Key: Any] = [ .font: font, .foregroundColor: color, .paragraphStyle: p]
            atbString = NSMutableAttributedString(string: string, attributes:attributes)
        } else {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = Localized.shared.lineSpacing()
            atbString = NSMutableAttributedString(string: string, attributes:[.font: font, .foregroundColor:color, .paragraphStyle: paragraph])
        }
        return atbString ?? NSMutableAttributedString(string: string, attributes:[.font: font, .foregroundColor:color])
    }
}
