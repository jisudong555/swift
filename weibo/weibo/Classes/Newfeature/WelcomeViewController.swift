//
//  WelcomeViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/26.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        iconView.snp_makeConstraints { (make) in
            make.bottomMargin.equalTo(-150)
            make.centerX.equalTo(view)
        }
        
        if let iconUrl = UserAccount.loadAccount()?.avatar_large
        {
            let url = NSURL(string: iconUrl)
            iconView.sd_setImageWithURL(url)
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        // 去首页
        NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewControllerNotification, object: true)
    }
    
    // MARK: - 懒加载
    private lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView(image: UIImage(named: "avatar_default_big"))
        iconView.layer.cornerRadius = 50
        iconView.clipsToBounds = true
        return iconView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎回来"
        label.sizeToFit()
        label.alpha = 0.0
        return label
    }()
}
