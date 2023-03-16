//
//  AutoExpendTextView.swift
//  ChatGPT
//
//  Created by nirvana on 3/5/23.
//
import UIKit

class AutoExpendTextView: UITextView {
    var maxHeight: CGFloat = 0
    var minHeight: CGFloat = 0
    
    override var contentSize: CGSize {
        get {
            super.contentSize
        }
        set {
            invalidateIntrinsicContentSize()
            super.contentSize = newValue
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if contentSize.height <= minHeight {
            return CGSize(width: contentSize.width, height: minHeight)
        }
        if contentSize.height >= maxHeight {
            return CGSize(width: contentSize.width, height: maxHeight)
        }
        return contentSize
    }
}
