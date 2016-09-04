//
//  HomeRefreshControl.swift
//  weibo
//
//  Created by 纪素东 on 16/9/4.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit
import SnapKit

class HomeRefreshControl: UIRefreshControl {
    
    deinit
    {
        removeObserver(self, forKeyPath: "frame")
    }

    override init() {
        super.init()
        
        setupUI()
    }
    
    private func setupUI()
    {
        addSubview(refreshView)
        refreshView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(170, 60))
        }
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    private var rotationArrowFlag = false
    private var loadingViewAnimationFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if frame.origin.y >= 0
        {
            return
        }
        
        if refreshing && !loadingViewAnimationFlag
        {
            loadingViewAnimationFlag = true
            refreshView.startLoadingViewAnimation()
            return
        }
        
        if frame.origin.y >= -50 && rotationArrowFlag
        {
            rotationArrowFlag = false
            refreshView.rotationArrowIcon(rotationArrowFlag)
        } else if frame.origin.y < -50 && !rotationArrowFlag
        {
            rotationArrowFlag = true
            refreshView.rotationArrowIcon(rotationArrowFlag)
        }
        
    }
    
    override func endRefreshing()
    {
        super.endRefreshing()
        refreshView.stopLoadingViewAnimaton()
        
        loadingViewAnimationFlag = false
    }
    
    // MARK: - 懒加载
    private lazy var refreshView: HomeRefreshView = HomeRefreshView.refreshView()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class HomeRefreshView: UIView {
    
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    class func refreshView() -> HomeRefreshView
    {
        let v = NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
        
        return v
    }
    
    func rotationArrowIcon(flag: Bool)
    {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { 
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
    }
    
    func startLoadingViewAnimation()
    {
        tipView.hidden = true
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        // 该属性默认为YES, 代表动画只要执行完毕就移除
        anim.removedOnCompletion = false
        
        loadingImageView.layer.addAnimation(anim, forKey: nil)
    }
    
    func stopLoadingViewAnimaton()
    {
        tipView.hidden = false
        loadingImageView.layer.removeAllAnimations()
    }
}