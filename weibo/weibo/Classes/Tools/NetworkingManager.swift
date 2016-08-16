//
//  NetworkingManager.swift
//  weibo
//
//  Created by jisudong on 16/5/19.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

private let sharedKraken = NetworkingManager()

class NetworkingManager: NSObject {

    // 和OC相似写法
//    static var onceToken: dispatch_once_t = 0
//    static var instance: NetworkingManager? = nil
//    
//    class var sharedInstance: NetworkingManager {
//        
//        dispatch_once(&onceToken) { 
//            instance = NetworkingManager()
//        }
//        return instance!
//    }
    
    
//    class var sharedInstance: NetworkingManager {
//        struct Static {
//            static var onceToken: dispatch_once_t = 0
//            static var instance: NetworkingManager? = nil
//        }
//        
//        dispatch_once(&Static.onceToken) {
//            Static.instance = NetworkingManager()
//        }
//        return Static.instance!
//    }
    
//    class func sharedInstance() -> NetworkingManager {
//        struct Static {
//            static var onceToken: dispatch_once_t = 0
//            static var instance: NetworkingManager? = nil
//        }
//        
//        dispatch_once(&Static.onceToken) {
//            Static.instance = NetworkingManager()
//        }
//        return Static.instance!
//    }
    
    
    // 结构体方式写法
//    class var sharedInstance: NetworkingManager {
//        struct Static {
//            
//            static let instance = NetworkingManager()
//        }
//        return Static.instance
//    }
    
//    class func sharedInstance() -> NetworkingManager {
//        struct Static {
//            
//            static let instance = NetworkingManager()
//        }
//        return Static.instance
//    }
    
    // 全局变量写法
//    class var sharedInstance: NetworkingManager {
//        return sharedKraken
//    }
    
    class func sharedInstance() -> NetworkingManager
    {
        return sharedKraken
    }


    // 一句话写法
//    static let sharedInstance = NetworkingManager()
//    private override init() {
//        
//    }
    
//    static let instance = NetworkingManager()
//    class func sharedInstance() -> NetworkingManager
//    {
//        return instance
//    }
//    private override init() {
//        
//    }
}
