//
//  StatusTopView.swift
//  weibo
//
//  Created by jisudong on 16/5/18.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class StatusTopView: UIView {
    
    var status: Status?
    {
        didSet {
            nameLabel.text = status?.user?.name
            verifiedView.image = status?.user?.verifiedImage
            vipView.image = status?.user?.mbrankImage
            sourceLabel.text = status?.source
            timeLabel.text = status?.created_at
            if let url = status?.user?.imageURL
            {
                iconView.sd_setImageWithURL(url)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        iconView.snp_makeConstraints { (make) in
            make.top.left.equalTo(self).inset(UIEdgeInsetsMake(0, 10, 0, 0))
            make.size.equalTo(CGSizeMake(50, 50))
        }
        
        verifiedView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(15, 15))
            make.top.equalTo(iconView.snp_bottom).offset(-8)
            make.left.equalTo(iconView.snp_right).offset(-8)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(10)
            make.top.equalTo(iconView)
        }
        
        vipView.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_right).offset(8)
            make.top.equalTo(nameLabel)
            make.size.equalTo(CGSizeMake(14, 14))
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(10)
            make.bottom.equalTo(iconView.snp_bottom).offset(-5)
        }
        
        sourceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp_right).offset(10)
            make.top.equalTo(timeLabel)
            make.bottom.equalTo(self.snp_bottom)
        }
    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    /// 昵称
    private lazy var nameLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    /// 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)


}
