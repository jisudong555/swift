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
        backgroundColor = UIColor.lightGrayColor()
        contentView.backgroundColor = UIColor.whiteColor()
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footerView)
    }

   // MARK: - 懒加载
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






