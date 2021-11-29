//
//  String.swift
//  flash
//
//  Created by Songwut Maneefun on 5/10/2564 BE.
//

import Foundation

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    mutating func replace(_ originalString:String, with newString:String) {
        self = self.replacingOccurrences(of: originalString, with: newString)
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
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
