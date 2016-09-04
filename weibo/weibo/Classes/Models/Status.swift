//
//  Status.swift
//  weibo
//
//  Created by jisudong on 16/4/28.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class Status: NSObject {
     /// 微博创建时间
    var created_at: String?
    {
        didSet {
            let createDate = NSDate.dateWithString(created_at!)
            created_at = createDate.descriptionDate
        }
    }
     /// 微博ID
    var id: Int = 0
     /// 微博信息内容
    var text: String?
     /// 微博来源
    var source: String?
    {
        didSet {
            if let str = source
            {
                guard str != "" else {
                    return
                }
                
                let startLocation = (str as NSString).rangeOfString(">").location + 1
                let length = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                source = "来自：" + (str as NSString).substringWithRange(NSMakeRange(startLocation, length))
            }
        }
    }
     /// 配图数组
    var pic_urls: [[String: AnyObject]]?
    {
        didSet {
            storedPicURLs = [NSURL]()
            for dict in pic_urls!
            {
                if let urlStr = dict["thumbnail_pic"]
                {
                    storedPicURLs?.append(NSURL(string: urlStr as! String)!)
                }
            }
        }
    }
    /// 用户信息
    var user: User?
    /// 保存当前微博所有配图的URL
    var storedPicURLs: [NSURL]?
    /// cell高度
    var cellHeight: CGFloat = 0
    /// 转发微博
    var retweeted_status: Status?
    /// 获取原创、转发微博的配图数组
    var pictureURLs: [NSURL]?
    {
        return retweeted_status != nil ? retweeted_status?.storedPicURLs : storedPicURLs
    }

    class func loadStatues(since_id: Int, max_id: Int, finished: (models: [Status]?, error: NSError?) -> ())
    {
        let path = "https://api.weibo.com/2/statuses/home_timeline.json"
        var params = ["access_token": UserAccount.loadAccount()!.access_token!]
        
        if since_id > 0
        {
            params["since_id"] = "\(since_id)"
        }
        
        if max_id > 0
        {
            params["max_id"] = "\(max_id)"
        }
        
        
        Alamofire.request(.GET, path, parameters: params, encoding: ParameterEncoding.URL, headers: nil)
            .responseJSON { (response) in
//                print(response.result.value)
                guard let value = response.result.value else {
                    finished(models: nil, error: response.result.error)
                    return
                }
                let arr = value.valueForKey("statuses") as! [[String: AnyObject]]
                let models = dict2Model(arr)
                cacheStatusImages(models, finished: finished)
            }
    }
    
    class func cacheStatusImages(list: [Status], finished: (models: [Status]?, error: NSError?) -> ())
    {
        let group = dispatch_group_create()
        
        // 1.缓存图片
        for status in list
        {
            guard let urls = status.pictureURLs else {
                continue
            }
            
            for url in urls
            {
                // 将当前的下载操作添加到组中
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) in
                    // 离开当前组
                    dispatch_group_leave(group)
                })
            }
        }
        // 2.当所有图片都下载完毕再通过闭包通知调用者
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            // 能够来到这个地方, 一定是所有图片都下载完毕
            finished(models: list, error: nil)
        }
    }
    
    // 字典数组转成模型数组
    class func dict2Model(list: [[String: AnyObject]]) -> [Status]
    {
        var models = [Status]()
        
        for dict in list
        {
            models.append(Status(dict: dict))
        }
        return models
    }
    
    // 自定义初始化方法，用于字典转模型
    init(dict: [String: AnyObject])
    {
        super.init()
        // 底层会调用 setValueForKey方法
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if "user" == key
        {
            user = User(dict: value as! [String: AnyObject])
            return
        }
        
        if "retweeted_status" == key
        {
            retweeted_status = Status(dict: value as! [String: AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
        
    }
    
    
}
