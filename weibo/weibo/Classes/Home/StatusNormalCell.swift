//
//  StatusNormalCell.swift
//  weibo
//
//  Created by jisudong on 16/5/20.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class StatusNormalCell: StatusCell {
    
        
    override var status: Status?
    {
        didSet {
            pictureView.status = status
            
            let size = pictureView.calculateImageSize()
            makeConstraints(size)
        }
    }
        
    private func makeConstraints(pictureSize: CGSize)
    {
        topView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(contentView).inset(UIEdgeInsetsMake(10, 0, 0, 0))
            make.height.equalTo(50)
        }
        
        contentLabel.snp_makeConstraints { (make) in
            make.left.equalTo(topView).offset(10)
            make.top.equalTo(topView.snp_bottom).offset(10)
        }
        
        let topSpace = pictureSize.height == 0 ? 0 : 10
        pictureView.snp_updateConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(topSpace)
            make.left.equalTo(topView).offset(10)
            make.size.equalTo(pictureSize)
        }
        
        footerView.snp_makeConstraints { (make) in
            make.top.equalTo(pictureView.snp_bottom).offset(10)
            make.left.bottom.right.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 100, 0))
            make.height.equalTo(35);
        }
    }
    
    static let fakeCell = StatusNormalCell()
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
