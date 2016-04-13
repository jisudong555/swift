//
//  HomeViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/8.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin {
            visitorView?.setupVisitorView(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        setupNavigationBar()
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
    }
    
    func leftItemClick()
    {
        print(#function)
    }
    
    func rightItemClick()
    {
        print(#function)
    }
}
