//
//  UserAccount.swift
//  weibo
//
//  Created by jisudong on 16/4/25.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

// Swift2.0 打印对象需要重写CustomStringConvertible协议中的description

class UserAccount: NSObject, NSCoding {
     /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
     /// access_token的生命周期，单位是秒数
    var expires_in: NSNumber? {
        didSet {
            expire_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
            print(expire_Date)
        }
    }
     /// 当前授权用户的UID
    var uid: String?
    /// 保存用户的过期时间
    var expire_Date: NSDate?
    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址
    var avatar_large: String?
    
    
    
    
    init(dict: [String: AnyObject])
    {
        super.init()
//        access_token = dict["access_token"] as? String
//        
//        expires_in = dict["expires_in"] as? NSNumber
//        uid = dict["uid"] as? String
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
        /// 重写description
    override var description: String {
        let properties = ["access_token", "expires_in", "uid", "expire_Date", "screen_name", "avatar_large"]
        let dict = self.dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    
    
    func loadUserInfo(finished: (account: UserAccount?, error: NSError?) -> ())
    {
        assert(access_token != nil, "没有授权")
        
        let path = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token": access_token!, "uid": uid!]
        
        Alamofire.request(.GET, path, parameters: params, encoding: ParameterEncoding.URL, headers: nil)
            .responseJSON { (response) in
                if let dict = response.result.value as? [String: AnyObject]
                {
                    self.screen_name = dict["screen_name"] as? String
                    self.avatar_large = dict["avatar_large"] as? String
                    finished(account: self, error: nil)
                    return
                }
                
                finished(account: nil, error: response.result.error)
        }
    }
    
    
    class func userLogin() -> Bool
    {
        return UserAccount.loadAccount() != nil
    }
    
    /**
     保存授权模型
     */
    func saveAccount()
    {
        NSKeyedArchiver.archiveRootObject(self, toFile: "account.plist".cacheDir())
    }
    
        /// 加载授权模型
    static var account: UserAccount?
    class func loadAccount() -> UserAccount?
    {
        if account != nil
        {
            return account
        }
        
        account = NSKeyedUnarchiver.unarchiveObjectWithFile("account.plist".cacheDir()) as? UserAccount
        
        // 判断授权是否过期
        if account?.expire_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending
        {
            // 已经过期
            return nil
        }
        
        return account
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expire_Date, forKey: "expire_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expire_Date = aDecoder.decodeObjectForKey("expire_Date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
}
