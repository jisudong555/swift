//
//  UIBarButtonItem+Extension.swift
//  weibo
//
//  Created by jisudong on 16/4/13.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    class func createBarButtonItem(imageName: String, target: AnyObject?, action: Selector) -> UIBarButtonItem
    {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
    }
    
    convenience init(imageName: String, target: AnyObject?, action: String?) {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        if let action = action
        {
            button.addTarget(target, action: NSSelectorFromString(action), forControlEvents: UIControlEvents.TouchUpInside)
        }
        button.sizeToFit()
        self.init(customView: button)
    }
}