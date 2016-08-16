//
//  BaseViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/12.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController, VisitorViewDelegate {
    
    let userLogin = UserAccount.userLogin()
    var visitorView: VisitorView?
        
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    func setupVisitorView()
    {
        let customView = VisitorView()
        view = customView
        customView.delegate = self
        visitorView = customView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(registerButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(loginButtonClick))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    // MARK: - VisitorViewDelegate
    func loginButtonClick()
    {
        print(#function)
        
        let oauth = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauth)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func registerButtonClick()
    {
        print(#function)
    }

    
}
