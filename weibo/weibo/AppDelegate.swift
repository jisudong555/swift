//
//  AppDelegate.swift
//  weibo
//
//  Created by jisudong on 16/4/7.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

let SwitchRootViewControllerNotification = "SwitchRootViewControllerNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(switchRootViewController(_:)), name: SwitchRootViewControllerNotification, object: nil)
        
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func switchRootViewController(notify: NSNotification)
    {
        if notify.object as! Bool
        {
            window?.rootViewController = TabBarController()
        } else
        {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    func defaultController() -> UIViewController
    {
        if UserAccount.userLogin()
        {
            return isNewVersion() ? NewfeatureCollectionViewController() : WelcomeViewController()
        }
        return TabBarController()
    }

    func isNewVersion() -> Bool
    {
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        let sanboxVersion = NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        
        if currentVersion?.compare(sanboxVersion) == NSComparisonResult.OrderedDescending
        {
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        return false
    }

}

