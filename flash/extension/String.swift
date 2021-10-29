//
//  String.swift
//  flash
//
//  Created by Songwut Maneefun on 5/10/2564 BE.
//

import Foundation

extension String {
    
    func size(font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func size(font: UIFont, maxWidth: CGFloat, maxHeight: CGFloat) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]

        let attributedText = NSAttributedString(string: self, attributes: attributes)

        let constraintBox = CGSize(width: maxWidth, height: maxHeight)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral

        let textHeight = rect.size.height.rounded(.up)
        let textWidth = rect.size.width.rounded(.up)
        return CGSize(width: textWidth, height: textHeight)
    }
    
    func dateTimeAgo() -> String {
        let dateStr = formatter.with(dateFormat: "d MMM yyyy, HH:mm", dateString: self)
        if let date = formatter.dateWith(dateString: self) {
            return date.getTimeAgoSinceNow(dateText: dateStr)
        }
        return dateStr
    }
}
