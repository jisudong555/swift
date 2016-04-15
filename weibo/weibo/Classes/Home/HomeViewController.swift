//
//  HomeViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/8.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin {
            visitorView?.setupVisitorView(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        setupNavigationBar()
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeTitleArrow), name: PopoverAnimatorWillDismiss, object: nil)
    }
    
    func changeTitleArrow()
    {
        let titleButton = navigationItem.titleView as! TitleButton
        titleButton.selected = !titleButton.selected
    }

    private func setupNavigationBar()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(rightItemClick))
        
        let titleBtn = TitleButton()
        titleBtn.setTitle("素东", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: #selector(titleButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func titleButtonClick(button: TitleButton)
    {
        button.selected = !button.selected
        
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        vc?.transitioningDelegate = popoverAnimator
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func leftItemClick()
    {
        print(#function)
    }
    
    func rightItemClick()
    {
        print(#function)
    }
    
    private lazy var popoverAnimator: PopoverAnimator = {
        let pa = PopoverAnimator()
        let popoverFrameW: CGFloat = 200.0
        let popoverFrameX = (UIScreen.mainScreen().bounds.size.width - popoverFrameW) * 0.5
        pa.presentFrame = CGRect(x: popoverFrameX, y: 56, width: popoverFrameW, height: 300)
        return pa
    }()
}








