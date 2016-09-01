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
        let topSpace = pictureSize.height == 0 ? 0 : 10
        pictureView.snp_updateConstraints { (make) in
            make.top.equalTo(contentLabel.snp_bottom).offset(topSpace)
            make.size.equalTo(pictureSize)
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
