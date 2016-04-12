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
        
        addChildViewControllers()
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupComposeButton()
    }
    
    func setupComposeButton()
    {
        tabBar.addSubview(composeButton)
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        let rect = CGRectMake(0, 0, width, 49)
        composeButton.frame = CGRectOffset(rect, width * 2, 0)
        
        
//        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
//        composeButton.frame = CGRectMake(0, 0, width, 49)
//        composeButton.center = tabBar.center
    }
    
    // MARK: - 懒加载
    private lazy var composeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: #selector(composeButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    // MARK: - Action
    func composeButtonAction()
    {
        print(#function)
    }
    
    // MARK: - 加载控制器
    private func addChildViewControllers()
    {
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        
        if let jsonPath = path {
            let data = NSData(contentsOfFile: jsonPath)
            do {
                let dictArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                for dict in dictArray as! [[String : String]]
                {
                    addViewController(dict["vcName"]!, imageName: dict["imageName"]!, title: dict["title"]!)
                }
            } catch {
                print(error)
                addViewController("HomeViewController", imageName: "tabbar_home", title: "首页")
                addViewController("MessageViewController", imageName: "tabbar_message_center", title: "消息")
                addViewController("NullViewController", imageName: "", title: "")
                addViewController("DiscoverViewController", imageName: "tabbar_discover", title: "发现")
                addViewController("ProfileViewController", imageName: "tabbar_profile", title: "我")
            }
        }
        
        
    }
    
    private func addViewController(childViewControllerName: String, imageName: String, title: String)
    {
        let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        let cls: AnyClass? = NSClassFromString(nameSpace + "." + childViewControllerName)
        let vcCls = cls as! UIViewController.Type
        let vc = vcCls.init()
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        let nav = UINavigationController(rootViewController: vc)
        addChildViewController(nav)
        print(vc)
    }
    

}
