//
//  testViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/28.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        Alamofire.request(.GET, "http://www.kuaidi100.com/query?type=shentong&postid=227319601047").responseJSON { (response) in
//            print(response.request)
//            print(response.response)
//            print(response.result.value)
//            print(response.result.error)
//            
//            switch response.result
//            {
//            case .Success:
//                print()
//            case .Failure:
//                print()
//            }
//            
//        }
        
        let parameters = [
            "menu": "土豆",
            "pn":  1,
            "rn": "10",
            "key": "2ba215a3f83b4b898d0f6fdca4e16c7c",
            ]
        Alamofire.request(.POST, "http://apis.haoservice.com/lifeservice/cook/query?", parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            print(response.request)
            print(response.response)
            print(response.result.value)
            print(response.result.error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
