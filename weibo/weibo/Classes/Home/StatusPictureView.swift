//
//  StatusPictureView.swift
//  weibo
//
//  Created by jisudong on 16/5/18.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

let PictureViewCellIdentifier = "PictureViewCellIdentifier"

class StatusPictureView: UICollectionView {
    var status: Status?
    {
        didSet {
            reloadData()
        }
    }
    
    private var pictureLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    init()
    {
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: PictureViewCellIdentifier)
        
        dataSource = self
//        delegate = self
        
        pictureLayout.minimumInteritemSpacing = 5
        pictureLayout.minimumLineSpacing = 5
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        
        backgroundColor = UIColor.whiteColor()
    }
    
    func calculateImageSize() -> CGSize
    {
        let count = status?.storedPicURLs?.count
        
        if count == 0 || count == nil
        {
            return CGSizeZero
        }
        
        if count == 1
        {
            let key = status?.storedPicURLs?.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            pictureLayout.itemSize = image.size
            return image.size
        }
        
        let width = (UIScreen.mainScreen().bounds.width - 30) / 3
        let height = width
        let margin: CGFloat = 5
        pictureLayout.itemSize = CGSize(width: width, height: height)
        if count == 4
        {
            let viewWidth = width * 2 + margin
            let viewHeight = viewWidth
            return CGSize(width: viewWidth, height: viewHeight)
        }
        
        // 计算九宫格的大小
        // 列数
        let colNumber = 3
        // 行数
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度
        let viewWidth = CGFloat(colNumber) * width + CGFloat(colNumber - 1) * margin
        // 高度
        let viewHeight = CGFloat(rowNumber) * height + CGFloat(rowNumber - 1) * margin
        
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
// MARK: - 私有类 - PictureViewCell
    private class PictureViewCell: UICollectionViewCell {
        var imageURL: NSURL?
        {
            didSet {
                iconImageView.sd_setImageWithURL(imageURL)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        private func setupUI()
        {
            contentView.addSubview(iconImageView)
            iconImageView.snp_makeConstraints { (make) in
                make.edges.equalTo(contentView)
            }
        }
        
        private lazy var iconImageView: UIImageView = UIImageView()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - 扩展
extension StatusPictureView: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PictureViewCellIdentifier, forIndexPath: indexPath) as! PictureViewCell
        
        cell.imageURL = status?.storedPicURLs![indexPath.row]
        
        return cell
    }
}
