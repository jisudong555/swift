//
//  StatusForwardCell.swift
//  weibo
//
//  Created by jisudong on 16/5/20.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class StatusForwardCell: StatusCell {

    override var status: Status?
    {
        didSet {
            pictureView.status = status?.retweeted_status
            let size = pictureView.calculateImageSize()
            makeConstraints(size)
            
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            forwardLabel.text = name + "：" + text
        }
    }
    
    override func setupUI()
    {
        super.setupUI()
        
        container.insertSubview(forwardButton, belowSubview: pictureView)
        container.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        forwardButton.snp_makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
            make.left.equalTo(container.snp_left)
            make.right.equalTo(container.snp_right)
        }

        forwardLabel.snp_makeConstraints { (make) in
            make.top.equalTo(forwardButton).offset(5)
            make.left.equalTo(forwardButton).offset(10)
        }
        
        pictureView.snp_remakeConstraints { (make) in
            make.top.equalTo(forwardLabel.snp_bottom).offset(0)
            make.left.equalTo(forwardButton).offset(10)
            make.size.equalTo(CGSizeZero)
            make.bottom.equalTo(forwardButton.snp_bottom).offset(-10)
        }
    }
    
    private func makeConstraints(pictureSize: CGSize)
    {
        let topSpace = pictureSize.height == 0 ? 0 : 10
        pictureView.snp_updateConstraints { (make) in
            make.top.equalTo(forwardLabel.snp_bottom).offset(topSpace)
            make.size.equalTo(pictureSize)
        }
        
    }
    
    // MARK: - 懒加载
    private lazy var forwardLabel: UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
//        label.backgroundColor = UIColor.redColor()
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        label.setContentHuggingPriority(UILayoutPriorityDefaultLow + 1, forAxis: UILayoutConstraintAxis.Vertical)
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return button
    }()
    
    
    static let fakeCell = StatusForwardCell()
    class func cellHeightWithModel(model: Status) -> CGFloat
    {
        if (fabs(model.cellHeight - 0.0) < 0.00000001)
        {
            fakeCell.status = model
            model.cellHeight = fakeCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        }
        return model.cellHeight
    }

}
