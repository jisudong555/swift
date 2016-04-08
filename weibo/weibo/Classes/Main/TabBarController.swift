//
//  TabBarController.swift
//  weibo
//
//  Created by jisudong on 16/4/8.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.orangeColor()

        addViewController(HomeViewController(), imageName: "tabbar_home", title: "首页")
        addViewController(MessageViewController(), imageName: "tabbar_message_center", title: "消息")
        addViewController(DiscoverViewController(), imageName: "tabbar_discover", title: "发现")
        addViewController(ProfileViewController(), imageName: "tabbar_profile", title: "我")
    }

    func addViewController(childViewController: UIViewController, imageName: String, title: String)
    {
        childViewController.title = title
        childViewController.tabBarItem.image = UIImage(named: imageName)
        childViewController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        addChildViewController(childViewController)
    }

}
