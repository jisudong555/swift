//
//  OAuthViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/24.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    let AppKey = "859670333"
    let AppSecret = "5a9420f6cf369d6b6b052a7788c50b09"
    let Redirect_uri = "https://www.baidu.com"
    
    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "素东微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeOAuth))
        
        let path = "https://api.weibo.com/oauth2/authorize?client_id=\(AppKey)&redirect_uri=\(Redirect_uri)"
        let url = NSURL(string: path)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func closeOAuth()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let webview = UIWebView()
        webview.delegate = self
        return webview
    }()

}

extension OAuthViewController: UIWebViewDelegate
{
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        print(request.URL?.absoluteString)
        let url = request.URL?.absoluteString
        if !url!.hasPrefix(Redirect_uri)
        {
            return true
        }
        
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr)
        {
            print("授权成功")
            let code = request.URL!.query!.substringFromIndex(codeStr.endIndex)
            loadAccessToken(code)
            
        } else
        {
            print("授权失败")
        }
        
        return false
    }
    
    private func loadAccessToken(code: String)
    {
        let path = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id": AppKey,
                          "client_secret": AppSecret,
                          "grant_type": "authorization_code",
                          "code": code,
                          "redirect_uri": Redirect_uri
                          ]
        Alamofire.request(.POST, path, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil)
        .responseJSON { (response) in
            print(response.request)
            print(response.response)
            print(response.result.value)
            print(response.result.error)
            
            let account = UserAccount(dict: response.result.value as! [String: AnyObject])
            account.loadUserInfo({ (account, error) in
                if account != nil
                {
                    account!.saveAccount()
                }
                
                SVProgressHUD.showInfoWithStatus("网络不给力")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            })
        }
    }
}
