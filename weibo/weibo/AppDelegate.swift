//
//  AppDelegate.swift
//  weibo
//
//  Created by jisudong on 16/4/7.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        return true
    }

    

}

