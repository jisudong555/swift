//
//  HomeViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/8.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit


class HomeViewController: BaseViewController {
    
    var statuses: [Status]?
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        
        if !userLogin {
            visitorView?.setupVisitorView(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        setupNavigationBar()
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeTitleArrow), name: PopoverAnimatorWillDismiss, object: nil)
        
        tableView.registerClass(StatusForwardCell.self, forCellReuseIdentifier: StatusCellReuseIdentifier.Forward.rawValue)
        tableView.registerClass(StatusNormalCell.self, forCellReuseIdentifier: StatusCellReuseIdentifier.Normal.rawValue)
        
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        refreshControl = HomeRefreshControl()
        
        refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: UIControlEvents.ValueChanged)
        
        loadData()
        
        
        
        
//        let instance = NetworkingManager.sharedInstance()
//        let instance1 = NetworkingManager.sharedInstance()
//        let instance2 = NetworkingManager()
//        
//        print("NetworkingManager: \(instance),   \(instance1),  \(instance2)")
        
    }
    
    private var pullupRefreshFlag = false
    
    @objc private func loadData()
    {
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        if pullupRefreshFlag
        {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        Status.loadStatues(since_id, max_id: max_id) { (models, error) in
            
            self.refreshControl?.endRefreshing()
            
            if error != nil
            {
                return
            }
            
            if since_id > 0
            {
                self.statuses = models! + self.statuses!
                self.showNewStatusCount(models?.count ?? 0)
            } else if max_id > 0
            {
                self.statuses = self.statuses! + models!
            } else
            {
                self.statuses = models
            }
        
        }
    }
    
    private func showNewStatusCount(count : Int)
    {
        newStatusLabel.hidden = false
        newStatusLabel.text = (count == 0) ? "没有刷新到新的微博数据" : "刷新到\(count)条微博数据"
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.newStatusLabel.transform = CGAffineTransformMakeTranslation(0, self.newStatusLabel.frame.height)
            
        }) { (_) -> Void in
            UIView.animateWithDuration(2, animations: { () -> Void in
                self.newStatusLabel.transform = CGAffineTransformIdentity
                }, completion: { (_) -> Void in
                    self.newStatusLabel.hidden = true
            })
        }
    }
    
    func changeTitleArrow()
    {
        let titleButton = navigationItem.titleView as! TitleButton
        titleButton.selected = !titleButton.selected
    }

    private func setupNavigationBar()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(rightItemClick))
        
        let titleBtn = TitleButton()
        titleBtn.setTitle("素东", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: #selector(titleButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func titleButtonClick(button: TitleButton)
    {
        button.selected = !button.selected
        
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        vc?.transitioningDelegate = popoverAnimator
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func leftItemClick()
    {
        print(#function)
    }
    
    func rightItemClick()
    {
        print(#function)
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    private lazy var popoverAnimator: PopoverAnimator = {
        let pa = PopoverAnimator()
        let popoverFrameW: CGFloat = 200.0
        let popoverFrameX = (UIScreen.mainScreen().bounds.size.width - popoverFrameW) * 0.5
        pa.presentFrame = CGRect(x: popoverFrameX, y: 56, width: popoverFrameW, height: 300)
        return pa
    }()
    
    /// 刷新提醒控件
    private lazy var newStatusLabel: UILabel =
        {
            let label = UILabel()
            let height: CGFloat = 44
            //        label.frame =  CGRect(x: 0, y: -2 * height, width: UIScreen.mainScreen().bounds.width, height: height)
            label.frame =  CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
            
            label.backgroundColor = UIColor.orangeColor()
            label.textColor = UIColor.whiteColor()
            label.textAlignment = NSTextAlignment.Center
            
            // 加载 navBar 上面，不会随着 tableView 一起滚动
            self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
            
            label.hidden = true
            return label
    }()

    
    // 缓存cell高度
    private var cellHeightCache = [Int: CGFloat]()
    
    override func didReceiveMemoryWarning() {
        cellHeightCache.removeAll()
    }
}

extension HomeViewController
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let status = statuses![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellReuseIdentifier.cellID(status), forIndexPath: indexPath) as! StatusCell
        
        cell.status = status
        
        let count = statuses?.count ?? 0
        if indexPath.row == (count - 1)
        {
            pullupRefreshFlag = true
            loadData()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statuses![indexPath.row]
        
//        if let cacheHeight = cellHeightCache[status.id]
//        {
//            print("缓存中获取")
//            return cacheHeight
//        }
        
        print("重新计算")
        var height: CGFloat = 0
        switch StatusCellReuseIdentifier.cellID(status) {
        case StatusCellReuseIdentifier.Normal.rawValue:
            height = StatusNormalCell.cellHeightWithModel(status)
        default:
            height = StatusForwardCell.cellHeightWithModel(status)
        }

        cellHeightCache[status.id] = height
        
        return  height
    }
}






