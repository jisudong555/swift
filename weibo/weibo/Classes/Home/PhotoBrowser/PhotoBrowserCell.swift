//
//  PhotoBrowserCell.swift
//  weibo
//
//  Created by 纪素东 on 16/9/5.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate : NSObjectProtocol
{
    func photoBrowserCellDidClose(cell: PhotoBrowserCell)
}

class PhotoBrowserCell: UICollectionViewCell {
    
    weak var photoBrowserCellDelegate: PhotoBrowserCellDelegate?
    var imageURL: NSURL?
        {
        didSet {
            reset()
            
            activity.startAnimating()
            
            iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) in
                self.activity.stopAnimating()
                
                self.setImageViewPostion()
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
    
    func setupUI()
    {
        contentView.addSubview(scrollview)
        scrollview.addSubview(iconView)
        contentView.addSubview(activity)
        
        scrollview.frame = UIScreen.mainScreen().bounds
        activity.center = contentView.center
        
        scrollview.delegate = self
        scrollview.maximumZoomScale = 2.0
        scrollview.minimumZoomScale = 0.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction))
        iconView.addGestureRecognizer(tap)
        iconView.userInteractionEnabled = true
    }
    
    func closeAction()
    {
        photoBrowserCellDelegate?.photoBrowserCellDidClose(self)
    }
    
    func reset()
    {
        scrollview.contentInset = UIEdgeInsetsZero
        scrollview.contentOffset = CGPointZero
        scrollview.contentSize = CGSizeZero
        
        iconView.transform = CGAffineTransformIdentity
    }
    
    func setImageViewPostion()
    {
        let imageSize = self.displaySize(iconView.image!)
        
        if imageSize.height < UIScreen.mainScreen().bounds.height
        {
            iconView.frame = CGRect(origin: CGPointZero, size: imageSize)
            
            let y = (UIScreen.mainScreen().bounds.height - imageSize.height) * 0.5
            scrollview.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
        } else
        {
            iconView.frame = CGRect(origin: CGPointZero, size: imageSize)
            scrollview.contentSize = imageSize
        }
    }
    
    private func displaySize(image: UIImage) -> CGSize
    {
        // 1.拿到图片的宽高比
        let scale = image.size.height / image.size.width
        // 2.根据宽高比计算高度
        let width = UIScreen.mainScreen().bounds.width
        let height =  width * scale
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: - 懒加载
    private lazy var scrollview: UIScrollView = UIScrollView()
    lazy var iconView: UIImageView = UIImageView()
    private lazy var activity: UIActivityIndicatorView =  UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
}

extension PhotoBrowserCell: UIScrollViewDelegate
{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return iconView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        var offsetX = (UIScreen.mainScreen().bounds.width - view!.frame.width) * 0.5
        var offsetY = (UIScreen.mainScreen().bounds.height - view!.frame.height) * 0.5
        //        print("offsetX = \(offsetX), offsetY = \(offsetY)")
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    

}
