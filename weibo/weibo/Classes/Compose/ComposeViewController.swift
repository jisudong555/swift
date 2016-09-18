//
//  ComposeViewController.swift
//  weibo
//
//  Created by 纪素东 on 16/9/19.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        setupInputView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    private func setupNav()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(sendStatus))
        
        let titleView = UIView(frame: CGRectMake(0, 0, 100, 32))
        
        let label1 = UILabel()
        label1.text = "发微博"
        label1.font = UIFont.systemFontOfSize(15)
        label1.sizeToFit()
        titleView.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = UserAccount.loadAccount()?.screen_name
        label2.font = UIFont.systemFontOfSize(13)
        label2.textColor = UIColor.darkGrayColor()
        label2.sizeToFit()
        titleView.addSubview(label2)
        
        label1.snp_makeConstraints { (make) in
            make.top.equalTo(titleView)
            make.centerX.equalTo(titleView)
        }
        
        label2.snp_makeConstraints { (make) in
            make.bottom.equalTo(titleView)
            make.centerX.equalTo(titleView)
        }
        
        navigationItem.titleView = titleView
        
    }
    
    private func setupInputView()
    {
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        
        textView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        placeholderLabel.snp_makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(8)
        }
    }
    
    func closeAction()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendStatus()
    {
        let path = "https://api.weibo.com/2/statuses/update.json"
        let paraters = ["access_token": UserAccount.loadAccount()?.access_token!, "status": textView.text]
        
        Alamofire.request(.POST, path, parameters: paraters, encoding: ParameterEncoding.URL, headers: nil)
        .responseJSON { (response) in
            if response.result.value != nil
            {
                print(response.result.value)
                SVProgressHUD.showSuccessWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
            } else
            {
                print(response.result.error)
                SVProgressHUD.showErrorWithStatus("发送失败", maskType: SVProgressHUDMaskType.Black)
            }
            
            
        }
    }
    
    // MARK: - 懒加载
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.darkGrayColor()
        label.text = "分享新鲜事..."
        return label
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}
