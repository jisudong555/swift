//
//  PopoverAnimator.swift
//  weibo
//
//  Created by jisudong on 16/4/15.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

// 定义常量保存通知名称
let PopoverAnimatorWillDismiss = "PopoverAnimatorWillDismiss"

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
{
    /// 记录当前是否打开
    var isPresent = false
    /// 保存菜单的大小
    var presentFrame = CGRectZero
    
    // 实现代理方法, 告诉系统谁来负责转场动画
    // UIPresentationController iOS8推出的专门用于负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        let popver = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        popver.presentFrame = presentFrame
        return popver
    }
    
    /**
     返回动画时长
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     
     - returns: 动画时长
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
    /**
     告诉系统如何动画，无论是展示还是消失都会调用这个方法
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        if isPresent
        {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            // 注意：一定要将视图添加到容器上
            transitionContext.containerView()?.addSubview(toView)
            
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            UIView.animateWithDuration(0.5, animations: {
                // 清空transform
                toView.transform = CGAffineTransformIdentity
            }) {
                (_) -> Void in
                // 执行完动画一定要告诉系统，不然可能会出现未知错误
                transitionContext.completeTransition(true)
            }
        } else
        {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            UIView.animateWithDuration(0.2, animations: {
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    
    // MRRK: - 只要实现了这个方法，那么系统自带的默认动画就没了，“所有”东西都需要自己来实现
    /**
     告诉系统谁来负责Modal的展现动画
     
     - parameter presented:  被展现视图
     - parameter presenting: 发起的视图
     - parameter source:
     
     - returns: 谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        return self
    }
    
    /**
     告诉系统谁来负责Modal的消失动画
     
     - parameter dismissed: 被关闭的视图
     
     - returns: 谁来负责
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
        NSNotificationCenter.defaultCenter().postNotificationName(PopoverAnimatorWillDismiss, object: self)
        return self
    }
    
    
}
