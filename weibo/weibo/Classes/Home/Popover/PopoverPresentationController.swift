//
//  PopoverPresentationController.swift
//  weibo
//
//  Created by jisudong on 16/4/14.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    
    var presentFrame = CGRectZero
    
    /**
     初始化方法，用于创建负责转场动画的对象
     
     - parameter presentedViewController:  被展现的控制器
     - parameter presentingViewController: 发起的控制器，Xcode6是nil，Xcode7是野指针
     
     - returns: 负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController)
    {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    /**
     即将布局转场子视图时调用
     */
    override func containerViewWillLayoutSubviews()
    {
        // 修改弹出视图的大小
//        presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        presentedView()?.frame = presentFrame
        
        // 在容器视图上添加一个蒙板，插入到展现视图的下面
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    func close()
    {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
