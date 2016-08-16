//
//  StatusBottomView.swift
//  weibo
//
//  Created by jisudong on 16/5/18.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class StatusBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        addSubview(retweetButton)
        addSubview(unlikeButton)
        addSubview(commonButton)
        
        
        retweetButton.snp_makeConstraints {
            [unowned self](make) in
            make.top.left.bottom.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
            make.right.equalTo(self.unlikeButton.snp_left)
            make.width.equalTo(self.unlikeButton)
        }
        
        unlikeButton.snp_makeConstraints {
            [unowned self](make) in
            make.top.bottom.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
            make.right.equalTo(self.commonButton.snp_left)
            make.width.equalTo(self.commonButton)
        }
        
        commonButton.snp_makeConstraints {
            [unowned self](make) in
            make.top.bottom.right.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    // MARK: - 懒加载
    /// 转发
    private lazy var retweetButton: UIButton = UIButton.createButton("timeline_icon_retweet", title: "转发")
    /// 赞
    private lazy var unlikeButton: UIButton = UIButton.createButton("timeline_icon_unlike", title: "赞")
    /// 评论
    private lazy var commonButton: UIButton = UIButton.createButton("timeline_icon_comment", title: "评论")

}
