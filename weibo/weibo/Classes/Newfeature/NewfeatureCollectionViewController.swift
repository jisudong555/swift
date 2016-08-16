//
//  NewfeatureCollectionViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/26.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class NewfeatureCollectionViewController: UICollectionViewController {
    
    private let pageCount = 4
    private var layout: UICollectionViewFlowLayout = NewfeatureLayout()
    
    init()
    {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return pageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
    
        cell.imageIndex = indexPath.item
    
        return cell
    }
    
    // 完全显示一个cell之后调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        let path = collectionView.indexPathsForVisibleItems().last!
        if path.item == (pageCount - 1)
        {
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfeatureCell
            cell.startButtonAnimation()
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

// 如果当前类需要监听按钮的点击方法，那么当前类不能是私有的
class NewfeatureCell: UICollectionViewCell
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        startButton.hidden = true
    }
    
    func setupUI()
    {
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        iconView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        startButton.snp_makeConstraints { (make) in
            make.bottomMargin.equalTo(-160)
            make.centerX.equalTo(contentView)
        }
    }
    
    private var imageIndex: Int? {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    func startButtonAnimation()
    {
        startButton.hidden = false
        
        startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        startButton.userInteractionEnabled = false
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }, completion: {
                (_) -> Void in
                self.startButton.userInteractionEnabled = true
        })
    }
    
    // MARK: - 懒加载
    private lazy var iconView = UIImageView()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        button.hidden = true
        button.addTarget(self, action: #selector(customButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    func customButtonClick()
    {
        print(#function)
        // 去首页
        NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewControllerNotification, object: true)
    }
    
    
}

private class NewfeatureLayout: UICollectionViewFlowLayout
{
    /**
     准备布局
     */
    // 什么时候调用？ 1、先调用一个有多少行cell  2、调用准备布局  3、调用返回cell
    override func prepareLayout()
    {
        // 1.设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}





