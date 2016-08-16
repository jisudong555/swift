//
//  UILabel+Category.swift
//  weibo
//
//  Created by jisudong on 16/5/17.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

extension UILabel{
    
    /// 快速创建一个UILabel
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel
    {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
}
