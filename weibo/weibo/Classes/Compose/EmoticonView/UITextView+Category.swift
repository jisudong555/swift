//
//  UITextView+Category.swift
//  EmoticonView
//
//  Created by 纪素东 on 16/9/18.
//  Copyright © 2016年 纪素东. All rights reserved.
//

import UIKit

extension UITextView {
    
    func insertEmoticon(emoticon: Emoticon)
    {
        if emoticon.isRemoveButton
        {
            deleteBackward()
        }
        
        if emoticon.emojiStr != nil
        {
            self.replaceRange(self.selectedTextRange!, withText: emoticon.emojiStr!)
        }
        
        if emoticon.png != nil
        {
            let imageText = EmoticonTextAttachment.imageText(emoticon, font: font!)
            let strM = NSMutableAttributedString(attributedString: self.attributedText)
            let range = self.selectedRange
            strM.replaceCharactersInRange(range, withAttributedString: imageText)
            // 属性字符串有自己默认的尺寸
            strM.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(range.location, 1))
            self.attributedText = strM
            self.selectedRange = NSMakeRange(range.location + 1, 0)
        }
    }
    
    func emoticonAttributedText() -> String
    {
        var strM =  String()
        attributedText.enumerateAttributesInRange(NSMakeRange(0, attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (objc, range, _) in
            if objc["NSAttachment"] != nil
            {
                let attachment = objc["NSAttachment"] as! EmoticonTextAttachment
                strM += attachment.chs!
            }
            else
            {
                strM += (self.text as NSString).substringWithRange(range)
            }
        }
        
        return strM
    }
}
