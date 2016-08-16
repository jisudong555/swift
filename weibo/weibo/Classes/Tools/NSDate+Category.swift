//
//  NSDate+Category.swift
//  weibo
//
//  Created by jisudong on 16/5/17.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

extension NSDate
{
    class func dateWithString(time: String) -> NSDate
    {
        // 1.将服务器返回给我们的时间字符串转换为NSDate
        // 1.1.创建formatter
        let formatter = NSDateFormatter()
        // 1.2.设置时间的格式
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        // 1.3设置时间的区域(真机必须设置, 否则可能不能转换成功)
        formatter.locale = NSLocale(localeIdentifier: "en")
        // 1.4转换字符串, 转换好的时间是去除时区的时间
        let createdDate = formatter.dateFromString(time)!
        return createdDate
    }
    
    var descriptionDate: String
    {
        let calendar = NSCalendar.currentCalendar()
        
        if calendar.isDateInToday(self)
        {
            let since = Int(NSDate().timeIntervalSinceDate(self))
            
            if since < 60
            {
                return "刚刚"
            }
            
            if since < 60 * 60
            {
                return "\(since/60)分钟前"
            }
            
            return "\(since / (60 * 60))小时前"
        }
        
        var formatterString = "HH:mm"
        if calendar.isDateInYesterday(self)
        {
            formatterString = "昨天：" + formatterString
        }
        else
        {
            formatterString = "MM-dd " + formatterString
            
            let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            if comps.year >= 1
            {
                formatterString = "yyyy-" + formatterString
            }
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatterString
        formatter.locale = NSLocale(localeIdentifier: "en")
        return formatter.stringFromDate(self)
    }
}