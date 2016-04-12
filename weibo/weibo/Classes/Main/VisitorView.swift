//
//  VisitorView.swift
//  weibo
//
//  Created by jisudong on 16/4/12.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit
import SnapKit

class VisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        
        iconView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        homeIcon.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconView.snp_bottom).offset(5)
            make.width.equalTo(250)
            make.centerX.equalTo(self)
        }
        
        registerButton.snp_makeConstraints { (make) in
            make.left.equalTo(messageLabel)
            make.top.equalTo(messageLabel.snp_bottom).offset(5)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        loginButton.snp_makeConstraints { (make) in
            make.right.equalTo(messageLabel)
            make.top.equalTo(messageLabel.snp_bottom).offset(5)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        maskBGView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    /// 转盘
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iconView
    }()
    /// 图标
    private lazy var homeIcon: UIImageView = {
        let homeIcon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return homeIcon
    }()
    /// 文本
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        label.text = "和贵金属打火机刚开始干就开始的考虑就刚开始了国际"
        return label
    }()
    /// 登陆按钮
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        button.setTitle("登陆", forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        return button
    }()
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.setTitle("注册", forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        return button
    }()
    /// 覆盖
    private lazy var maskBGView: UIImageView = {
        let mask = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return mask
    }()
}
