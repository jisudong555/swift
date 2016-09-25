//
//  EmoticonTextAttachment.swift
//  EmoticonView
//
//  Created by 纪素东 on 16/9/18.
//  Copyright © 2016年 纪素东. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {
    
    var chs: String?
    
    class func imageText(emoticon: Emoticon, font: UIFont) -> NSAttributedString
    {
        let attachment = EmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        let s = font.lineHeight
        attachment.bounds = CGRectMake(0, -4, s, s)
        return NSAttributedString(attachment: attachment)
    }

}
