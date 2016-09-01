//
//  StatusCell.swift
//  weibo
//
//  Created by jisudong on 16/5/17.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

enum StatusCellReuseIdentifier: String {
    case Normal = "NormalCell"
    case Forward = "ForwardCell"
    
    static func cellID(status: Status) -> String
    {
        return status.retweeted_status != nil ? Forward.rawValue : Normal.rawValue
    }
    
}

class StatusCell: UITableViewCell {
    
//    var pictureWidthCons: ConstraintItem?
//    var pictureHeitghtCons: ConstraintItem?
//    var pictureTopCons: ConstraintItem?


    var status: Status?
    {
        didSet {
            topView.status = status
            contentLabel.text = status?.text
//            pictureView.status = status?.retweeted_status
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.whiteColor()
        contentView.backgroundColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        contentView.addSubview(container)
        container.addSubview(topView)
        container.addSubview(contentLabel)
        container.addSubview(pictureView)
        container.addSubview(footerView)
        
        container.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 10, 0))
        }
        
        topView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(container).inset(UIEdgeInsetsMake(10, 0, 0, 0))
            make.height.equalTo(50)
        }
        
        contentLabel.snp_makeConstraints { (make) in
            make.left.equalTo(topView).offset(10)
            make.top.equalTo(topView.snp_bottom).offset(10)
        }
        
        pictureView.snp_makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(0)
            make.left.equalTo(topView).offset(10)
            make.size.equalTo(CGSizeZero)
        }
        
        footerView.snp_makeConstraints { (make) in
            make.top.equalTo(pictureView.snp_bottom).offset(10)
            make.left.bottom.right.equalTo(container).inset(UIEdgeInsetsMake(0, 0, 0, 0))
            make.height.equalTo(35);
        }
    }

   // MARK: - 懒加载
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view;
    }()
    /// 顶部信息
    lazy var topView: StatusTopView = StatusTopView()
    
    /// 正文
    lazy var contentLabel: UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow+1, forAxis: UILayoutConstraintAxis.Vertical)
        label.numberOfLines = 0
//        label.shadowColor = UIColor.redColor()
//        label.shadowOffset = CGSizeMake(2.0, 2.0)
        return label
    }()
    
    /// 配图
    lazy var pictureView: StatusPictureView = StatusPictureView()
    
    /// 底部工具条
    lazy var footerView: StatusBottomView = StatusBottomView()
    
}






