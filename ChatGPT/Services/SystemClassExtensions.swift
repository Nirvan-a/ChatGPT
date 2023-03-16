//
//  Extensions.swift
//  ChatGPT
//
//  Created by nirvana on 3/12/23.
//

import Foundation
import UIKit

extension String {
    func width(withFont font: UIFont) -> CGFloat {
        return size(withFont: font, maximumWidth: .greatestFiniteMagnitude).width
    }
    
    func height(withFont font: UIFont, maximumWidth: CGFloat) -> CGFloat {
        return size(withFont: font, maximumWidth: maximumWidth).height
    }
    
    func size(withFont font: UIFont, maximumWidth: CGFloat) -> CGSize {
        return size(withAttributes: [.font: font], maximumWidth: maximumWidth)
    }
    
    func size(withFont font: UIFont, lineHeight: CGFloat, maximumWidth: CGFloat) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = lineHeight
        return size(withAttributes: [.font: font,
                                     .paragraphStyle: style], maximumWidth: maximumWidth)
    }
    
    func size(withAttributes attributes: [NSAttributedString.Key: Any]?, maximumWidth: CGFloat) -> CGSize {
        return size(withAttributes: attributes, maximumSize: CGSize(width: maximumWidth, height: .greatestFiniteMagnitude))
    }
    
    func size(withAttributes attributes: [NSAttributedString.Key: Any]?, maximumSize: CGSize) -> CGSize {
        let string = NSString(string: self)
        let size = string.boundingRect(
            with: maximumSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        ).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
}

extension String {
    func estimateTokens(method: String = "average") -> Int {
        // method can be "average", "words", "chars", "max", "min", defaults to "max"
        // "average" is the average of words and chars
        // "words" is the word count divided by 0.75
        // "chars" is the char count divided by 4
        // "max" is the max of word and char
        // "min" is the min of word and char
        let wordCount = self.split(separator: " ").count
        let charCount = self.count
        
        let tokensCountWordEst = Double(wordCount) / 0.75
        let tokensCountCharEst = Double(charCount) / 4.0
        
        var output = 0
        
        switch method {
        case "average":
            output = Int((tokensCountWordEst + tokensCountCharEst) / 2)
        case "words":
            output = Int(tokensCountWordEst)
        case "chars":
            output = Int(tokensCountCharEst)
        case "max":
            output = Int(max(tokensCountWordEst, tokensCountCharEst))
        case "min":
            output = Int(min(tokensCountWordEst, tokensCountCharEst))
        default:
            // return invalid method message
            return -1
        }
        return output
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(cgColor: UIColor.gray.cgColor)
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension NSAttributedString {
    
    func height(with maximumWidth: CGFloat) -> CGFloat {
        return ceil(size(with: CGSize(width: maximumWidth, height: CGFloat.greatestFiniteMagnitude)).height)
    }
    
    func width() -> CGFloat {
        let maxWidth = CGFloat.greatestFiniteMagnitude
        return ceil(size(with: CGSize(width: maxWidth, height: maxWidth)).width)
    }
    
    func size(with size: CGSize) -> CGSize {
        guard !string.isEmpty else {
            return .zero
        }
        return boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
    }
    
}
